import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/access_content.dart';

part 'video_player_model.g.dart';

@JsonSerializable()
class VideoPlayerModel {
  const VideoPlayerModel({
    this.id,
    this.appUrl,
    this.name,
    this.description,
    this.order,
    this.isSubscriberOnly = false,
    bool? hasAccessWithSubscription,
    this.accessContent,
  }) : hasAccessWithSubscription =
            hasAccessWithSubscription ?? !isSubscriberOnly;

  factory VideoPlayerModel.fromJson(Map<String, dynamic> json) =>
      _$VideoPlayerModelFromJson(json);

  final String? id;
  final String? appUrl;
  final String? name;
  final String? description;
  final int? order;
  final bool isSubscriberOnly;

  /// This value is constructed in the frontend and is not mapped from backend JSON.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool hasAccessWithSubscription;
  final AccessContent? accessContent;

  Map<String, dynamic> toJson() => _$VideoPlayerModelToJson(this);

  VideoPlayerModel copyWith({
    String? id,
    String? appUrl,
    String? name,
    String? description,
    int? order,
    bool? isSubscriberOnly,
    bool? hasAccessWithSubscription,
    AccessContent? accessContent,
  }) =>
      VideoPlayerModel(
        id: id ?? this.id,
        appUrl: appUrl ?? this.appUrl,
        name: name ?? this.name,
        description: description ?? this.description,
        order: order ?? this.order,
        isSubscriberOnly: isSubscriberOnly ?? this.isSubscriberOnly,
        hasAccessWithSubscription:
            hasAccessWithSubscription ?? this.hasAccessWithSubscription,
        accessContent: accessContent ?? this.accessContent,
      );

  @override
  String toString() =>
      'VideoPlayerModel(id: $id, appUrl: $appUrl, name: $name, description: $description, order: $order, isSubscriberOnly: $isSubscriberOnly, hasAccessWithSubscription: $hasAccessWithSubscription, accessContent: $accessContent)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! VideoPlayerModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      appUrl.hashCode ^
      name.hashCode ^
      description.hashCode ^
      order.hashCode ^
      isSubscriberOnly.hashCode ^
      hasAccessWithSubscription.hashCode ^
      accessContent.hashCode;
}
