import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/coach_mark/coach_marks_content/coach_mark_data.dart';

part 'coach_mark.g.dart';

/// Represents a coach mark or tutorial within the application.
///
/// This class encapsulates data about a specific coach mark, including its type,
/// content, and whether it has been completed by the user. It also handles the
/// current step within the coach mark and provides convenience methods to
/// check for initialization and finalization modals.
@JsonSerializable()
class CoachMark {
  /// Creates a `CoachMark` object.
  ///
  /// * `type`: The type or identifier of the coach mark (optional).
  /// * `content`: A list of `CoachMarkData` objects representing the individual steps or content of the coach mark (optional).
  /// * `finalizationModal`: `CoachMarkData` representing the finalization modal to be displayed after the coach mark is completed (optional).
  /// * `initializationModal`: `CoachMarkData` representing the initialization modal to be displayed before the coach mark starts (optional).
  /// * `isCompleted`: Whether the coach mark has been completed by the user (defaults to `false`).
  /// * `currentStep`: The current step or position within the coach mark (optional).
  CoachMark({
    this.type,
    this.content,
    this.finalizationModal,
    this.initializationModal,
    this.isCompleted = false,
    int? currentStep,
  }) {
    _sortContent();
  }

  /// Creates a `CoachMark` object from a JSON map.
  ///
  /// * `json`: The JSON map containing the coach mark data
  factory CoachMark.fromJson(Map<String, dynamic> json) =>
      _$CoachMarkFromJson(json);

  /// The type or identifier of the coach mark.
  final String? type;

  /// Whether the coach mark has been completed.
  final bool isCompleted;

  /// The initialization modal to be displayed before the coach mark starts.
  final CoachMarkData? initializationModal;

  /// The finalization modal to be displayed after the coach mark is completed.
  final CoachMarkData? finalizationModal;

  /// A list of `CoachMarkData` objects representing the steps or content of the coach mark
  final List<CoachMarkData>? content;

  /// The current step within the coach mark (private).
  int _currentStep = 1;

  /// Gets the current step within the coach mark
  int get currentStep => _currentStep;

  /// Checks if the coach mark has a finalization modal.
  bool get hasFinalizationModal => finalizationModal != null;

  /// Checks if the coach mark has an initialization modal.
  bool get hasInitializationModal => initializationModal != null;

  /// Sets the current step within the coach mark.
  ///
  /// Throws a `RangeError` if the new step exceeds the number of content steps.
  set currentStep(int newStep) {
    if (content == null || newStep > content!.length) {
      throw RangeError('currentStep cannot exceed the length + 1 of content');
    }
    _currentStep = newStep;
  }

  /// Returns a string representation of the `CoachMark` object.
  @override
  String toString() => 'CoachMark(type: $type, content: $content)';

  /// Converts the `CoachMark` object to a JSON map.
  Map<String, dynamic> toJson() => _$CoachMarkToJson(this);

  /// Creates a copy of this `CoachMark` with the given fields replaced with the new values
  CoachMark copyWith({
    String? type,
    List<CoachMarkData>? content,
    int? currentStep,
    CoachMarkData? initializationModal,
    CoachMarkData? finalizationModal,
    bool? isCompleted,
  }) =>
      CoachMark(
        type: type ?? this.type,
        content: content ?? this.content,
        finalizationModal: finalizationModal ?? this.finalizationModal,
        initializationModal: initializationModal ?? this.initializationModal,
        isCompleted: isCompleted ?? this.isCompleted,
      )..currentStep = currentStep ?? this.currentStep;

  /// Overrides the equality operator to compare two `CoachMark` objects
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoachMark &&
        other.type == type &&
        other.content == content &&
        other.currentStep == currentStep &&
        other.isCompleted == isCompleted &&
        other.initializationModal == initializationModal &&
        other.finalizationModal == finalizationModal;
  }

  /// Overrides the hashCode getter to generate a hash code for the `CoachMark` object
  @override
  int get hashCode => type.hashCode ^ content.hashCode ^ currentStep.hashCode;

  /// Sorts the content list by step number in ascending order
  void _sortContent() {
    if (content != null) {
      content!.sort((a, b) => a.step!.compareTo(b.step!));
    }
  }
}
