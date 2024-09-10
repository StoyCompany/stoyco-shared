import 'package:json_annotation/json_annotation.dart';

part 'coach_mark_data.g.dart';

@JsonSerializable()
class CoachMarkData {
  factory CoachMarkData.fromJson(Map<String, dynamic> json) =>
      _$CoachMarkDataFromJson(json);

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
