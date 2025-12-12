/// Radio module for stoyco_shared
///
/// This module provides:
/// - [RadioModel]: Data model for radios from Firestore
/// - [RadioService]: Centralized service for radio operations
/// - [RadioPlayerController]: Controller for radio playback state
/// - [RadioPlayerConfig]: Configuration for the radio player
/// - [RadioPlayerState]: State object for the radio player
/// - [RadioPlayerWidget]: Compact widget for radio playback
library;

export '../models/radio_model.dart';
export 'radio_service.dart';
export 'radio_player_config.dart';
export 'radio_player_state.dart';
export 'radio_player_controller.dart';
export 'radio_player_widget.dart';
