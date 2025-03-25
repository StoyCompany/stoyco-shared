// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Configuration _$ConfigurationFromJson(Map<String, dynamic> json) =>
    Configuration(
      pointsPerLike: (json['points_per_like'] as num?)?.toInt(),
      pointsPerVideo: (json['points_per_video'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConfigurationToJson(Configuration instance) =>
    <String, dynamic>{
      'points_per_like': instance.pointsPerLike,
      'points_per_video': instance.pointsPerVideo,
    };
