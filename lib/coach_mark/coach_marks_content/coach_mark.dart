import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/coach_mark/coach_marks_content/coach_mark_data.dart';

part 'coach_mark.g.dart';

@JsonSerializable()
class CoachMark {
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

  factory CoachMark.fromJson(Map<String, dynamic> json) =>
      _$CoachMarkFromJson(json);

  final String? type;
  final bool isCompleted;
  final CoachMarkData? initializationModal;
  final CoachMarkData? finalizationModal;
  final List<CoachMarkData>? content;

  int _currentStep = 1;

  int get currentStep => _currentStep;
  bool get hasFinalizationModal => finalizationModal != null;
  bool get hasInitializationModal => initializationModal != null;

  set currentStep(int newStep) {
    if (content == null || newStep > content!.length) {
      throw RangeError('currentStep cannot exceed the length + 1 of content');
    }
    _currentStep = newStep;
  }

  @override
  String toString() => 'CoachMark(type: $type, content: $content)';

  Map<String, dynamic> toJson() => _$CoachMarkToJson(this);

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

  @override
  int get hashCode => type.hashCode ^ content.hashCode ^ currentStep.hashCode;

  void _sortContent() {
    if (content != null) {
      content!.sort((a, b) => a.step!.compareTo(b.step!));
    }
  }
}
