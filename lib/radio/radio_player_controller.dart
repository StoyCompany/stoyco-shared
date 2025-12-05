import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:stoyco_shared/stoyco_shared.dart';

/// Configuration for the [RadioPlayerController].
///
/// Provides the necessary dependencies and callbacks to control radio playback.
class RadioPlayerConfig {
  const RadioPlayerConfig({
    this.partnerId,
    required this.radioRepository,
    required this.trackingService,
    this.onPlayRadio,
    this.onTogglePlayPause,
    this.onStopRadio,
    this.onShareRadio,
    this.getCurrentPlayingRadioId,
    this.isAudioPlaying,
    this.playingRadioStream,
    this.isPlayingStream,
  });

  final String? partnerId;
  final RadioRepository radioRepository;
  final RadioTrackingService trackingService;
  final Future<void> Function(RadioModel radio, {bool isFromCOProfile})? onPlayRadio;
  final Future<void> Function(String radioId)? onTogglePlayPause;
  final Future<void> Function()? onStopRadio;
  final Future<void> Function(RadioModel radio)? onShareRadio;
  final String? Function()? getCurrentPlayingRadioId;
  final bool Function()? isAudioPlaying;
  final Stream<String?>? playingRadioStream;
  final Stream<bool>? isPlayingStream;
}

/// State object for the radio player.
///
/// Holds all the data needed by the UI to display the current playback state.
@immutable
class RadioPlayerState {
  const RadioPlayerState({
    this.radios = const [],
    this.currentPlayingRadioId,
  });

  final List<RadioModel> radios;
  final String? currentPlayingRadioId;

  RadioPlayerState copyWith({
    List<RadioModel>? radios,
    String? currentPlayingRadioId,
    bool clearCurrentRadio = false,
  }) =>
      RadioPlayerState(
        radios: radios ?? this.radios,
        currentPlayingRadioId:
            clearCurrentRadio ? null : (currentPlayingRadioId ?? this.currentPlayingRadioId),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadioPlayerState &&
          runtimeType == other.runtimeType &&
          _listEquals(radios, other.radios) &&
          currentPlayingRadioId == other.currentPlayingRadioId;

  @override
  int get hashCode => Object.hash(Object.hashAll(radios), currentPlayingRadioId);

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Controller for the radio player.
///
/// Manages radio playback state and provides reactive updates via ValueNotifiers.
///
/// Uses ValueNotifier pattern for granular UI updates:
/// - [isLoadingListenable] for loading state
/// - [stateListenable] for main state (radios, error, etc.)
/// - [isPlayingListenable] for play/pause state changes
///
/// This allows widgets to listen only to what they need,
/// minimizing unnecessary rebuilds.
class RadioPlayerController extends ChangeNotifier {
  RadioPlayerController({
    required this.config,
  }) {
    _init();
  }

  final RadioPlayerConfig config;

  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<RadioPlayerState> _stateNotifier =
      ValueNotifier<RadioPlayerState>(const RadioPlayerState());
  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier<bool>(false);

  StreamSubscription<List<RadioModel>>? _radiosSubscription;
  StreamSubscription<String?>? _playbackSubscription;
  StreamSubscription<bool>? _isPlayingSubscription;

  ValueListenable<bool> get isLoadingListenable => _isLoadingNotifier;

  ValueListenable<RadioPlayerState> get stateListenable => _stateNotifier;

  ValueListenable<bool> get isPlayingListenable => _isPlayingNotifier;

  bool get isLoading => _isLoadingNotifier.value;

  RadioPlayerState get state => _stateNotifier.value;

  List<RadioModel> get radios => _stateNotifier.value.radios;

  String? get currentPlayingRadioId => _stateNotifier.value.currentPlayingRadioId;

  void _init() {
    _loadRadios();
    _syncCurrentPlaybackState();
    _listenToPlaybackChanges();
  }

  void _syncCurrentPlaybackState() {
    if (config.getCurrentPlayingRadioId == null) return;

    final currentRadioId = config.getCurrentPlayingRadioId!();
    if (currentRadioId != null) {
      _stateNotifier.value = _stateNotifier.value.copyWith(
        currentPlayingRadioId: currentRadioId,
      );
    }
    _updateIsPlaying();
  }

  void _loadRadios() {
    _isLoadingNotifier.value = true;
    notifyListeners();

    final radiosStream = config.partnerId != null
        ? config.radioRepository.getRadiosByPartner(config.partnerId!)
        : config.radioRepository.getActiveRadios();

    _radiosSubscription = radiosStream.listen(
      (radiosList) {
        _stateNotifier.value = _stateNotifier.value.copyWith(radios: radiosList);
        _isLoadingNotifier.value = false;
        notifyListeners();
      },
      onError: (e) {
        _isLoadingNotifier.value = false;
        StoyCoLogger.error('[RadioPlayerController] Error loading radios', error: e);
        notifyListeners();
      },
    );
  }

  void _listenToPlaybackChanges() {
    if (config.playingRadioStream != null) {
      _playbackSubscription = config.playingRadioStream!.listen(
        (radioId) {
          final previousRadioId = _stateNotifier.value.currentPlayingRadioId;

          if (previousRadioId != null && radioId != previousRadioId) {
            config.trackingService.stopListening(previousRadioId).catchError((e) {
              StoyCoLogger.error(
                '[RadioPlayerController] Error stopping tracking for previous radio',
                error: e,
              );
            });
          }

          _stateNotifier.value = radioId != null
              ? _stateNotifier.value.copyWith(currentPlayingRadioId: radioId)
              : _stateNotifier.value.copyWith(clearCurrentRadio: true);

          _updateIsPlaying();
          notifyListeners();
        },
        onError: (e) {
          StoyCoLogger.error(
            '[RadioPlayerController] Error listening to playback stream',
            error: e,
          );
        },
        cancelOnError: false,
      );
    }

    if (config.isPlayingStream != null) {
      _isPlayingSubscription = config.isPlayingStream!.listen(
        (isPlaying) {
          _isPlayingNotifier.value = isPlaying;
          notifyListeners();
        },
        onError: (e) {
          StoyCoLogger.error(
            '[RadioPlayerController] Error listening to isPlaying stream',
            error: e,
          );
        },
        cancelOnError: false,
      );
    }
  }

  void _updateIsPlaying() {
    _isPlayingNotifier.value = config.isAudioPlaying?.call() ?? false;
  }

  /// Plays a radio station.
  void playRadio(RadioModel radio) {
    if (config.onPlayRadio == null) {
      return;
    }

    if (!radio.hasStreamUrl) {
      StoyCoLogger.error('[RadioPlayerController] Radio has no stream URL: ${radio.id}');
      return;
    }

    _stateNotifier.value = _stateNotifier.value.copyWith(
      currentPlayingRadioId: radio.id,
    );
    notifyListeners();

    unawaited(
      config.trackingService.startListening(radio.id).catchError((e) {
        StoyCoLogger.error('[RadioPlayerController] Error starting tracking', error: e);
      }),
    );

    unawaited(
      config.onPlayRadio!(radio, isFromCOProfile: true).catchError((e) {
        StoyCoLogger.error('[RadioPlayerController] Error playing radio', error: e);
      }),
    );
  }

  /// Toggles play/pause for a radio station.
  void togglePlayPause(String radioId) {
    if (config.onTogglePlayPause == null) {
      return;
    }

    unawaited(
      config.onTogglePlayPause!(radioId).catchError((e) {
        StoyCoLogger.error(
          '[RadioPlayerController] Error toggling play/pause',
          error: e,
        );
      }),
    );
  }

  /// Stops radio playback.
  void stopRadio() {
    if (config.onStopRadio == null) {
      return;
    }

    final currentRadioId = _stateNotifier.value.currentPlayingRadioId;
    if (currentRadioId != null) {
      unawaited(
        config.trackingService.stopListening(currentRadioId).catchError((e) {
          StoyCoLogger.error('[RadioPlayerController] Error stopping tracking', error: e);
        }),
      );
    }

    _stateNotifier.value = _stateNotifier.value.copyWith(clearCurrentRadio: true);
    _isPlayingNotifier.value = false;
    notifyListeners();

    unawaited(
      config.onStopRadio!().catchError((e) {
        StoyCoLogger.error('[RadioPlayerController] Error stopping radio', error: e);
      }),
    );
  }

  Stream<int> getListenerCount(String radioId) =>
      config.trackingService.watchListenerCount(radioId);

  bool isRadioPlaying(String radioId) {
    final currentId = _stateNotifier.value.currentPlayingRadioId;
    return currentId == radioId && _isPlayingNotifier.value;
  }

  /// Shares a radio station.
  void shareRadio(RadioModel radio) {
    if (config.onShareRadio == null) {
      return;
    }

    unawaited(
      config.onShareRadio!(radio).catchError((e) {
        StoyCoLogger.error('[RadioPlayerController] Error sharing radio', error: e);
      }),
    );
  }

  void refreshPlaybackState() {
    _syncCurrentPlaybackState();
  }

  @override
  void dispose() {
    _radiosSubscription?.cancel();
    _playbackSubscription?.cancel();
    _isPlayingSubscription?.cancel();
    _isLoadingNotifier.dispose();
    _stateNotifier.dispose();
    _isPlayingNotifier.dispose();
    super.dispose();
  }
}
