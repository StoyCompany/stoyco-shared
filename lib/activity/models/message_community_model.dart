import 'package:json_annotation/json_annotation.dart';

part 'message_community_model.g.dart';

@JsonSerializable()
class MessageCommunityModel {
  factory MessageCommunityModel.fromJson(Map<String, dynamic> json) =>
      _$MessageCommunityModelFromJson(json);

  MessageCommunityModel({
    required this.id,
    required this.type,
    this.attributes,
  });

  final String? id;
  final String? type;
  final CommunityAttributes? attributes;
}

@JsonSerializable()
class CommunityAttributes {
  factory CommunityAttributes.fromJson(Map<String, dynamic> json) =>
      _$CommunityAttributesFromJson(json);

  CommunityAttributes({
    this.name,
    this.partnerId,
    this.partnerName,
    this.partnerType,
  });

  final String? name;
  final String? partnerId;
  final String? partnerName;
  final String? partnerType;
}
