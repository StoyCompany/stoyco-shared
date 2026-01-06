import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stoyco_shared/models/radio_model.dart';
import 'package:stoyco_shared/radio/radio_player_config.dart';
import 'package:stoyco_shared/radio/radio_player_state.dart';
import 'package:stoyco_shared/radio/radio_service.dart';
import 'package:stoyco_shared/utils/logger.dart';

/// Controller for the radio player widget.
///
/// Manages playback state and provides reactive updates via [ValueNotifier]s.
///
/// Example:
/// ```dart
/// final controller = RadioPlayerController(
///   config: RadioPlayerConfig(onPlayRadio: (radio) async => ...),
/// );
/// controller.playRadio(radio);
/// ```
class RadioPlayerController extends ChangeNotifier {
  /// Creates a radio player controller.
  ///
  /// [config] Configuration with callbacks for playback events.
  /// Uses [config.radioService] if provided, otherwise creates a new instance.
  RadioPlayerController({
    required this.config,
  }) : _radioService = config.radioService ?? RadioService() {
    _init();
  }

  /// Configuration for callbacks and streams.
  final RadioPlayerConfig config;
  final RadioService _radioService;

  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<RadioPlayerState> _stateNotifier =
      ValueNotifier<RadioPlayerState>(const RadioPlayerState());
  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isBufferingNotifier = ValueNotifier<bool>(false);

  StreamSubscription<String?>? _playbackSubscription;
  StreamSubscription<bool>? _isPlayingSubscription;
  StreamSubscription<bool>? _isBufferingSubscription;

  /// Listenable for loading state changes.
  ValueListenable<bool> get isLoadingListenable => _isLoadingNotifier;

  /// Listenable for player state changes.
  ValueListenable<RadioPlayerState> get stateListenable => _stateNotifier;

  /// Listenable for play/pause state changes.
  ValueListenable<bool> get isPlayingListenable => _isPlayingNotifier;

  /// Listenable for buffering state changes.
  ValueListenable<bool> get isBufferingListenable => _isBufferingNotifier;

  /// Whether radios are currently loading.
  bool get isLoading => _isLoadingNotifier.value;

  /// Current player state.
  RadioPlayerState get state => _stateNotifier.value;

  /// List of available radios.
  List<RadioModel> get radios => _stateNotifier.value.radios;

  /// ID of the currently playing radio, or `null` if stopped.
  String? get currentPlayingRadioId => _stateNotifier.value.currentPlayingRadioId;

  /// Whether audio is currently buffering.
  bool get isBuffering => _isBufferingNotifier.value;

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
    _updateIsBuffering();
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
          if (isPlaying) {
            _isBufferingNotifier.value = false;
          }
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

    if (config.isBufferingStream != null) {
      _isBufferingSubscription = config.isBufferingStream!.listen(
        (isBuffering) {
          _isBufferingNotifier.value = isBuffering;
        },
        onError: (e) {
          StoyCoLogger.error(
            '[RadioPlayerController] Error listening to isBuffering stream',
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

  void _updateIsBuffering() {
    _isBufferingNotifier.value = config.isAudioBuffering?.call() ?? false;
  }

  /// Plays a radio station.
  ///
  /// [radio] The radio to play.
  /// Invokes `onPlayRadio` callback. Listener tracking is handled by the app's audio service.
  void playRadio(RadioModel radio) {
    if (config.onPlayRadio == null) return;

    if (!radio.hasStreamUrl) {
      StoyCoLogger.error('[RadioPlayerController] Radio has no stream URL: ${radio.id}');
      return;
    }

    _isBufferingNotifier.value = true;

    _stateNotifier.value = _stateNotifier.value.copyWith(
      currentPlayingRadioId: radio.id,
    );

    unawaited(
      config.onPlayRadio!(radio).catchError((e) {
        _isBufferingNotifier.value = false;
        StoyCoLogger.error('[RadioPlayerController] Error playing radio', error: e);
      }),
    );
  }

  /// Toggles play/pause for a radio station.
  ///
  /// [radioId] The ID of the radio to toggle.
  /// Invokes `onTogglePlayPause` callback. Listener tracking is handled by the app's audio service.
  void togglePlayPause(String radioId) {
    if (config.onTogglePlayPause == null) return;

    if (!_isPlayingNotifier.value) {
      _isBufferingNotifier.value = true;
    }

    unawaited(
      config.onTogglePlayPause!(radioId).catchError((e) {
        _isBufferingNotifier.value = false;
        StoyCoLogger.error('[RadioPlayerController] Error toggling play/pause', error: e);
      }),
    );
  }

  /// Stops radio playback.
  ///
  /// Invokes `onStopRadio` callback. Listener tracking is handled by the app's audio service.
  void stopRadio() {
    if (config.onStopRadio == null) return;

    _stateNotifier.value = _stateNotifier.value.copyWith(clearCurrentRadio: true);
    _isPlayingNotifier.value = false;
    _isBufferingNotifier.value = false;

    unawaited(
      config.onStopRadio!().catchError((e) {
        StoyCoLogger.error('[RadioPlayerController] Error stopping radio', error: e);
      }),
    );
  }

  /// Gets the playback count stream for a radio.
  ///
  /// [radioId] The radio document ID.
  /// Returns a [Stream] emitting the current playback count.
  Stream<int> getListenerCount(String radioId) =>
      _radioService.watchPlaybackCount(radioId);

  /// Checks if a specific radio is currently playing.
  ///
  /// [radioId] The ID of the radio to check.
  /// Returns `true` if the radio is playing.
  bool isRadioPlaying(String radioId) {
    final currentId = _stateNotifier.value.currentPlayingRadioId;
    return currentId == radioId && _isPlayingNotifier.value;
  }

  /// Shares a radio station.
  ///
  /// [radio] The radio to share.
  /// Invokes `onShareRadio` callback.
  void shareRadio(RadioModel radio) {
    if (config.onShareRadio == null) return;

    unawaited(
      config.onShareRadio!(radio).catchError((e) {
        StoyCoLogger.error('[RadioPlayerController] Error sharing radio', error: e);
      }),
    );
  }

  /// Refreshes the current playback state from external source.
  ///
  /// Re-syncs the controller state with `getCurrentPlayingRadioId`.
  void refreshPlaybackState() {
    _syncCurrentPlaybackState();
  }

  @override
  void dispose() {
    _playbackSubscription?.cancel();
    _isPlayingSubscription?.cancel();
    _isBufferingSubscription?.cancel();
    _isLoadingNotifier.dispose();
    _stateNotifier.dispose();
    _isPlayingNotifier.dispose();
    _isBufferingNotifier.dispose();
    super.dispose();
  }
}
