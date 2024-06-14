import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Data {
  const Data({this.action});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        action: data['action'] as String?,
      );

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) =>
      Data.fromMap(json.decode(data) as Map<String, dynamic>);
  final String? action;

  @override
  String toString() => 'Data(action: $action)';

  Map<String, dynamic> toMap() => {
        'action': action,
      };

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());

  Data copyWith({
    String? action,
  }) =>
      Data(
        action: action ?? this.action,
      );

  @override
  int get hashCode => action.hashCode;
}
