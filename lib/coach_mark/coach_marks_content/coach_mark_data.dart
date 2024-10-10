import 'package:json_annotation/json_annotation.dart';

part 'coach_mark_data.g.dart';

/// Represents data associated with a coach mark, including content and behavior settings.
@JsonSerializable()
class CoachMarkData {
  /// Creates a `CoachMarkData` object from a JSON map.
  ///
  /// * `json`: The JSON map containing the coach mark data
  factory CoachMarkData.fromJson(Map<String, dynamic> json) =>
      _$CoachMarkDataFromJson(json);

  /// Creates a `CoachMarkData` object.
  ///
  /// * `title`: The title of the coach mark (optional).
  /// * `description`: The description or body text of the coach mark (optional).
  /// * `button`: The text for the button in the coach mark (optional).
  /// * `type`: The type of coach mark, likely corresponding to a specific feature or area (optional).
  /// * `step`: The current step or position in a sequence of coach marks (optional).
  /// * `enableClose`: Whether to show a close button in the coach mark (optional).
  /// * `enableNext`: Whether to show a "next" button in the coach mark (optional).
  const CoachMarkData({
    this.title,
    this.description,
    this.button,
    this.type,
    this.step,
    this.enableClose,
    this.enableNext,
  });
  final String? title;
  final String? description;
  final String? button;
  final String? type;
  final int? step;
  final bool? enableClose;
  final bool? enableNext;

  @override
  String toString() =>
      'Content(title: $title, description: $description, button: $button, type: $type, step: $step, enableClose: $enableClose, enableNext: $enableNext)';

  Map<String, dynamic> toJson() => _$CoachMarkDataToJson(this);

  CoachMarkData copyWith({
    String? title,
    String? description,
    String? button,
    String? type,
    int? step,
    bool? enableClose,
    bool? enableNext,
  }) =>
      CoachMarkData(
        title: title ?? this.title,
        description: description ?? this.description,
        button: button ?? this.button,
        type: type ?? this.type,
        step: step ?? this.step,
        enableClose: enableClose ?? this.enableClose,
        enableNext: enableNext ?? this.enableNext,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoachMarkData &&
        other.title == title &&
        other.description == description &&
        other.button == button &&
        other.type == type &&
        other.step == step &&
        other.enableClose == enableClose &&
        other.enableNext == enableNext;
  }

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      button.hashCode ^
      type.hashCode ^
      step.hashCode ^
      enableClose.hashCode ^
      enableNext.hashCode;
}
