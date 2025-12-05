import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stoyco_shared/models/radio_model.dart';
import 'package:stoyco_shared/radio/radio_service.dart';
import 'package:stoyco_shared/utils/logger.dart';

/// Configuration for [RadioPlayerController].
///
/// Provides callbacks for audio playback integration.
/// The controller uses [RadioService] internally for data and tracking.
class RadioPlayerConfig {
  const RadioPlayerConfig({
    this.partnerId,
    this.onPlayRadio,
    this.onTogglePlayPause,
    this.onStopRadio,
    this.onShareRadio,
    this.getCurrentPlayingRadioId,
    this.isAudioPlaying,
    this.playingRadioStream,
    this.isPlayingStream,
  });

  /// Filter radios by partner/community owner ID.
  final String? partnerId;

  /// Callback when a radio should start playing.
  final Future<void> Function(RadioModel radio)? onPlayRadio;

  /// Callback to toggle play/pause.
  final Future<void> Function(String radioId)? onTogglePlayPause;

  /// Callback to stop playback.
  final Future<void> Function()? onStopRadio;

  /// Callback to share a radio.
  final Future<void> Function(RadioModel radio)? onShareRadio;

  /// Returns the currently playing radio ID (sync).
  final String? Function()? getCurrentPlayingRadioId;

  /// Returns whether audio is currently playing (sync).
  final bool Function()? isAudioPlaying;

  /// Stream of currently playing radio ID changes.
  final Stream<String?>? playingRadioStream;

  /// Stream of play/pause state changes.
  final Stream<bool>? isPlayingStream;
}

/// State for the radio player UI.
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
        currentPlayingRadioId: clearCurrentRadio
            ? null
            : (currentPlayingRadioId ?? this.currentPlayingRadioId),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadioPlayerState &&
          runtimeType == other.runtimeType &&
          listEquals(radios, other.radios) &&
          currentPlayingRadioId == other.currentPlayingRadioId;

  @override
  int get hashCode => Object.hash(Object.hashAll(radios), currentPlayingRadioId);
}

/// Controller for the radio player widget.
///
/// Manages playback state and provides reactive updates via ValueNotifiers.
class RadioPlayerController extends ChangeNotifier {
  RadioPlayerController({
    required this.config,
    RadioService? radioService,
  }) : _radioService = radioService ?? RadioService() {
    _init();
  }

  final RadioPlayerConfig config;
  final RadioService _radioService;

  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<RadioPlayerState> _stateNotifier =
      ValueNotifier<RadioPlayerState>(const RadioPlayerState());
  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier<bool>(false);

  StreamSubscription<String?>? _playbackSubscription;
  StreamSubscription<bool>? _isPlayingSubscription;

  /// Listenable for loading state.
  ValueListenable<bool> get isLoadingListenable => _isLoadingNotifier;

  /// Listenable for player state (radios list, current radio).
  ValueListenable<RadioPlayerState> get stateListenable => _stateNotifier;

  /// Listenable for play/pause state.
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

  Future<void> _loadRadios() async {
    _isLoadingNotifier.value = true;

    try {
      final radiosList = config.partnerId != null
          ? await _radioService.getRadiosByPartner(config.partnerId!)
          : await _radioService.getActiveRadios();

      _stateNotifier.value = _stateNotifier.value.copyWith(radios: radiosList);
    } catch (e) {
      StoyCoLogger.error('[RadioPlayerController] Error loading radios', error: e);
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  void _listenToPlaybackChanges() {
    if (config.playingRadioStream != null) {
      _playbackSubscription = config.playingRadioStream!.listen(
        (radioId) {
          final previousRadioId = _stateNotifier.value.currentPlayingRadioId;

          if (previousRadioId != null && radioId != previousRadioId) {
            unawaited(_radioService.stopListening(previousRadioId));
          }

          _stateNotifier.value = radioId != null
              ? _stateNotifier.value.copyWith(currentPlayingRadioId: radioId)
              : _stateNotifier.value.copyWith(clearCurrentRadio: true);

          _updateIsPlaying();
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
    if (config.onPlayRadio == null) return;

    if (!radio.hasStreamUrl) {
      StoyCoLogger.error('[RadioPlayerController] Radio has no stream URL: ${radio.id}');
      return;
    }

    _stateNotifier.value = _stateNotifier.value.copyWith(
      currentPlayingRadioId: radio.id,
    );

    unawaited(_radioService.startListening(radio.id));
    unawaited(
      config.onPlayRadio!(radio).catchError((e) {
        StoyCoLogger.error('[RadioPlayerController] Error playing radio', error: e);
      }),
    );
  }

  /// Toggles play/pause for a radio station.
  void togglePlayPause(String radioId) {
    if (config.onTogglePlayPause == null) return;

    unawaited(
      config.onTogglePlayPause!(radioId).catchError((e) {
        StoyCoLogger.error('[RadioPlayerController] Error toggling play/pause', error: e);
      }),
    );
  }

  /// Stops radio playback.
  void stopRadio() {
    if (config.onStopRadio == null) return;

    final currentRadioId = _stateNotifier.value.currentPlayingRadioId;
    if (currentRadioId != null) {
      unawaited(_radioService.stopListening(currentRadioId));
    }

    _stateNotifier.value = _stateNotifier.value.copyWith(clearCurrentRadio: true);
    _isPlayingNotifier.value = false;

    unawaited(
      config.onStopRadio!().catchError((e) {
        StoyCoLogger.error('[RadioPlayerController] Error stopping radio', error: e);
      }),
    );
  }

  /// Gets the listener count stream for a radio.
  Stream<int> getListenerCount(String radioId) =>
      _radioService.watchListenerCount(radioId);

  /// Checks if a specific radio is currently playing.
  bool isRadioPlaying(String radioId) {
    final currentId = _stateNotifier.value.currentPlayingRadioId;
    return currentId == radioId && _isPlayingNotifier.value;
  }

  /// Shares a radio station.
  void shareRadio(RadioModel radio) {
    if (config.onShareRadio == null) return;

    unawaited(
      config.onShareRadio!(radio).catchError((e) {
        StoyCoLogger.error('[RadioPlayerController] Error sharing radio', error: e);
      }),
    );
  }

  /// Refreshes the current playback state from external source.
  void refreshPlaybackState() {
    _syncCurrentPlaybackState();
  }

  @override
  void dispose() {
    _playbackSubscription?.cancel();
    _isPlayingSubscription?.cancel();
    _isLoadingNotifier.dispose();
    _stateNotifier.dispose();
    _isPlayingNotifier.dispose();
    super.dispose();
  }
}
