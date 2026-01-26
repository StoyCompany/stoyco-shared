// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minted_nft_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MintedNftResponseModel _$MintedNftResponseModelFromJson(
        Map<String, dynamic> json) =>
    MintedNftResponseModel(
      error: (json['error'] as num?)?.toInt(),
      messageError: json['messageError'] as String?,
      tecMessageError: json['tecMessageError'] as String?,
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MintedNftModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MintedNftResponseModelToJson(
        MintedNftResponseModel instance) =>
    <String, dynamic>{
      'error': instance.error,
      'messageError': instance.messageError,
      'tecMessageError': instance.tecMessageError,
      'count': instance.count,
      'data': instance.data,
    };
