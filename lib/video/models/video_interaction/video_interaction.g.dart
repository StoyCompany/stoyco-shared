// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_interaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoInteraction _$VideoInteractionFromJson(Map<String, dynamic> json) =>
    VideoInteraction(
      id: json['id'] as String?,
      title: json['title'] as String?,
      url: json['url'] as String?,
      likes: (json['likes'] as num?)?.toInt(),
      dislikes: (json['dislikes'] as num?)?.toInt(),
      shared: (json['shared'] as num?)?.toInt(),
      totalScore: (json['totalScore'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VideoInteractionToJson(VideoInteraction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'likes': instance.likes,
      'dislikes': instance.dislikes,
      'shared': instance.shared,
      'totalScore': instance.totalScore,
    };
