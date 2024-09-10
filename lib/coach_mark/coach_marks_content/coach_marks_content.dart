import 'package:json_annotation/json_annotation.dart';

import 'package:stoyco_shared/coach_mark/coach_marks_content/coach_mark.dart';

part 'coach_marks_content.g.dart';

/// Represents a collection of coach marks or tutorials within the application
@JsonSerializable()
class CoachMarksContent {
  /// Creates a `CoachMarksContent` object
  ///
  /// * `coachMarks`: A list of `CoachMark` objects representing the available coach marks in the application
  const CoachMarksContent({this.coachMarks});

  /// Creates a `CoachMarksContent` object from a JSON map
  ///
  /// * `json`: The JSON map containing the coach marks content data
  factory CoachMarksContent.fromJson(Map<String, dynamic> json) =>
      _$CoachMarksContentFromJson(json);

  /// A list of `CoachMark` objects
  final List<CoachMark>? coachMarks;

  /// Returns a string representation of the `CoachMarksContent` object
  @override
  String toString() => 'CoachMarksContent(coachMarks: $coachMarks)';

  /// Converts the `CoachMarksContent` object to a JSON map.
  Map<String, dynamic> toJson() => _$CoachMarksContentToJson(this);

  /// Creates a copy of this `CoachMarksContent` with the given fields replaced with the new values
  CoachMarksContent copyWith({
    List<CoachMark>? coachMarks,
  }) =>
      CoachMarksContent(
        coachMarks: coachMarks ?? this.coachMarks,
      );

  /// Overrides the equality operator to compare two `CoachMarksContent` objects
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoachMarksContent && other.coachMarks == coachMarks;
  }

  /// Overrides the hashCode getter to generate a hash code for the `CoachMarksContent` object
  @override
  int get hashCode => coachMarks.hashCode;
}
