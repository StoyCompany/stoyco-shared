// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerModel _$PartnerModelFromJson(Map<String, dynamic> json) => PartnerModel(
      id: json['Id'] as String,
      profile: json['Profile'] as String,
      communityId: json['CommunityId'] as String?,
      name: json['Name'] as String,
      description: json['Description'] as String?,
      musicalGenre: json['MusicalGenre'] as String?,
      category: json['Category'] as String?,
      city: json['City'] as String?,
      country: json['Country'] as String?,
      countryFlag: json['CountryFlag'] as String?,
      frontImage: json['FrontImage'] as String?,
      bannerImage: json['BannerImage'] as String?,
      additionalImages: (json['AdditionalImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      socialNetworkStatistic: json['SocialNetworkStatistic'] == null
          ? null
          : SocialNetworkStatisticModel.fromJson(
              json['SocialNetworkStatistic'] as Map<String, dynamic>),
      socialNetwork: (json['SocialNetwork'] as List<dynamic>?)
          ?.map((e) => SocialNetworkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberEvents: (json['NumberEvents'] as num?)?.toInt(),
      numberProducts: (json['NumberProducts'] as num?)?.toInt(),
      createdDate: json['CreatedDate'] == null
          ? null
          : DateTime.parse(json['CreatedDate'] as String),
      active: json['Active'] as bool?,
      collectionId: json['CollectionId'] as String?,
      handleShopify: json['HandleShopify'] as String?,
      partnerUrl: json['PartnerUrl'] as String?,
      followersCount: (json['FollowersCount'] as num?)?.toInt(),
      order: (json['Order'] as num?)?.toInt(),
      coLines: json['CoLines'] as String?,
      coTypes: json['CoTypes'] as String?,
      mainMarketSegment: json['MainMarketSegment'] as String?,
      secondaryMarketSegments:
          (json['SecondaryMarketSegments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$PartnerModelToJson(PartnerModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Profile': instance.profile,
      'CommunityId': instance.communityId,
      'Name': instance.name,
      'Description': instance.description,
      'MusicalGenre': instance.musicalGenre,
      'Category': instance.category,
      'City': instance.city,
      'Country': instance.country,
      'CountryFlag': instance.countryFlag,
      'FrontImage': instance.frontImage,
      'BannerImage': instance.bannerImage,
      'AdditionalImages': instance.additionalImages,
      'SocialNetworkStatistic': instance.socialNetworkStatistic,
      'SocialNetwork': instance.socialNetwork,
      'NumberEvents': instance.numberEvents,
      'NumberProducts': instance.numberProducts,
      'CreatedDate': instance.createdDate?.toIso8601String(),
      'Active': instance.active,
      'CollectionId': instance.collectionId,
      'HandleShopify': instance.handleShopify,
      'PartnerUrl': instance.partnerUrl,
      'FollowersCount': instance.followersCount,
      'Order': instance.order,
      'CoLines': instance.coLines,
      'CoTypes': instance.coTypes,
      'MainMarketSegment': instance.mainMarketSegment,
      'SecondaryMarketSegments': instance.secondaryMarketSegments,
    };

SocialNetworkStatisticModel _$SocialNetworkStatisticModelFromJson(
        Map<String, dynamic> json) =>
    SocialNetworkStatisticModel(
      id: json['id'] as String,
      name: json['Name'] as String?,
      photo: json['Photo'] as String?,
    );

Map<String, dynamic> _$SocialNetworkStatisticModelToJson(
        SocialNetworkStatisticModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'Name': instance.name,
      'Photo': instance.photo,
    };

SocialNetworkModel _$SocialNetworkModelFromJson(Map<String, dynamic> json) =>
    SocialNetworkModel(
      name: json['Name'] as String,
      url: json['Url'] as String?,
      keyChartMetric: json['KeyChartMetric'] as String?,
      followers: (json['Followers'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SocialNetworkModelToJson(SocialNetworkModel instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Url': instance.url,
      'KeyChartMetric': instance.keyChartMetric,
      'Followers': instance.followers,
    };
