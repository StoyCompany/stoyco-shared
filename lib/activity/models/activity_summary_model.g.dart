// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivitySummaryModel _$ActivitySummaryModelFromJson(
        Map<String, dynamic> json) =>
    ActivitySummaryModel(
      id: json['id'] as String,
      unreadNotifications: (json['unreadNotifications'] as num).toInt(),
      unreadMessages: (json['unreadMessages'] as num).toInt(),
      totalUnread: (json['totalUnread'] as num).toInt(),
      lastUpdated: json['lastUpdated'] as String,
    );

Map<String, dynamic> _$ActivitySummaryModelToJson(
        ActivitySummaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unreadNotifications': instance.unreadNotifications,
      'unreadMessages': instance.unreadMessages,
      'totalUnread': instance.totalUnread,
      'lastUpdated': instance.lastUpdated,
    };
