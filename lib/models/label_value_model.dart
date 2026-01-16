class LabelValueModel {
  LabelValueModel({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  LabelValueModel copyWith({
    String? label,
    String? value,
  }) =>
      LabelValueModel(
        label: label ?? this.label,
        value: value ?? this.value,
      );
}
