import 'package:json_annotation/json_annotation.dart';

part 'message_stats_model.g.dart';

@JsonSerializable()
class MessageStatsModel {
  factory MessageStatsModel.fromJson(Map<String, dynamic> json) =>
      _$MessageStatsModelFromJson(json);

  MessageStatsModel({
    required this.id,
    required this.userId,
    required this.totalNotifs,
    required this.unreadNotifs,
    required this.readNotifs,
    required this.categoryBreakdown,
    required this.lastUpdated,
  });

  final String id;
  final String userId;
  final int totalNotifs;
  final int unreadNotifs;
  final int readNotifs;
  final Map<String, int> categoryBreakdown;
  final String lastUpdated;

  Map<String, dynamic> toJson() => _$MessageStatsModelToJson(this);
}
