// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonateModel _$DonateModelFromJson(Map<String, dynamic> json) => DonateModel(
      senderId: json['senderId'] as String?,
      receiverId: json['receiverId'] as String?,
      receiverType: json['receiverType'] as String?,
      points: (json['points'] as num?)?.toInt(),
      context: json['context'] == null
          ? null
          : DonateContextModel.fromJson(
              json['context'] as Map<String, dynamic>),
      description: json['description'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DonateModelToJson(DonateModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'receiverType': instance.receiverType,
      'points': instance.points,
      'context': instance.context,
      'description': instance.description,
      'quantity': instance.quantity,
    };

DonateContextModel _$DonateContextModelFromJson(Map<String, dynamic> json) =>
    DonateContextModel(
      source: json['source'] as String?,
      referenceId: json['referenceId'] as String?,
      extraData: json['extraData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DonateContextModelToJson(DonateContextModel instance) =>
    <String, dynamic>{
      'source': instance.source,
      'referenceId': instance.referenceId,
      'extraData': instance.extraData,
    };
