// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageCommunityModel _$MessageCommunityModelFromJson(
        Map<String, dynamic> json) =>
    MessageCommunityModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      attributes: json['attributes'] == null
          ? null
          : CommunityAttributes.fromJson(
              json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageCommunityModelToJson(
        MessageCommunityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attributes': instance.attributes,
    };

CommunityAttributes _$CommunityAttributesFromJson(Map<String, dynamic> json) =>
    CommunityAttributes(
      name: json['name'] as String?,
      partnerId: json['partnerId'] as String?,
      partnerName: json['partnerName'] as String?,
      partnerType: json['partnerType'] as String?,
    );

Map<String, dynamic> _$CommunityAttributesToJson(
        CommunityAttributes instance) =>
    <String, dynamic>{
      'name': instance.name,
      'partnerId': instance.partnerId,
      'partnerName': instance.partnerName,
      'partnerType': instance.partnerType,
    };
