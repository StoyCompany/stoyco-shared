// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageResult<T> _$PageResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PageResult<T>(
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      totalItems: (json['totalItems'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      items: (json['items'] as List<dynamic>?)?.map(fromJsonT).toList(),
    );

Map<String, dynamic> _$PageResultToJson<T>(
  PageResult<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'totalItems': instance.totalItems,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'totalPages': instance.totalPages,
      'items': instance.items?.map(toJsonT).toList(),
    };
