import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MessageCommunityModel {
  factory MessageCommunityModel.fromJson(Map<String, dynamic> json) =>
      MessageCommunityModel(
        id: json['id'] as String?,
        type: json['type'] as String,
        attributes: json['attributes'] == null
            ? null
            : CommunityAttributes.fromJson(
                json['attributes'] as Map<String, dynamic>,
              ),
      );

  MessageCommunityModel({
    required this.id,
    required this.type,
    this.attributes,
  });

  final String? id;
  final String type;
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
