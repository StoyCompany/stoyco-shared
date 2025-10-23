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
      partnerId: json['partnerId'] as String?,
      order: (json['order'] as num?)?.toInt(),
      active: json['active'] as bool?,
      createAt: json['createAt'] == null
          ? null
          : DateTime.parse(json['createAt'] as String),
      streamingData: json['streamingData'] == null
          ? null
          : StreamingData.fromJson(
              json['streamingData'] as Map<String, dynamic>),
      isSubscriberOnly: json['isSubscriberOnly'] as bool?,
      isFeaturedContent: json['isFeaturedContent'] as bool?,
      partnerName: json['partnerName'] as String?,
      shared: (json['shared'] as num?)?.toInt(),
      followingCO: json['followingCO'] as bool?,
      likeThisVideo: json['likeThisVideo'] as bool?,
    );

Map<String, dynamic> _$VideoWithMetadataToJson(VideoWithMetadata instance) =>
    <String, dynamic>{
      'videoMetadata': instance.videoMetadata?.toJson(),
      'id': instance.id,
      'videoUrl': instance.videoUrl,
      'appUrl': instance.appUrl,
      'name': instance.name,
      'description': instance.description,
      'partnerId': instance.partnerId,
      'order': instance.order,
      'active': instance.active,
      'createAt': instance.createAt?.toIso8601String(),
      'streamingData': instance.streamingData?.toJson(),
      'isSubscriberOnly': instance.isSubscriberOnly,
      'isFeaturedContent': instance.isFeaturedContent,
      'partnerName': instance.partnerName,
      'shared': instance.shared,
      'followingCO': instance.followingCO,
      'likeThisVideo': instance.likeThisVideo,
    };
