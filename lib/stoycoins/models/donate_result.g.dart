// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donate_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonateResultModel _$DonateResultModelFromJson(Map<String, dynamic> json) =>
    DonateResultModel(
      transactionId: json['transactionId'] as String?,
      newBalance: json['newBalance'] as String?,
      transactionState: json['transactionState'] as String?,
      currentLevelName: json['currentLevelName'] as String?,
      pointsToNextLevel: (json['pointsToNextLevel'] as num?)?.toInt(),
      contextResult: json['contextResult'] == null
          ? null
          : DonateContextResultModel.fromJson(
              json['contextResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DonateResultModelToJson(DonateResultModel instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'newBalance': instance.newBalance,
      'transactionState': instance.transactionState,
      'currentLevelName': instance.currentLevelName,
      'pointsToNextLevel': instance.pointsToNextLevel,
      'contextResult': instance.contextResult,
    };

DonateContextResultModel _$DonateContextResultModelFromJson(
        Map<String, dynamic> json) =>
    DonateContextResultModel(
      projectId: json['projectId'] as String?,
      communityOwnerId: json['communityOwnerId'] as String?,
      contributedAmount: (json['contributedAmount'] as num?)?.toInt(),
      status: json['status'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DonateContextResultModelToJson(
        DonateContextResultModel instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'communityOwnerId': instance.communityOwnerId,
      'contributedAmount': instance.contributedAmount,
      'status': instance.status,
      'message': instance.message,
    };
