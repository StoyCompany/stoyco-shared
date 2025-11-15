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
    required this.isSubscriberOnly,
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
    this.feedType,
  });

  factory FeedContentItem.fromJson(Map<String, dynamic> json) =>
      _$FeedContentItemFromJson(json);

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
  final bool isSubscriberOnly;
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
  /// Feed type (e.g., 'news', 'announcements'). Not returned by API, injected by repository.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? feedType;

  Map<String, dynamic> toJson() => _$FeedContentItemToJson(this);

  /// Creates a copy of this item with the given fields replaced with new values.
  FeedContentItem copyWith({
    String? contentId,
    String? partnerId,
    String? partnerName,
    String? partnerProfile,
    String? partnerFrontImage,
    String? title,
    String? description,
    String? thumbnail,
    String? hlsUrl,
    String? mp4Url,
    String? contentCreatedAt,
    bool? isSubscriberOnly,
    String? updatedAt,
    String? publishedDate,
    String? endDate,
    String? mainImage,
    List<String>? images,
    List<dynamic>? slider,
    String? contentHtml,
    String? detailPath,
    bool? isSubscribed,
    bool? isFollowed,
    int? sortWeight,
    int? communityScore,
    String? sortTiebreakerId,
    bool? isFeaturedContent,
    Map<String, dynamic>? customData,
    String? state,
    String? feedType,
  }) => FeedContentItem(
      contentId: contentId ?? this.contentId,
      partnerId: partnerId ?? this.partnerId,
      partnerName: partnerName ?? this.partnerName,
      partnerProfile: partnerProfile ?? this.partnerProfile,
      partnerFrontImage: partnerFrontImage ?? this.partnerFrontImage,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      hlsUrl: hlsUrl ?? this.hlsUrl,
      mp4Url: mp4Url ?? this.mp4Url,
      contentCreatedAt: contentCreatedAt ?? this.contentCreatedAt,
      isSubscriberOnly: isSubscriberOnly ?? this.isSubscriberOnly,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedDate: publishedDate ?? this.publishedDate,
      endDate: endDate ?? this.endDate,
      mainImage: mainImage ?? this.mainImage,
      images: images ?? this.images,
      slider: slider ?? this.slider,
      contentHtml: contentHtml ?? this.contentHtml,
      detailPath: detailPath ?? this.detailPath,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      isFollowed: isFollowed ?? this.isFollowed,
      sortWeight: sortWeight ?? this.sortWeight,
      communityScore: communityScore ?? this.communityScore,
      sortTiebreakerId: sortTiebreakerId ?? this.sortTiebreakerId,
      isFeaturedContent: isFeaturedContent ?? this.isFeaturedContent,
      customData: customData ?? this.customData,
      state: state ?? this.state,
      feedType: feedType ?? this.feedType,
    );
}
