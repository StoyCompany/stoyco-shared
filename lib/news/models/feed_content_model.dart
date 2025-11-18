import 'package:json_annotation/json_annotation.dart';

part 'feed_content_model.g.dart';

/// Main feed response model
@JsonSerializable(explicitToJson: true)
class FeedResponse {
  const FeedResponse({
    required this.error,
    required this.messageError,
    required this.tecMessageError,
    required this.count,
    required this.data,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseFromJson(json);

  final int error;
  final String messageError;
  final String tecMessageError;
  final int count;
  final FeedData data;

  Map<String, dynamic> toJson() => _$FeedResponseToJson(this);
}

/// Paginated feed data
@JsonSerializable(explicitToJson: true)
class FeedData {
  const FeedData({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  factory FeedData.fromJson(Map<String, dynamic> json) =>
      _$FeedDataFromJson(json);

  final List<FeedContentItem> items;
  final int pageNumber;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  Map<String, dynamic> toJson() => _$FeedDataToJson(this);
}

/// Individual feed content item (flattened structure)
@JsonSerializable()
class FeedContentItem {
  const FeedContentItem({
    required this.contentId,
    required this.partnerId,
    required this.partnerName,
    required this.partnerProfile,
    this.partnerFrontImage,
    required this.title,
    required this.description,
    required this.thumbnail,
    this.hlsUrl,
    this.mp4Url,
    required this.contentCreatedAt,
    this.updatedAt,
    this.publishedDate,
    this.endDate,
    required this.mainImage,
    this.images,
    this.slider,
    this.contentHtml,
    required this.detailPath,
    this.isSubscribed,
    this.isFollowed,
    this.sortWeight,
    this.communityScore,
    required this.sortTiebreakerId,
    required this.isFeaturedContent,
    this.customData,
    this.state,
    this.isSubscriberOnly = false,
    bool? hasAccess,
    this.accessContent,
  }) : hasAccess = hasAccess ?? !isSubscriberOnly;

  factory FeedContentItem.fromJson(Map<String, dynamic> json) => _$FeedContentItemFromJson(json);

  final String contentId;
  final String partnerId;
  final String partnerName;
  final String partnerProfile;
  final String? partnerFrontImage;
  final String title;
  final String description;
  final String thumbnail;
  final String? hlsUrl;
  final String? mp4Url;
  final String contentCreatedAt;
  final String? updatedAt;
  final String? publishedDate;
  final String? endDate;
  final String mainImage;
  final List<String>? images;
  final List<dynamic>? slider;
  final String? contentHtml;
  final String detailPath;
  final bool? isSubscribed;
  final bool? isFollowed;
  final int? sortWeight;
  final int? communityScore;
  final String sortTiebreakerId;
  final bool isFeaturedContent;
  /// Custom data map (e.g., publication flags). announcements
  final Map<String, dynamic>? customData;
  /// Publication state (e.g., 'published').
  final String? state;
  final bool isSubscriberOnly;
  /// This value is constructed in the frontend and is not mapped from backend JSON.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool hasAccess;
  final AccessContent? accessContent;

  Map<String, dynamic> toJson() => _$FeedContentItemToJson(this);
}

@JsonSerializable()
class AccessContent {
  const AccessContent({
    required this.contentId,
    required this.partnerId,
    required this.planIds,
    this.visibleFrom,
    this.visibleUntil,
  });

  factory AccessContent.fromJson(Map<String, dynamic> json) => _$AccessContentFromJson(json);

  final String contentId;
  final String partnerId;
  final List<String> planIds;
  final DateTime? visibleFrom;
  final DateTime? visibleUntil;

  Map<String, dynamic> toJson() => _$AccessContentToJson(this);

}
