// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_video_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVideoReaction _$UserVideoReactionFromJson(Map<String, dynamic> json) =>
    UserVideoReaction(
      id: json['id'] as String?,
      videoId: json['videoId'] as String?,
      userId: json['userId'] as String?,
      reactionType: json['reactionType'] as String?,
      title: json['title'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      videoMetadata: json['videoMetadata'] == null
          ? null
          : VideoInteraction.fromJson(
              json['videoMetadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserVideoReactionToJson(UserVideoReaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'videoId': instance.videoId,
      'userId': instance.userId,
      'reactionType': instance.reactionType,
      'title': instance.title,
      'createdAt': instance.createdAt?.toIso8601String(),
      'videoMetadata': instance.videoMetadata,
    };
