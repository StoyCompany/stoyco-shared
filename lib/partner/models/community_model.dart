import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'community_model.g.dart';

@JsonSerializable()
class CommunityModel extends Equatable {
  const CommunityModel({
    required this.id,
    this.eventId,
    this.partnerId,
    this.partnerName,
    this.partnerType,
    this.name,
    this.numberOfEvents,
    this.numberOfProducts,
    this.category,
    this.numberOfMembers,
    this.bonusMoneyPerUser,
    this.communityFund,
    this.communityFundGoal,
    this.publishedDate,
    this.createdDate,
    this.updatedDate,
    this.fullFunds,
    this.numberOfProjects,
    this.seshUrl,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityModelFromJson(json);

  @JsonKey(name: 'Id')
  final String id;

  @JsonKey(name: 'EventId')
  final String? eventId;

  @JsonKey(name: 'PartnerId')
  final String? partnerId;

  @JsonKey(name: 'PartnerName')
  final String? partnerName;

  @JsonKey(name: 'PartnerType')
  final String? partnerType;

  @JsonKey(name: 'Name')
  final String? name;

  @JsonKey(name: 'NumberOfEvents')
  final int? numberOfEvents;

  @JsonKey(name: 'NumberOfProducts')
  final int? numberOfProducts;

  @JsonKey(name: 'Category')
  final List<String>? category;

  @JsonKey(name: 'NumberOfMembers')
  final int? numberOfMembers;

  @JsonKey(name: 'BonusMoneyPerUser')
  final String? bonusMoneyPerUser;

  @JsonKey(name: 'CommunityFund')
  final String? communityFund;

  @JsonKey(name: 'CommunityFundGoal')
  final bool? communityFundGoal;

  @JsonKey(name: 'PublishedDate')
  final DateTime? publishedDate;

  @JsonKey(name: 'CreatedDate')
  final DateTime? createdDate;

  @JsonKey(name: 'UpdatedDate')
  final DateTime? updatedDate;

  @JsonKey(name: 'FullFunds')
  final bool? fullFunds;

  @JsonKey(name: 'NumberOfProjects')
  final int? numberOfProjects;

  @JsonKey(name: 'SeshUrl')
  final String? seshUrl;

  Map<String, dynamic> toJson() => _$CommunityModelToJson(this);

  CommunityModel copyWith({
    String? id,
    String? eventId,
    String? partnerId,
    String? partnerName,
    String? partnerType,
    String? name,
    int? numberOfEvents,
    int? numberOfProducts,
    List<String>? category,
    int? numberOfMembers,
    String? bonusMoneyPerUser,
    String? communityFund,
    bool? communityFundGoal,
    DateTime? publishedDate,
    DateTime? createdDate,
    DateTime? updatedDate,
    bool? fullFunds,
    int? numberOfProjects,
    String? seshUrl,
  }) =>
      CommunityModel(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        partnerId: partnerId ?? this.partnerId,
        partnerName: partnerName ?? this.partnerName,
        partnerType: partnerType ?? this.partnerType,
        name: name ?? this.name,
        numberOfEvents: numberOfEvents ?? this.numberOfEvents,
        numberOfProducts: numberOfProducts ?? this.numberOfProducts,
        category: category ?? this.category,
        numberOfMembers: numberOfMembers ?? this.numberOfMembers,
        bonusMoneyPerUser: bonusMoneyPerUser ?? this.bonusMoneyPerUser,
        communityFund: communityFund ?? this.communityFund,
        communityFundGoal: communityFundGoal ?? this.communityFundGoal,
        publishedDate: publishedDate ?? this.publishedDate,
        createdDate: createdDate ?? this.createdDate,
        updatedDate: updatedDate ?? this.updatedDate,
        fullFunds: fullFunds ?? this.fullFunds,
        numberOfProjects: numberOfProjects ?? this.numberOfProjects,
        seshUrl: seshUrl ?? this.seshUrl,
      );

  @override
  List<Object?> get props => [
        id,
        eventId,
        partnerId,
        partnerName,
        partnerType,
        name,
        numberOfEvents,
        numberOfProducts,
        category,
        numberOfMembers,
        bonusMoneyPerUser,
        communityFund,
        communityFundGoal,
        publishedDate,
        createdDate,
        updatedDate,
        fullFunds,
        numberOfProjects,
        seshUrl,
      ];
}
