// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      transactionId: json['transactionId'] as String?,
      userId: json['userId'] as String?,
      points: (json['points'] as num?)?.toInt(),
      state: json['state'] as String?,
      source: json['source'] as String?,
      referenceId: json['referenceId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'userId': instance.userId,
      'points': instance.points,
      'state': instance.state,
      'source': instance.source,
      'referenceId': instance.referenceId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
