import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_model.g.dart';

@JsonSerializable()
class PartnerModel extends Equatable {
  const PartnerModel({
    required this.id,
    required this.profile,
    this.communityId,
    required this.name,
    this.description,
    this.musicalGenre,
    this.category,
    this.city,
    this.country,
    this.countryFlag,
    this.frontImage,
    this.bannerImage,
    this.additionalImages,
    this.socialNetworkStatistic,
    this.socialNetwork,
    this.numberEvents,
    this.numberProducts,
    this.createdDate,
    this.active,
    this.collectionId,
    this.handleShopify,
    this.partnerUrl,
    this.followersCount,
    this.order,
    this.coLines,
    this.coTypes,
    this.mainMarketSegment,
    this.secondaryMarketSegments,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) =>
      _$PartnerModelFromJson(json);

  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'Profile')
  final String profile;

  @JsonKey(name: 'CommunityId')
  final String? communityId;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Description')
  final String? description;

  @JsonKey(name: 'MusicalGenre')
  final String? musicalGenre;

  @JsonKey(name: 'Category')
  final String? category;

  @JsonKey(name: 'City')
  final String? city;

  @JsonKey(name: 'Country')
  final String? country;

  @JsonKey(name: 'CountryFlag')
  final String? countryFlag;

  @JsonKey(name: 'FrontImage')
  final String? frontImage;

  @JsonKey(name: 'BannerImage')
  final String? bannerImage;

  @JsonKey(name: 'AdditionalImages')
  final List<String>? additionalImages;

  @JsonKey(name: 'SocialNetworkStatistic')
  final SocialNetworkStatisticModel? socialNetworkStatistic;

  @JsonKey(name: 'SocialNetwork')
  final List<SocialNetworkModel>? socialNetwork;

  @JsonKey(name: 'NumberEvents')
  final int? numberEvents;

  @JsonKey(name: 'NumberProducts')
  final int? numberProducts;

  @JsonKey(name: 'CreatedDate')
  final DateTime? createdDate;

  @JsonKey(name: 'Active')
  final bool? active;

  @JsonKey(name: 'CollectionId')
  final String? collectionId;

  @JsonKey(name: 'HandleShopify')
  final String? handleShopify;

  @JsonKey(name: 'PartnerUrl')
  final String? partnerUrl;

  @JsonKey(name: 'FollowersCount')
  final int? followersCount;

  @JsonKey(name: 'Order')
  final int? order;

  @JsonKey(name: 'CoLines')
  final String? coLines;

  @JsonKey(name: 'CoTypes')
  final String? coTypes;

  @JsonKey(name: 'MainMarketSegment')
  final String? mainMarketSegment;

  @JsonKey(name: 'SecondaryMarketSegments')
  final List<String>? secondaryMarketSegments;

  Map<String, dynamic> toJson() => _$PartnerModelToJson(this);

  PartnerModel copyWith({
    String? id,
    String? profile,
    String? communityId,
    String? name,
    String? description,
    String? musicalGenre,
    String? category,
    String? city,
    String? country,
    String? countryFlag,
    String? frontImage,
    String? bannerImage,
    List<String>? additionalImages,
    SocialNetworkStatisticModel? socialNetworkStatistic,
    List<SocialNetworkModel>? socialNetwork,
    int? numberEvents,
    int? numberProducts,
    DateTime? createdDate,
    bool? active,
    String? collectionId,
    String? handleShopify,
    String? partnerUrl,
    int? followersCount,
    int? order,
    String? coLines,
    String? coTypes,
    String? mainMarketSegment,
    List<String>? secondaryMarketSegments,
  }) =>
      PartnerModel(
        id: id ?? this.id,
        profile: profile ?? this.profile,
        communityId: communityId ?? this.communityId,
        name: name ?? this.name,
        description: description ?? this.description,
        musicalGenre: musicalGenre ?? this.musicalGenre,
        category: category ?? this.category,
        city: city ?? this.city,
        country: country ?? this.country,
        countryFlag: countryFlag ?? this.countryFlag,
        frontImage: frontImage ?? this.frontImage,
        bannerImage: bannerImage ?? this.bannerImage,
        additionalImages: additionalImages ?? this.additionalImages,
        socialNetworkStatistic:
            socialNetworkStatistic ?? this.socialNetworkStatistic,
        socialNetwork: socialNetwork ?? this.socialNetwork,
        numberEvents: numberEvents ?? this.numberEvents,
        numberProducts: numberProducts ?? this.numberProducts,
        createdDate: createdDate ?? this.createdDate,
        active: active ?? this.active,
        collectionId: collectionId ?? this.collectionId,
        handleShopify: handleShopify ?? this.handleShopify,
        partnerUrl: partnerUrl ?? this.partnerUrl,
        followersCount: followersCount ?? this.followersCount,
        order: order ?? this.order,
        coLines: coLines ?? this.coLines,
        coTypes: coTypes ?? this.coTypes,
        mainMarketSegment: mainMarketSegment ?? this.mainMarketSegment,
        secondaryMarketSegments:
            secondaryMarketSegments ?? this.secondaryMarketSegments,
      );

  @override
  List<Object?> get props => [
        id,
        profile,
        communityId,
        name,
        description,
        musicalGenre,
        category,
        city,
        country,
        countryFlag,
        frontImage,
        bannerImage,
        additionalImages,
        socialNetworkStatistic,
        socialNetwork,
        numberEvents,
        numberProducts,
        createdDate,
        active,
        collectionId,
        handleShopify,
        partnerUrl,
        followersCount,
        order,
        coLines,
        coTypes,
        mainMarketSegment,
        secondaryMarketSegments,
      ];

  /// Gets carousel images for the header
  /// Uses additionalImages if available, otherwise fallback to frontImage and bannerImage
  /// Returns list with up to 6 images
  List<String> get carouselImages {
    if (additionalImages != null && additionalImages!.isNotEmpty) {
      return additionalImages!.take(6).toList();
    }

    final images = <String>[];
    if (bannerImage != null && bannerImage!.isNotEmpty) {
      images.add(bannerImage!);
    }
    if (frontImage != null && frontImage!.isNotEmpty) {
      images.add(frontImage!);
    }
    return images;
  }

  /// Check if profile is Brand
  bool get isPartner => profile == 'Brand';

  /// Check if has more than one social network
  bool get hasMoreThanOneSocialNetwork =>
      socialNetwork != null && socialNetwork!.length > 1;
}

@JsonSerializable()
class SocialNetworkStatisticModel extends Equatable {
  const SocialNetworkStatisticModel({
    required this.id,
    this.name,
    this.photo,
  });

  factory SocialNetworkStatisticModel.fromJson(Map<String, dynamic> json) =>
      _$SocialNetworkStatisticModelFromJson(json);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'Name')
  final String? name;

  @JsonKey(name: 'Photo')
  final String? photo;

  Map<String, dynamic> toJson() => _$SocialNetworkStatisticModelToJson(this);

  @override
  List<Object?> get props => [id, name, photo];
}

@JsonSerializable()
class SocialNetworkModel extends Equatable {
  const SocialNetworkModel({
    required this.name,
    this.url,
    this.keyChartMetric,
    this.followers,
  });

  factory SocialNetworkModel.fromJson(Map<String, dynamic> json) =>
      _$SocialNetworkModelFromJson(json);

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Url')
  final String? url;

  @JsonKey(name: 'KeyChartMetric')
  final String? keyChartMetric;

  @JsonKey(name: 'Followers')
  final int? followers;

  Map<String, dynamic> toJson() => _$SocialNetworkModelToJson(this);

  @override
  List<Object?> get props => [name, url, keyChartMetric, followers];
}
