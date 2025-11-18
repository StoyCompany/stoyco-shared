import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/video/video_with_metada/video_metadata.dart';
import 'package:stoyco_shared/video/video_with_metada/streaming_data.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_service.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/mixins/content_access_validator_mixin.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/access_content.dart';

part 'video_with_metadata.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoWithMetadata with ContentAccessValidatorMixin {
  factory VideoWithMetadata.fromJson(Map<String, dynamic> json) =>
      _$VideoWithMetadataFromJson(json);

  const VideoWithMetadata({
    this.videoMetadata,
    this.id,
    this.videoUrl,
    this.appUrl,
    this.name,
    this.description,
    this.partnerId,
    this.order,
    this.active,
    this.createAt,
    this.streamingData,
    this.isFeaturedContent,
    this.partnerName,
    this.shared,
    this.followingCO,
    this.likeThisVideo,
    this.views,
    this.likes,
    this.isSubscriberOnly,
    this.accessContent,
    this.hasAccessWithSubscription,
  });

  final VideoMetadata? videoMetadata;
  final String? id;
  final String? videoUrl;
  final String? appUrl;
  final String? name;
  final String? description;
  final String? partnerId;
  final int? order;
  final bool? active;
  final DateTime? createAt;
  final StreamingData? streamingData;
  final bool? isFeaturedContent;
  final String? partnerName;
  final int? shared;
  final bool? followingCO;
  final bool? likeThisVideo;
  final int? views;
  final int? likes;
  final bool? isSubscriberOnly;
  final AccessContent? accessContent;
  final bool? hasAccessWithSubscription;

  @override
  String toString() =>
      'VideoWithMetadata(videoMetadata: $videoMetadata, id: $id, videoUrl: $videoUrl, appUrl: $appUrl, name: $name, description: $description, partnerId: $partnerId, order: $order, active: $active, createAt: $createAt, partnerId: $partnerId, isSubscriberOnly: $isSubscriberOnly, streamingData: $streamingData, isSubscriberOnly: $isSubscriberOnly, isFeaturedContent: $isFeaturedContent, partnerName: $partnerName, shared: $shared, followingCO: $followingCO, likeThisVideo: $likeThisVideo, views: $views, likes: $likes)';

  Map<String, dynamic> toJson() => _$VideoWithMetadataToJson(this);

  VideoWithMetadata copyWith({
    VideoMetadata? videoMetadata,
    String? id,
    String? videoUrl,
    String? appUrl,
    String? name,
    String? description,
    String? partnerId,
    int? order,
    bool? active,
    DateTime? createAt,
    StreamingData? streamingData,
    bool? isFeaturedContent,
    String? partnerName,
    int? shared,
    bool? followingCO,
    bool? likeThisVideo,
    int? views,
    int? likes,
    bool? isSubscriberOnly,
    bool? hasAccessWithSubscription,
  }) =>
      VideoWithMetadata(
        videoMetadata: videoMetadata ?? this.videoMetadata,
        id: id ?? this.id,
        videoUrl: videoUrl ?? this.videoUrl,
        appUrl: appUrl ?? this.appUrl,
        name: name ?? this.name,
        description: description ?? this.description,
        partnerId: partnerId ?? this.partnerId,
        order: order ?? this.order,
        active: active ?? this.active,
        createAt: createAt ?? this.createAt,
        streamingData: streamingData ?? this.streamingData,
        isFeaturedContent: isFeaturedContent ?? this.isFeaturedContent,
        partnerName: partnerName ?? this.partnerName,
        shared: shared ?? this.shared,
        followingCO: followingCO ?? this.followingCO,
        likeThisVideo: likeThisVideo ?? this.likeThisVideo,
        views: views ?? this.views,
        likes: likes ?? this.likes,
        isSubscriberOnly: isSubscriberOnly ?? this.isSubscriberOnly,
        hasAccessWithSubscription:
            hasAccessWithSubscription ?? this.hasAccessWithSubscription,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! VideoWithMetadata) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      videoMetadata.hashCode ^
      id.hashCode ^
      videoUrl.hashCode ^
      appUrl.hashCode ^
      name.hashCode ^
      description.hashCode ^
      partnerId.hashCode ^
      order.hashCode ^
      active.hashCode ^
      createAt.hashCode ^
      partnerId.hashCode ^
      isSubscriberOnly.hashCode ^
      streamingData.hashCode ^
      isSubscriberOnly.hashCode ^
      isFeaturedContent.hashCode ^
      partnerName.hashCode ^
      followingCO.hashCode ^
      likeThisVideo.hashCode ^
      views.hashCode ^
      likes.hashCode ^
      hasAccessWithSubscription.hashCode;

  /// Gets the best available video URL, preferring streaming URL if available
  String? get bestVideoUrl {
    // Prefer streaming URL if available and ready
    if (streamingData?.ready == true &&
        streamingData?.stream?.url != null &&
        streamingData!.stream!.url!.isNotEmpty) {
      return streamingData!.stream!.url;
    }

    // Fall back to videoUrl
    return videoUrl;
  }

  @override
  AccessContent get contentAccess => accessContent ?? AccessContent.empty();

  /// Checks if the user can access this video.
  ///
  /// Uses the mixin's hasAccess() method to validate access based on active subscriptions.
  Future<bool> canUserAccess() async => hasAccess(
        service: ActiveSubscriptionService.instance,
      );
}
