// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationStatsModel _$NotificationStatsModelFromJson(
        Map<String, dynamic> json) =>
    NotificationStatsModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      total: (json['total'] as num).toInt(),
      unread: (json['unread'] as num).toInt(),
      read: (json['read'] as num).toInt(),
      typeBreakdown: Map<String, int>.from(json['typeBreakdown'] as Map),
      lastUpdated: json['lastUpdated'] as String,
    );

Map<String, dynamic> _$NotificationStatsModelToJson(
        NotificationStatsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'total': instance.total,
      'unread': instance.unread,
      'read': instance.read,
      'typeBreakdown': instance.typeBreakdown,
      'lastUpdated': instance.lastUpdated,
    };
