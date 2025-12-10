// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonateResponse _$DonateResponseFromJson(Map<String, dynamic> json) =>
    DonateResponse(
      error: (json['error'] as num?)?.toInt(),
      messageError: json['messageError'] as String?,
      tecMessageError: json['tecMessageError'] as String?,
      count: (json['count'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : DonateResultModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DonateResponseToJson(DonateResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'messageError': instance.messageError,
      'tecMessageError': instance.tecMessageError,
      'count': instance.count,
      'data': instance.data,
    };
