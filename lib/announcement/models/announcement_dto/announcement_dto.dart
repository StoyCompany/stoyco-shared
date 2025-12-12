import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:stoyco_shared/announcement/models/announcement_dto/configuration.dart';
import 'package:stoyco_shared/announcement/models/announcement_dto/content.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/models/response/access_content.dart';

part 'announcement_dto.g.dart';

/// Represents the state of an announcement.
enum AnnouncementState {
  /// Announcement has been published and is visible to users
  published('published'),

  /// Announcement is unpublished
  unpublished('unpublished'),

  /// Announcement is saved but not yet published
  draft('draft'),

  /// Announcement has been deleted
  deleted('deleted'),

  /// Announcement has been closed
  closed('closed');

  const AnnouncementState(this.value);

  final String value;

  static bool isDraft(String? state) => state?.toLowerCase() == draft.value;

  static bool isPublished(String? state) =>
      state?.toLowerCase() == published.value;

  static bool isDeleted(String? state) => state?.toLowerCase() == deleted.value;

  static bool isClosed(String? state) => state?.toLowerCase() == closed.value;

  static bool isUnpublished(String? state) =>
      state?.toLowerCase() == unpublished.value;
}

@JsonSerializable()
class AnnouncementDto {
  const AnnouncementDto({
    this.id,
    this.contentType,
    this.title,
    this.shortDescription,
    this.content,
    this.createdBy,
    this.urlPrincipalImage,
    this.state,
    this.isClosedCampaign,
    this.publishedDate,
    this.endDate,
    this.configuration,
    this.views,
    this.communityOwnerId,
    this.communityOwnerName,
    this.communityOwnerProfile,
    this.isSubscriberOnly,
    this.accessContent,
  });

  factory AnnouncementDto.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementDtoFromJson(json);
  final String? id;
  @JsonKey(name: 'content_type')
  final String? contentType;
  final String? title;
  @JsonKey(name: 'short_description')
  final String? shortDescription;
  final Content? content;
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @JsonKey(name: 'url_principal_image')
  final String? urlPrincipalImage;
  final String? state;
  @JsonKey(name: 'is_closed_campaign')
  final bool? isClosedCampaign;
  @JsonKey(name: 'published_date')
  final String? publishedDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  final Configuration? configuration;
  @JsonKey(name: 'views')
  final int? views;
  @JsonKey(name: 'community_owner_id')
  final String? communityOwnerId;
  @JsonKey(name: 'community_owner_name')
  final String? communityOwnerName;
  @JsonKey(name: 'community_owner_profile')
  final String? communityOwnerProfile;
  @JsonKey(name: 'is_subscriber_only')
  final bool? isSubscriberOnly;
  @JsonKey(name: 'access_content')
  final AccessContent? accessContent;

  @override
  String toString() =>
      'AnnouncementDto(id: $id, contentType: $contentType, title: $title, shortDescription: $shortDescription, content: $content, createdBy: $createdBy, urlPrincipalImage: $urlPrincipalImage, state: $state, isClosedCampaign: $isClosedCampaign, publishedDate: $publishedDate, endDate: $endDate, configuration: $configuration, views: $views, communityOwnerId: $communityOwnerId, communityOwnerName: $communityOwnerName, communityOwnerProfile: $communityOwnerProfile, isSubscriberOnly: $isSubscriberOnly, accessContent: $accessContent)';

  Map<String, dynamic> toJson() => _$AnnouncementDtoToJson(this);

  AnnouncementDto copyWith({
    String? id,
    String? contentType,
    String? title,
    String? shortDescription,
    Content? content,
    String? createdBy,
    String? urlPrincipalImage,
    String? state,
    bool? isClosedCampaign,
    String? publishedDate,
    String? endDate,
    Configuration? configuration,
    int? views,
    String? communityOwnerId,
    String? communityOwnerName,
    String? communityOwnerProfile,
    bool? isSubscriberOnly,
    AccessContent? accessContent,
  }) =>
      AnnouncementDto(
        id: id ?? this.id,
        contentType: contentType ?? this.contentType,
        title: title ?? this.title,
        shortDescription: shortDescription ?? this.shortDescription,
        content: content ?? this.content,
        createdBy: createdBy ?? this.createdBy,
        urlPrincipalImage: urlPrincipalImage ?? this.urlPrincipalImage,
        state: state ?? this.state,
        isClosedCampaign: isClosedCampaign ?? this.isClosedCampaign,
        publishedDate: publishedDate ?? this.publishedDate,
        endDate: endDate ?? this.endDate,
        configuration: configuration ?? this.configuration,
        views: views ?? this.views,
        communityOwnerId: communityOwnerId ?? this.communityOwnerId,
        communityOwnerName: communityOwnerName ?? this.communityOwnerName,
        communityOwnerProfile:
            communityOwnerProfile ?? this.communityOwnerProfile,
        isSubscriberOnly: isSubscriberOnly ?? this.isSubscriberOnly,
        accessContent: accessContent ?? this.accessContent,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! AnnouncementDto) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      contentType.hashCode ^
      title.hashCode ^
      shortDescription.hashCode ^
      content.hashCode ^
      createdBy.hashCode ^
      urlPrincipalImage.hashCode ^
      state.hashCode ^
      isClosedCampaign.hashCode ^
      publishedDate.hashCode ^
      endDate.hashCode ^
      configuration.hashCode ^
      views.hashCode ^
      communityOwnerId.hashCode ^
      communityOwnerName.hashCode ^
      communityOwnerProfile.hashCode ^
      isSubscriberOnly.hashCode ^
      accessContent.hashCode;
}
