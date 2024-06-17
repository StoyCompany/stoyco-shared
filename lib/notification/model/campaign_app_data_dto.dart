import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stoyco_shared/notification/model/field.dart';

@immutable
class CampaignAppDataDto {
  final String? userId;
  final String? itemId;
  final List<Field>? fields;
  final Map<String, String>? data;

  const CampaignAppDataDto({
    this.userId,
    this.itemId,
    this.fields,
    this.data,
  });

  @override
  String toString() =>
      'CampaignAppDataDto(userId: $userId, itemId: $itemId, fields: $fields, data: $data)';

  factory CampaignAppDataDto.fromMap(Map<String, dynamic> data) =>
      CampaignAppDataDto(
        userId: data['userId'] as String?,
        itemId: data['itemId'] as String?,
        fields: (data['fields'] as List<dynamic>?)
            ?.map((e) => Field.fromMap(e as Map<String, dynamic>))
            .toList(),
        data: (data['data'] as Map<String, dynamic>?)
            ?.map((key, value) => MapEntry(key, value as String)),
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'itemId': itemId,
        'fields': fields?.map((e) => e.toMap()).toList(),
        'data': data,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CampaignAppDataDto].
  factory CampaignAppDataDto.fromJson(String data) =>
      CampaignAppDataDto.fromMap(json.decode(data) as Map<String, dynamic>);

  /// `dart:convert`
  ///
  /// Converts [CampaignAppDataDto] to a JSON string.
  String toJson() => json.encode(toMap());

  CampaignAppDataDto copyWith({
    String? userId,
    String? itemId,
    List<Field>? fields,
    Map<String, String>? data,
  }) =>
      CampaignAppDataDto(
        userId: userId ?? this.userId,
        itemId: itemId ?? this.itemId,
        fields: fields ?? this.fields,
        data: data ?? this.data,
      );

  @override
  int get hashCode =>
      userId.hashCode ^ itemId.hashCode ^ fields.hashCode ^ data.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CampaignAppDataDto &&
        other.userId == userId &&
        other.itemId == itemId &&
        listEquals(other.fields, fields) &&
        mapEquals(other.data, data);
  }
}
