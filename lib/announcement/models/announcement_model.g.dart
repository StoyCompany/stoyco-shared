// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementModel _$AnnouncementModelFromJson(Map<String, dynamic> json) =>
    AnnouncementModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      mainImage: json['mainImage'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      content: json['content'] == null
          ? null
          : Content.fromJson(json['content'] as Map<String, dynamic>),
      shortDescription: json['shortDescription'] as String?,
      isDraft: json['isDraft'] as bool?,
      isPublished: json['isPublished'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      viewCount: (json['viewCount'] as num?)?.toInt(),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      draftCreationDate: json['draftCreationDate'] as String?,
      lastUpdatedDate: json['lastUpdatedDate'] as String?,
      deletionDate: json['deletionDate'],
      cronJobId: json['cronJobId'],
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] as String?,
      communityOwnerId: json['communityOwnerId'] as String?,
      isSubscriberOnly: json['isSubscriberOnly'] as bool?,
      hasAccess: json['hasAccess'] as bool?,
      accessContent: json['accessContent'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AnnouncementModelToJson(AnnouncementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'mainImage': instance.mainImage,
      'images': instance.images,
      'content': instance.content,
      'shortDescription': instance.shortDescription,
      'isDraft': instance.isDraft,
      'isPublished': instance.isPublished,
      'isDeleted': instance.isDeleted,
      'viewCount': instance.viewCount,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'draftCreationDate': instance.draftCreationDate,
      'lastUpdatedDate': instance.lastUpdatedDate,
      'deletionDate': instance.deletionDate,
      'cronJobId': instance.cronJobId,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'communityOwnerId': instance.communityOwnerId,
      'isSubscriberOnly': instance.isSubscriberOnly,
      'hasAccess': instance.hasAccess,
      'accessContent': instance.accessContent,
    };
