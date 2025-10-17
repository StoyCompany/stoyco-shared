import 'package:json_annotation/json_annotation.dart';

part 'activity_summary_model.g.dart';

@JsonSerializable()
class ActivitySummaryModel {
  ActivitySummaryModel({
    required this.id,
    required this.unreadNotifications,
    required this.unreadMessages,
    required this.totalUnread,
    required this.lastUpdated,
  });

  final String id;
  final int unreadNotifications;
  final int unreadMessages;
  final int totalUnread;
  final String lastUpdated;

  factory ActivitySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ActivitySummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivitySummaryModelToJson(this);
}
