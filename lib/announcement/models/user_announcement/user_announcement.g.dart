// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAnnouncement _$UserAnnouncementFromJson(Map<String, dynamic> json) =>
    UserAnnouncement(
      userId: json['user_id'] as String?,
      userPhoto: json['user_photo'] as String?,
      username: json['username'] as String?,
      platform: json['platform'] as String?,
      metrics: json['metrics'] == null
          ? null
          : Metrics.fromJson(json['metrics'] as Map<String, dynamic>),
      puntos: (json['puntos'] as num?)?.toInt(),
      bestPost: json['best_post'] as String?,
    );

Map<String, dynamic> _$UserAnnouncementToJson(UserAnnouncement instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_photo': instance.userPhoto,
      'username': instance.username,
      'platform': instance.platform,
      'metrics': instance.metrics,
      'puntos': instance.puntos,
      'best_post': instance.bestPost,
    };
