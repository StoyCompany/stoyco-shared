import 'package:json_annotation/json_annotation.dart';

part 'message_community_model.g.dart';

@JsonSerializable()
class MessageCommunityModel {
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
      CommunityAttributes(
        name: json['name'] as String?,
        partnerId: json['partnerId'] as String?,
        partnerName: json['partnerName'] as String?,
        partnerType: json['partnerType'] as String?,
      );

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
