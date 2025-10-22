// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewModel _$NewModelFromJson(Map<String, dynamic> json) => NewModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      mainImage: json['mainImage'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      content: json['content'] as String?,
      shortDescription: json['shortDescription'] as String?,
      isDraft: json['isDraft'] as bool?,
      isPublished: json['isPublished'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      viewCount: (json['viewCount'] as num?)?.toInt(),
      scheduledPublishDate: json['scheduledPublishDate'] as String?,
      draftCreationDate: json['draftCreationDate'] as String?,
      lastUpdatedDate: json['lastUpdatedDate'] as String?,
      deletionDate: json['deletionDate'],
      cronJobId: json['cronJobId'],
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] as String?,
      communityOwnerId: json['communityOwnerId'] as String?,
    );

Map<String, dynamic> _$NewModelToJson(NewModel instance) => <String, dynamic>{
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
      'scheduledPublishDate': instance.scheduledPublishDate,
      'draftCreationDate': instance.draftCreationDate,
      'lastUpdatedDate': instance.lastUpdatedDate,
      'deletionDate': instance.deletionDate,
      'cronJobId': instance.cronJobId,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'communityOwnerId': instance.communityOwnerId,
    };
