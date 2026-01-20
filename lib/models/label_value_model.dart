/// A model representing a label-value pair.
///
/// Used for displaying selectable options where [label] is shown
/// to the user and [value] is used internally.
class LabelValueModel {
  /// Creates a [LabelValueModel].
  LabelValueModel({
    required this.label,
    required this.value,
  });

  /// The display text shown to the user.
  final String label;

  /// The internal value for logic or API calls.
  final String value;

  /// Creates a copy with the given fields replaced.
  LabelValueModel copyWith({
    String? label,
    String? value,
  }) =>
      LabelValueModel(
        label: label ?? this.label,
        value: value ?? this.value,
      );
}
