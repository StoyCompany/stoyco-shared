// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_participation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementParticipationResponse _$AnnouncementParticipationResponseFromJson(
        Map<String, dynamic> json) =>
    AnnouncementParticipationResponse(
      announcementId: json['announcement_id'] as String?,
      socialNetworkUser: json['social_network_user'] == null
          ? null
          : SocialNetworkUser.fromJson(
              json['social_network_user'] as Map<String, dynamic>),
      userId: json['user_id'] as String?,
      metrics: json['metrics'] == null
          ? null
          : Metrics.fromJson(json['metrics'] as Map<String, dynamic>),
      publications: (json['publications'] as List<dynamic>?)
          ?.map((e) => Publication.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AnnouncementParticipationResponseToJson(
        AnnouncementParticipationResponse instance) =>
    <String, dynamic>{
      'announcement_id': instance.announcementId,
      'social_network_user': instance.socialNetworkUser,
      'user_id': instance.userId,
      'metrics': instance.metrics,
      'publications': instance.publications,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
