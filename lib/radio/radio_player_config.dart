import 'package:stoyco_shared/models/radio_model.dart';
import 'package:stoyco_shared/radio/radio_service.dart';

/// Configuration for [RadioPlayerController].
///
/// Provides callbacks for audio playback integration.
class RadioPlayerConfig {
  const RadioPlayerConfig({
    this.partnerId,
    this.onPlayRadio,
    this.onTogglePlayPause,
    this.onStopRadio,
    this.onShareRadio,
    this.getCurrentPlayingRadioId,
    this.isAudioPlaying,
    this.isAudioBuffering,
    this.playingRadioStream,
    this.isPlayingStream,
    this.isBufferingStream,
    this.radioService,
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

  /// Returns whether audio is currently buffering/loading (sync).
  final bool Function()? isAudioBuffering;

  /// Stream of currently playing radio ID changes.
  final Stream<String?>? playingRadioStream;

  /// Stream of play/pause state changes.
  final Stream<bool>? isPlayingStream;

  /// Stream of buffering state changes.
  final Stream<bool>? isBufferingStream;

  /// Optional RadioService instance for listener tracking.
  final RadioService? radioService;
}
