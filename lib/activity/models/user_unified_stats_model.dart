import 'package:json_annotation/json_annotation.dart';

part 'user_unified_stats_model.g.dart';

@JsonSerializable()
class UserUnifiedStatsModel {
  UserUnifiedStatsModel({
    required this.id,
    required this.totalMessages,
    required this.unreadMessages,
    required this.totalNotifications,
    required this.unreadNotifications,
    required this.totalItems,
    required this.totalUnread,
    required this.lastUpdated,
  });

  final String id;
  final int totalMessages;
  final int unreadMessages;
  final int totalNotifications;
  final int unreadNotifications;
  final int totalItems;
  final int totalUnread;
  final String lastUpdated;

  factory UserUnifiedStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserUnifiedStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserUnifiedStatsModelToJson(this);
}
