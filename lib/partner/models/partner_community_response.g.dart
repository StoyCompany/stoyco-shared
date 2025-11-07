// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_community_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerCommunityResponse _$PartnerCommunityResponseFromJson(
        Map<String, dynamic> json) =>
    PartnerCommunityResponse(
      partner: PartnerModel.fromJson(json['Partner'] as Map<String, dynamic>),
      community:
          CommunityModel.fromJson(json['Community'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PartnerCommunityResponseToJson(
        PartnerCommunityResponse instance) =>
    <String, dynamic>{
      'Partner': instance.partner,
      'Community': instance.community,
    };
