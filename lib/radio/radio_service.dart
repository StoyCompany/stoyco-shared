import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:stoyco_shared/models/radio_model.dart';
import 'package:stoyco_shared/utils/logger.dart';

/// Centralized service for radio functionality.
///
/// This service acts as an orchestrator that handles:
/// - Fetching radios from Firestore
/// - Real-time listener tracking (increment/decrement)
/// - Playback state management
///
/// Example usage:
/// ```dart
/// final radioService = RadioService();
///
/// // Get radios stream
/// radioService.getActiveRadios().listen((radios) {
///   print('Active radios: ${radios.length}');
/// });
///
/// // Start listening to a radio
/// await radioService.startListening('radio123');
///
/// // Watch listener count
/// radioService.watchListenerCount('radio123').listen((count) {
///   print('Listeners: $count');
/// });
/// ```
class RadioService {
  RadioService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const String _collection = 'radios';

  // ══════════════════════════════════════════════════════════════════════════
  // RADIO DATA OPERATIONS
  // ══════════════════════════════════════════════════════════════════════════

  /// Gets all active radios ordered by creation date.
  Stream<List<RadioModel>> getActiveRadios() => _firestore
      .collection(_collection)
      .where('status', isEqualTo: 'active')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => RadioModel.fromFirestore(doc)).toList(),
      );

  /// Gets radios by partner/community owner.
  Stream<List<RadioModel>> getRadiosByPartner(String partnerId) => _firestore
      .collection(_collection)
      .where('communityOwnerId', isEqualTo: partnerId)
      .where('status', isEqualTo: 'active')
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => RadioModel.fromFirestore(doc)).toList(),
      );

  /// Gets a single radio by ID.
  Future<RadioModel?> getRadioById(String radioId) async {
    final doc = await _firestore.collection(_collection).doc(radioId).get();
    return doc.exists ? RadioModel.fromFirestore(doc) : null;
  }

  /// Watches changes to a specific radio.
  Stream<RadioModel?> watchRadio(String radioId) => _firestore
      .collection(_collection)
      .doc(radioId)
      .snapshots()
      .map((doc) => doc.exists ? RadioModel.fromFirestore(doc) : null);

  // ══════════════════════════════════════════════════════════════════════════
  // LISTENER TRACKING
  // ══════════════════════════════════════════════════════════════════════════

  /// Increments the listener count when a user starts listening.
  ///
  /// Call this when playback starts for a radio.
  Future<void> startListening(String radioId) async {
    try {
      final now = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(radioId).update({
        'members_online_count': FieldValue.increment(1),
        'app_last_increment': now,
        'last_app_activity': now,
      });
    } catch (e) {
      StoyCoLogger.error(
        '[RadioService] Error incrementing listener count',
        error: e,
      );
    }
  }

  /// Decrements the listener count when a user stops listening.
  ///
  /// Call this when playback stops or the user switches to another radio.
  Future<void> stopListening(String radioId) async {
    try {
      final now = FieldValue.serverTimestamp();
      final doc = await _firestore.collection(_collection).doc(radioId).get();
      final currentCount = doc.data()?['members_online_count'] ?? 0;

      if (currentCount > 0) {
        await _firestore.collection(_collection).doc(radioId).update({
          'members_online_count': FieldValue.increment(-1),
          'app_last_decrement': now,
          'last_app_activity': now,
        });
      }
    } catch (e) {
      StoyCoLogger.error(
        '[RadioService] Error decrementing listener count',
        error: e,
      );
    }
  }

  /// Watches the real-time listener count for a radio.
  Stream<int> watchListenerCount(String radioId) => _firestore
      .collection(_collection)
      .doc(radioId)
      .snapshots()
      .map((doc) => doc.data()?['members_online_count'] ?? 0);
}

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
/// Uses [RadioService] internally for all data operations and tracking.
///
/// Example:
/// ```dart
/// final controller = RadioPlayerController(
///   config: RadioPlayerConfig(
///     onPlayRadio: (radio) => audioPlayer.play(radio.streamingUrl!),
///     onStopRadio: () => audioPlayer.stop(),
///   ),
/// );
/// ```
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

  StreamSubscription<List<RadioModel>>? _radiosSubscription;
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

  void _loadRadios() {
    _isLoadingNotifier.value = true;

    final radiosStream = config.partnerId != null
        ? _radioService.getRadiosByPartner(config.partnerId!)
        : _radioService.getActiveRadios();

    _radiosSubscription = radiosStream.listen(
      (radiosList) {
        _stateNotifier.value = _stateNotifier.value.copyWith(radios: radiosList);
        _isLoadingNotifier.value = false;
      },
      onError: (e) {
        _isLoadingNotifier.value = false;
        StoyCoLogger.error('[RadioPlayerController] Error loading radios', error: e);
      },
    );
  }

  void _listenToPlaybackChanges() {
    if (config.playingRadioStream != null) {
      _playbackSubscription = config.playingRadioStream!.listen(
        (radioId) {
          final previousRadioId = _stateNotifier.value.currentPlayingRadioId;

          if (previousRadioId != null && radioId != previousRadioId) {
            unawaited(
              _radioService.stopListening(previousRadioId),
            );
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
    _radiosSubscription?.cancel();
    _playbackSubscription?.cancel();
    _isPlayingSubscription?.cancel();
    _isLoadingNotifier.dispose();
    _stateNotifier.dispose();
    _isPlayingNotifier.dispose();
    super.dispose();
  }
}
