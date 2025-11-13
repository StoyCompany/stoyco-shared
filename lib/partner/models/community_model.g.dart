// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityModel _$CommunityModelFromJson(Map<String, dynamic> json) =>
    CommunityModel(
      id: json['Id'] as String,
      eventId: json['EventId'] as String?,
      partnerId: json['PartnerId'] as String?,
      partnerName: json['PartnerName'] as String?,
      partnerType: json['PartnerType'] as String?,
      name: json['Name'] as String?,
      numberOfEvents: (json['NumberOfEvents'] as num?)?.toInt(),
      numberOfProducts: (json['NumberOfProducts'] as num?)?.toInt(),
      category: (json['Category'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      numberOfMembers: (json['NumberOfMembers'] as num?)?.toInt(),
      bonusMoneyPerUser: json['BonusMoneyPerUser'] as String?,
      communityFund: json['CommunityFund'] as String?,
      communityFundGoal: json['CommunityFundGoal'] as bool?,
      publishedDate: json['PublishedDate'] == null
          ? null
          : DateTime.parse(json['PublishedDate'] as String),
      createdDate: json['CreatedDate'] == null
          ? null
          : DateTime.parse(json['CreatedDate'] as String),
      updatedDate: json['UpdatedDate'] == null
          ? null
          : DateTime.parse(json['UpdatedDate'] as String),
      fullFunds: json['FullFunds'] as bool?,
      numberOfProjects: (json['NumberOfProjects'] as num?)?.toInt(),
      seshUrl: json['SeshUrl'] as String?,
    );

Map<String, dynamic> _$CommunityModelToJson(CommunityModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'EventId': instance.eventId,
      'PartnerId': instance.partnerId,
      'PartnerName': instance.partnerName,
      'PartnerType': instance.partnerType,
      'Name': instance.name,
      'NumberOfEvents': instance.numberOfEvents,
      'NumberOfProducts': instance.numberOfProducts,
      'Category': instance.category,
      'NumberOfMembers': instance.numberOfMembers,
      'BonusMoneyPerUser': instance.bonusMoneyPerUser,
      'CommunityFund': instance.communityFund,
      'CommunityFundGoal': instance.communityFundGoal,
      'PublishedDate': instance.publishedDate?.toIso8601String(),
      'CreatedDate': instance.createdDate?.toIso8601String(),
      'UpdatedDate': instance.updatedDate?.toIso8601String(),
      'FullFunds': instance.fullFunds,
      'NumberOfProjects': instance.numberOfProjects,
      'SeshUrl': instance.seshUrl,
    };
