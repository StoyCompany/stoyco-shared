// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementDto _$AnnouncementDtoFromJson(Map<String, dynamic> json) =>
    AnnouncementDto(
      id: json['id'] as String?,
      contentType: json['content_type'] as String?,
      title: json['title'] as String?,
      shortDescription: json['short_description'] as String?,
      content: json['content'] == null
          ? null
          : Content.fromJson(json['content'] as Map<String, dynamic>),
      createdBy: json['created_by'] as String?,
      urlPrincipalImage: json['url_principal_image'] as String?,
      state: json['state'] as String?,
      isClosedCampaign: json['is_closed_campaign'] as bool?,
      publishedDate: json['published_date'] as String?,
      endDate: json['end_date'] as String?,
      configuration: json['configuration'] == null
          ? null
          : Configuration.fromJson(
              json['configuration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnnouncementDtoToJson(AnnouncementDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content_type': instance.contentType,
      'title': instance.title,
      'short_description': instance.shortDescription,
      'content': instance.content,
      'created_by': instance.createdBy,
      'url_principal_image': instance.urlPrincipalImage,
      'state': instance.state,
      'is_closed_campaign': instance.isClosedCampaign,
      'published_date': instance.publishedDate,
      'end_date': instance.endDate,
      'configuration': instance.configuration,
    };
