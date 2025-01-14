// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_location_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocationInfo _$UserLocationInfoFromJson(Map<String, dynamic> json) =>
    UserLocationInfo(
      countryName: json['countryName'] as String?,
      countryCode: json['countryCode'] as String?,
      lada: json['lada'] as String?,
      cityName: json['cityName'] as String?,
    );

Map<String, dynamic> _$UserLocationInfoToJson(UserLocationInfo instance) =>
    <String, dynamic>{
      'countryName': instance.countryName,
      'countryCode': instance.countryCode,
      'lada': instance.lada,
      'cityName': instance.cityName,
    };
