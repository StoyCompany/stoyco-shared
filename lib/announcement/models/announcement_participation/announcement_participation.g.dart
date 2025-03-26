// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementParticipation _$AnnouncementParticipationFromJson(
        Map<String, dynamic> json) =>
    AnnouncementParticipation(
      userId: json['user_id'] as String?,
      socialNetworkUser: json['social_network_user'] == null
          ? null
          : SocialNetworkUser.fromJson(
              json['social_network_user'] as Map<String, dynamic>),
      publications: (json['publications'] as List<dynamic>?)
          ?.map((e) => Publication.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnnouncementParticipationToJson(
        AnnouncementParticipation instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'social_network_user': instance.socialNetworkUser,
      'publications': instance.publications,
    };
