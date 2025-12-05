import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:stoyco_shared/stoyco_shared.dart';

/// Configuration object for RadioTabController
/// This is what the app needs to provide to configure the radio tab
class RadioTabConfig {
  const RadioTabConfig({
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

/// Radio tab state that holds all the data needed by the UI
@immutable
class RadioTabState {
  const RadioTabState({
    this.radios = const [],
    this.currentPlayingRadioId,
    this.error,
    this.isChangingStation = false,
  });

  final List<RadioModel> radios;
  final String? currentPlayingRadioId;
  final String? error;
  final bool isChangingStation;

  RadioTabState copyWith({
    List<RadioModel>? radios,
    String? currentPlayingRadioId,
    String? error,
    bool? isChangingStation,
    bool clearCurrentRadio = false,
    bool clearError = false,
  }) =>
      RadioTabState(
        radios: radios ?? this.radios,
        currentPlayingRadioId:
            clearCurrentRadio ? null : (currentPlayingRadioId ?? this.currentPlayingRadioId),
        error: clearError ? null : (error ?? this.error),
        isChangingStation: isChangingStation ?? this.isChangingStation,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadioTabState &&
          runtimeType == other.runtimeType &&
          _listEquals(radios, other.radios) &&
          currentPlayingRadioId == other.currentPlayingRadioId &&
          error == other.error &&
          isChangingStation == other.isChangingStation;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(radios), currentPlayingRadioId, error, isChangingStation);

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Controller for the radio tab in the CO profile
///
/// Uses ValueNotifier pattern for granular UI updates:
/// - [isLoadingListenable] for loading state
/// - [stateListenable] for main state (radios, error, etc.)
/// - [isPlayingListenable] for play/pause state changes
///
/// This allows widgets to listen only to what they need,
/// minimizing unnecessary rebuilds.
class RadioTabController extends ChangeNotifier {
  RadioTabController({
    required this.config,
  }) {
    _init();
  }

  final RadioTabConfig config;

  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<RadioTabState> _stateNotifier =
      ValueNotifier<RadioTabState>(const RadioTabState());
  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier<bool>(false);

  StreamSubscription<List<RadioModel>>? _radiosSubscription;
  StreamSubscription<String?>? _playbackSubscription;
  StreamSubscription<bool>? _isPlayingSubscription;

  ValueListenable<bool> get isLoadingListenable => _isLoadingNotifier;

  ValueListenable<RadioTabState> get stateListenable => _stateNotifier;

  ValueListenable<bool> get isPlayingListenable => _isPlayingNotifier;

  bool get isLoading => _isLoadingNotifier.value;

  RadioTabState get state => _stateNotifier.value;

  List<RadioModel> get radios => _stateNotifier.value.radios;

  String? get currentPlayingRadioId => _stateNotifier.value.currentPlayingRadioId;

  String? get error => _stateNotifier.value.error;

  bool get isChangingStation => _stateNotifier.value.isChangingStation;

  void _init() {
    _loadRadios();
    _syncCurrentPlaybackState();
    _listenToPlaybackChanges();
  }

  void _syncCurrentPlaybackState() {
    if (config.getCurrentPlayingRadioId != null) {
      try {
        final currentRadioId = config.getCurrentPlayingRadioId!();
        if (currentRadioId != null) {
          _stateNotifier.value = _stateNotifier.value.copyWith(
            currentPlayingRadioId: currentRadioId,
          );
        }
        _updateIsPlaying();
      } catch (e) {
        StoyCoLogger.error('Error syncing playback state', error: e);
      }
    }
  }

  void _loadRadios() {
    _isLoadingNotifier.value = true;
    _stateNotifier.value = _stateNotifier.value.copyWith(clearError: true);
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
        _stateNotifier.value = _stateNotifier.value.copyWith(
          error: 'Error loading radios: $e',
        );
        _isLoadingNotifier.value = false;
        notifyListeners();
      },
    );
  }

  void _listenToPlaybackChanges() {
    if (config.playingRadioStream != null) {
      _playbackSubscription = config.playingRadioStream!.listen(
        (radioId) {
          final previousRadioId = _stateNotifier.value.currentPlayingRadioId;

          if (previousRadioId != null &&
              previousRadioId.isNotEmpty &&
              radioId != previousRadioId) {
            config.trackingService.stopListening(previousRadioId).catchError((e) {
              StoyCoLogger.error(
                '[RadioTabController] Error stopping tracking for previous radio',
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
            '[RadioTabController] Error listening to playback stream',
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
            '[RadioTabController] Error listening to isPlaying stream',
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


  Future<void> playRadio(RadioModel radio) async {
    if (_stateNotifier.value.isChangingStation || config.onPlayRadio == null) {
      return;
    }

    try {
      _stateNotifier.value = _stateNotifier.value.copyWith(
        isChangingStation: true,
        clearError: true,
      );
      notifyListeners();

      if (!radio.hasStreamUrl) {
        _stateNotifier.value = _stateNotifier.value.copyWith(
          error: 'Esta radio no tiene URL de streaming disponible',
          isChangingStation: false,
        );
        notifyListeners();
        return;
      }

      _stateNotifier.value = _stateNotifier.value.copyWith(
        currentPlayingRadioId: radio.id,
        isChangingStation: false,
      );
      notifyListeners();

      unawaited(
        config.onPlayRadio!(radio, isFromCOProfile: true).catchError((e) {
          _stateNotifier.value = _stateNotifier.value.copyWith(
            error: 'Error al reproducir: $e',
          );
          StoyCoLogger.error('[RadioTabController] Error playing radio', error: e);
          notifyListeners();
        }),
      );
    } catch (e) {
      _stateNotifier.value = _stateNotifier.value.copyWith(
        error: 'Error al reproducir: $e',
        isChangingStation: false,
      );
      StoyCoLogger.error('[RadioTabController] Error playing radio', error: e);
      notifyListeners();
    }
  }

  /// Toggles play/pause for a radio station
  Future<void> togglePlayPause(String radioId) async {
    if (_stateNotifier.value.isChangingStation || config.onTogglePlayPause == null) {
      return;
    }

    try {
      unawaited(
        config.onTogglePlayPause!(radioId).catchError((e) {
          _stateNotifier.value = _stateNotifier.value.copyWith(
            error: 'Error al pausar/reproducir: $e',
          );
          StoyCoLogger.error(
            '[RadioTabController] Error toggling play/pause',
            error: e,
          );
          notifyListeners();
        }),
      );
    } catch (e) {
      _stateNotifier.value = _stateNotifier.value.copyWith(
        error: 'Error al pausar/reproducir: $e',
      );
      StoyCoLogger.error(
        '[RadioTabController] Error toggling play/pause',
        error: e,
      );
      notifyListeners();
    }
  }

  /// Stops radio playback
  Future<void> stopRadio() async {
    if (config.onStopRadio == null) {
      return;
    }

    try {
      await config.onStopRadio!();
      _stateNotifier.value = _stateNotifier.value.copyWith(clearCurrentRadio: true);
      _isPlayingNotifier.value = false;
      notifyListeners();
    } catch (e) {
      _stateNotifier.value = _stateNotifier.value.copyWith(
        error: 'Error al detener: $e',
      );
      StoyCoLogger.error('[RadioTabController] Error stopping radio', error: e);
      notifyListeners();
    }
  }

  Stream<int> getListenerCount(String radioId) =>
      config.radioRepository.watchListenerCount(radioId);

  bool isRadioPlaying(String radioId) {
    final currentId = _stateNotifier.value.currentPlayingRadioId;
    return currentId == radioId && _isPlayingNotifier.value;
  }

  Future<void> shareRadio(RadioModel radio) async {
    if (config.onShareRadio == null) {
      return;
    }

    try {
      await config.onShareRadio!(radio);
    } catch (e) {
      _stateNotifier.value = _stateNotifier.value.copyWith(
        error: 'Error al compartir: $e',
      );
      StoyCoLogger.error('[RadioTabController] Error sharing radio', error: e);
      notifyListeners();
    }
  }

  void refreshPlaybackState() {
    _syncCurrentPlaybackState();
  }

  void clearError() {
    if (_stateNotifier.value.error != null) {
      _stateNotifier.value = _stateNotifier.value.copyWith(clearError: true);
      notifyListeners();
    }
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
