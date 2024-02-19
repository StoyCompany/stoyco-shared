// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDeviceDto _$UserDeviceDtoFromJson(Map<String, dynamic> json) =>
    UserDeviceDto(
      userId: json['userId'] as String?,
      deviceToken: json['deviceToken'] as String?,
      deviceType: json['deviceType'] as String? ?? 'Android',
    );

Map<String, dynamic> _$UserDeviceDtoToJson(UserDeviceDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'deviceType': instance.deviceType,
      'deviceToken': instance.deviceToken,
    };
