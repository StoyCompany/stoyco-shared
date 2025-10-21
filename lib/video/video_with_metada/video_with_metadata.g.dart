// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_with_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoWithMetadata _$VideoWithMetadataFromJson(Map<String, dynamic> json) =>
    VideoWithMetadata(
      videoMetadata: json['videoMetadata'] == null
          ? null
          : VideoMetadata.fromJson(
              json['videoMetadata'] as Map<String, dynamic>),
      id: json['id'] as String?,
      videoUrl: json['videoUrl'] as String?,
      appUrl: json['appUrl'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      order: (json['order'] as num?)?.toInt(),
      active: json['active'] as bool?,
      createAt: json['createAt'] == null
          ? null
          : DateTime.parse(json['createAt'] as String),
      partnerId: json['partnerId'] as String?,
      isSubscriberOnly: json['isSubscriberOnly'] as bool?,
      hasAccess: json['hasAccess'] as bool?,
    );

Map<String, dynamic> _$VideoWithMetadataToJson(VideoWithMetadata instance) =>
    <String, dynamic>{
      'videoMetadata': instance.videoMetadata,
      'id': instance.id,
      'videoUrl': instance.videoUrl,
      'appUrl': instance.appUrl,
      'name': instance.name,
      'description': instance.description,
      'order': instance.order,
      'active': instance.active,
      'createAt': instance.createAt?.toIso8601String(),
      'partnerId': instance.partnerId,
      'isSubscriberOnly': instance.isSubscriberOnly,
      'hasAccess': instance.hasAccess,
    };
