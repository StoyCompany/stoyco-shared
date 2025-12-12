import 'package:flutter/foundation.dart';
import 'package:stoyco_shared/models/radio_model.dart';

/// State for the radio player UI.
@immutable
class RadioPlayerState {
  const RadioPlayerState({
    this.radios = const [],
    this.currentPlayingRadioId,
  });

  /// List of available radios.
  final List<RadioModel> radios;

  /// ID of the currently playing radio, or `null` if nothing is playing.
  final String? currentPlayingRadioId;

  /// Creates a copy of this state with optional modifications.
  ///
  /// [radios] New list of radios.
  /// [currentPlayingRadioId] New playing radio ID.
  /// [clearCurrentRadio] If `true`, sets `currentPlayingRadioId` to `null`.
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
