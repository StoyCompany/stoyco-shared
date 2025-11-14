import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/partner/models/community_model.dart';
import 'package:stoyco_shared/partner/models/partner_model.dart';

part 'partner_community_response.g.dart';

/// Response model for the v3 partner-community endpoint
/// Contains both Partner and Community information in a single response
@JsonSerializable()
class PartnerCommunityResponse extends Equatable {
  const PartnerCommunityResponse({
    required this.partner,
    required this.community,
  });

  factory PartnerCommunityResponse.fromJson(Map<String, dynamic> json) =>
      _$PartnerCommunityResponseFromJson(json);

  @JsonKey(name: 'Partner')
  final PartnerModel partner;

  @JsonKey(name: 'Community')
  final CommunityModel community;

  Map<String, dynamic> toJson() => _$PartnerCommunityResponseToJson(this);

  PartnerCommunityResponse copyWith({
    PartnerModel? partner,
    CommunityModel? community,
  }) =>
      PartnerCommunityResponse(
        partner: partner ?? this.partner,
        community: community ?? this.community,
      );

  @override
  List<Object?> get props => [partner, community];
}
