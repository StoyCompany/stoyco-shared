// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedResponse _$FeedResponseFromJson(Map<String, dynamic> json) => FeedResponse(
      error: (json['error'] as num).toInt(),
      messageError: json['messageError'] as String,
      tecMessageError: json['tecMessageError'] as String,
      count: (json['count'] as num).toInt(),
      data: FeedData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeedResponseToJson(FeedResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'messageError': instance.messageError,
      'tecMessageError': instance.tecMessageError,
      'count': instance.count,
      'data': instance.data.toJson(),
    };

FeedData _$FeedDataFromJson(Map<String, dynamic> json) => FeedData(
      items: (json['items'] as List<dynamic>)
          .map((e) => FeedContentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNumber: (json['pageNumber'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$FeedDataToJson(FeedData instance) => <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
    };

FeedContentItem _$FeedContentItemFromJson(Map<String, dynamic> json) =>
    FeedContentItem(
      contentId: json['contentId'] as String,
      partnerId: json['partnerId'] as String,
      partnerName: json['partnerName'] as String,
      partnerProfile: json['partnerProfile'] as String,
      partnerFrontImage: json['partnerFrontImage'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      hlsUrl: json['hlsUrl'] as String?,
      mp4Url: json['mp4Url'] as String?,
      contentCreatedAt: json['contentCreatedAt'] as String,
      isSubscriberOnly: json['isSubscriberOnly'] as bool,
      updatedAt: json['updatedAt'] as String?,
      publishedDate: json['publishedDate'] as String?,
      endDate: json['endDate'] as String?,
      mainImage: json['mainImage'] as String,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      slider: json['slider'] as List<dynamic>?,
      contentHtml: json['contentHtml'] as String?,
      detailPath: json['detailPath'] as String,
      isSubscribed: json['isSubscribed'] as bool?,
      isFollowed: json['isFollowed'] as bool?,
      sortWeight: (json['sortWeight'] as num?)?.toInt(),
      communityScore: (json['communityScore'] as num?)?.toInt(),
      sortTiebreakerId: json['sortTiebreakerId'] as String,
      isFeaturedContent: json['isFeaturedContent'] as bool,
    );

Map<String, dynamic> _$FeedContentItemToJson(FeedContentItem instance) =>
    <String, dynamic>{
      'contentId': instance.contentId,
      'partnerId': instance.partnerId,
      'partnerName': instance.partnerName,
      'partnerProfile': instance.partnerProfile,
      'partnerFrontImage': instance.partnerFrontImage,
      'title': instance.title,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'hlsUrl': instance.hlsUrl,
      'mp4Url': instance.mp4Url,
      'contentCreatedAt': instance.contentCreatedAt,
      'isSubscriberOnly': instance.isSubscriberOnly,
      'updatedAt': instance.updatedAt,
      'publishedDate': instance.publishedDate,
      'endDate': instance.endDate,
      'mainImage': instance.mainImage,
      'images': instance.images,
      'slider': instance.slider,
      'contentHtml': instance.contentHtml,
      'detailPath': instance.detailPath,
      'isSubscribed': instance.isSubscribed,
      'isFollowed': instance.isFollowed,
      'sortWeight': instance.sortWeight,
      'communityScore': instance.communityScore,
      'sortTiebreakerId': instance.sortTiebreakerId,
      'isFeaturedContent': instance.isFeaturedContent,
    };
