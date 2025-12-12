// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_unified_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUnifiedStatsModel _$UserUnifiedStatsModelFromJson(
        Map<String, dynamic> json) =>
    UserUnifiedStatsModel(
      id: json['id'] as String,
      totalMessages: (json['totalMessages'] as num).toInt(),
      unreadMessages: (json['unreadMessages'] as num).toInt(),
      totalNotifications: (json['totalNotifications'] as num).toInt(),
      unreadNotifications: (json['unreadNotifications'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      totalUnread: (json['totalUnread'] as num).toInt(),
      lastUpdated: json['lastUpdated'] as String,
    );

Map<String, dynamic> _$UserUnifiedStatsModelToJson(
        UserUnifiedStatsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'totalMessages': instance.totalMessages,
      'unreadMessages': instance.unreadMessages,
      'totalNotifications': instance.totalNotifications,
      'unreadNotifications': instance.unreadNotifications,
      'totalItems': instance.totalItems,
      'totalUnread': instance.totalUnread,
      'lastUpdated': instance.lastUpdated,
    };
