import 'package:json_annotation/json_annotation.dart';

import 'package:stoyco_shared/coach_mark/coach_marks_content/coach_mark.dart';

part 'coach_marks_content.g.dart';

@JsonSerializable()
class CoachMarksContent {
  const CoachMarksContent({this.coachMarks});

  factory CoachMarksContent.fromJson(Map<String, dynamic> json) =>
      _$CoachMarksContentFromJson(json);
  final List<CoachMark>? coachMarks;

  @override
  String toString() => 'CoachMarksContent(coachMarks: $coachMarks)';

  Map<String, dynamic> toJson() => _$CoachMarksContentToJson(this);

  CoachMarksContent copyWith({
    List<CoachMark>? coachMarks,
  }) =>
      CoachMarksContent(
        coachMarks: coachMarks ?? this.coachMarks,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoachMarksContent && other.coachMarks == coachMarks;
  }

  @override
  int get hashCode => coachMarks.hashCode;
}
