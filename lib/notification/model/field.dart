import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Field {
  const Field({this.key, this.label});

  factory Field.fromMap(Map<String, dynamic> data) => Field(
        key: data['key'] as String?,
        label: data['label'] as String?,
      );

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Field].
  factory Field.fromJson(String data) =>
      Field.fromMap(json.decode(data) as Map<String, dynamic>);
  final String? key;
  final String? label;

  @override
  String toString() => 'Field(key: $key, label: $label)';

  Map<String, dynamic> toMap() => {
        'key': key,
        'label': label,
      };

  /// `dart:convert`
  ///
  /// Converts [Field] to a JSON string.
  String toJson() => json.encode(toMap());

  Field copyWith({
    String? key,
    String? label,
  }) =>
      Field(
        key: key ?? this.key,
        label: label ?? this.label,
      );

  @override
  int get hashCode => key.hashCode ^ label.hashCode;
}
