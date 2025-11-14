// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_follow_check_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerFollowCheckResponse _$PartnerFollowCheckResponseFromJson(
        Map<String, dynamic> json) =>
    PartnerFollowCheckResponse(
      error: (json['error'] as num).toInt(),
      messageError: json['messageError'] as String,
      tecMessageError: json['tecMessageError'] as String,
      count: (json['count'] as num).toInt(),
      data: json['data'] as bool,
    );

Map<String, dynamic> _$PartnerFollowCheckResponseToJson(
        PartnerFollowCheckResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'messageError': instance.messageError,
      'tecMessageError': instance.tecMessageError,
      'count': instance.count,
      'data': instance.data,
    };
