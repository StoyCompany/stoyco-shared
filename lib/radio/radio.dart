/// Radio module for stoyco_shared
///
/// This module provides:
/// - [RadioModel]: Data model for radios from Firestore
/// - [RadioService]: Centralized service for radio operations (data + tracking)
/// - [RadioPlayerWidget]: Compact widget for radio playback
/// - [RadioPlayerController]: Controller for radio playback state
/// - [RadioPlayerConfig]: Configuration for the radio player
/// - [RadioPlayerState]: State object for the radio player
///
/// Example usage:
/// ```dart
/// // Simple widget usage
/// RadioPlayerWidget(
///   config: RadioPlayerConfig(
///     onPlayRadio: (radio) => myAudioPlayer.play(radio.streamingUrl!),
///     onStopRadio: () => myAudioPlayer.stop(),
///   ),
/// )
///
/// // Direct service usage
/// final radioService = RadioService();
/// radioService.getActiveRadios().listen((radios) => print(radios));
/// ```
library;

export '../models/radio_model.dart';
export 'radio_service.dart';
export 'radio_player_widget.dart';
