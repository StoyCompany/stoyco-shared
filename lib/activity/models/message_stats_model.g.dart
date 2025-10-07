// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageStatsModel _$MessageStatsModelFromJson(Map<String, dynamic> json) =>
    MessageStatsModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      totalNotifs: (json['totalNotifs'] as num).toInt(),
      unreadNotifs: (json['unreadNotifs'] as num).toInt(),
      readNotifs: (json['readNotifs'] as num).toInt(),
      categoryBreakdown:
          Map<String, int>.from(json['categoryBreakdown'] as Map),
      lastUpdated: json['lastUpdated'] as String,
    );

Map<String, dynamic> _$MessageStatsModelToJson(MessageStatsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'totalNotifs': instance.totalNotifs,
      'unreadNotifs': instance.unreadNotifs,
      'readNotifs': instance.readNotifs,
      'categoryBreakdown': instance.categoryBreakdown,
      'lastUpdated': instance.lastUpdated,
    };
