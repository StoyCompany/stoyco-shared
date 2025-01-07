// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoLocationDto _$GeoLocationDtoFromJson(Map<String, dynamic> json) =>
    GeoLocationDto(
      id: json['id'] as String?,
      type: json['type'] as String?,
      attributes: json['attributes'] == null
          ? null
          : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeoLocationDtoToJson(GeoLocationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attributes': instance.attributes,
    };
