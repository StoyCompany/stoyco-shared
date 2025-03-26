// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Publication _$PublicationFromJson(Map<String, dynamic> json) => Publication(
      url: json['url'] as String?,
      likes: (json['likes'] as num?)?.toInt(),
      shares: (json['shares'] as num?)?.toInt(),
      views: (json['views'] as num?)?.toInt(),
      reviewStatus: json['review_status'] as String?,
      publicationDate: json['publication_date'] == null
          ? null
          : DateTime.parse(json['publication_date'] as String),
    );

Map<String, dynamic> _$PublicationToJson(Publication instance) =>
    <String, dynamic>{
      'url': instance.url,
      'likes': instance.likes,
      'shares': instance.shares,
      'views': instance.views,
      'review_status': instance.reviewStatus,
      'publication_date': instance.publicationDate?.toIso8601String(),
    };
