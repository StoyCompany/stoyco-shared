import 'package:stoyco_shared/models/radio_model.dart';

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
