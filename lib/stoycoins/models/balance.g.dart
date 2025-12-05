// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceModel _$BalanceModelFromJson(Map<String, dynamic> json) => BalanceModel(
      userId: json['userId'] as String?,
      availableBalance: (json['availableBalance'] as num?)?.toInt(),
      totalBalance: (json['totalBalance'] as num?)?.toInt(),
      pendingWithdrawals: (json['pendingWithdrawals'] as num?)?.toInt(),
      currentLevelName: json['currentLevelName'] as String?,
      currentLevelCode: json['currentLevelCode'] as String?,
      currentLevelIconUrl: json['currentLevelIconUrl'] as String?,
      pointsToNextLevel: (json['pointsToNextLevel'] as num?)?.toInt(),
      nextLevelName: json['nextLevelName'] as String?,
    );

Map<String, dynamic> _$BalanceModelToJson(BalanceModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'availableBalance': instance.availableBalance,
      'totalBalance': instance.totalBalance,
      'pendingWithdrawals': instance.pendingWithdrawals,
      'currentLevelName': instance.currentLevelName,
      'currentLevelCode': instance.currentLevelCode,
      'currentLevelIconUrl': instance.currentLevelIconUrl,
      'pointsToNextLevel': instance.pointsToNextLevel,
      'nextLevelName': instance.nextLevelName,
    };
