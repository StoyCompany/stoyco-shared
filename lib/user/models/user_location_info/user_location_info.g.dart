// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_location_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocationInfo _$UserLocationInfoFromJson(Map<String, dynamic> json) =>
    UserLocationInfo(
      countryName: json['CountryName'] as String?,
      countryCode: json['CountryCode'] as String?,
      lada: json['Lada'] as String?,
      cityName: json['CityName'] as String?,
    );

Map<String, dynamic> _$UserLocationInfoToJson(UserLocationInfo instance) =>
    <String, dynamic>{
      'CountryName': instance.countryName,
      'CountryCode': instance.countryCode,
      'Lada': instance.lada,
      'CityName': instance.cityName,
    };
