// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoPlayerModel _$VideoPlayerModelFromJson(Map<String, dynamic> json) =>
    VideoPlayerModel(
      id: json['id'] as String?,
      appUrl: json['appUrl'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      order: (json['order'] as num?)?.toInt(),
      isSubscriberOnly: json['isSubscriberOnly'] as bool? ?? false,
      accessContent: json['accessContent'] == null
          ? null
          : AccessContent.fromJson(
              json['accessContent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VideoPlayerModelToJson(VideoPlayerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appUrl': instance.appUrl,
      'name': instance.name,
      'description': instance.description,
      'order': instance.order,
      'isSubscriberOnly': instance.isSubscriberOnly,
      'accessContent': instance.accessContent,
    };
