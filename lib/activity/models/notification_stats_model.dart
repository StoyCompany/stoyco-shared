import 'package:json_annotation/json_annotation.dart';

part 'notification_stats_model.g.dart';

@JsonSerializable()
class NotificationStatsModel {
  factory NotificationStatsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationStatsModelFromJson(json);
  NotificationStatsModel({
    required this.id,
    required this.userId,
    required this.total,
    required this.unread,
    required this.read,
    required this.typeBreakdown,
    required this.lastUpdated,
  });

  final String id;
  final String userId;
  final int total;
  final int unread;
  final int read;
  final Map<String, int> typeBreakdown;
  final String lastUpdated;

  Map<String, dynamic> toJson() => _$NotificationStatsModelToJson(this);
}
