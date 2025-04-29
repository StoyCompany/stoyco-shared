// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Publication _$PublicationFromJson(Map<String, dynamic> json) => Publication(
      url: json['url'] as String?,
      publicationDate: json['publication_date'] == null
          ? null
          : DateTime.parse(json['publication_date'] as String),
    );

Map<String, dynamic> _$PublicationToJson(Publication instance) =>
    <String, dynamic>{
      'url': instance.url,
      'publication_date': instance.publicationDate?.toIso8601String(),
    };
