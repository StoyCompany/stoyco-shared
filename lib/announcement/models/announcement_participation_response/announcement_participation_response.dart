import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:stoyco_shared/announcement/models/announcement_participation_response/metrics.dart';
import 'package:stoyco_shared/announcement/models/announcement_participation_response/publication.dart';
import 'package:stoyco_shared/announcement/models/announcement_participation_response/social_network_user.dart';

part 'announcement_participation_response.g.dart';

@JsonSerializable()
class AnnouncementParticipationResponse {
  factory AnnouncementParticipationResponse.fromJson(
          Map<String, dynamic> json) =>
      _$AnnouncementParticipationResponseFromJson(json);

  const AnnouncementParticipationResponse({
    this.announcementId,
    this.socialNetworkUser,
    this.userId,
    this.metrics,
    this.publications,
    this.createdAt,
    this.updatedAt,
  });
  @JsonKey(name: 'announcement_id')
  final String? announcementId;
  @JsonKey(name: 'social_network_user')
  final SocialNetworkUser? socialNetworkUser;
  @JsonKey(name: 'user_id')
  final String? userId;
  final Metrics? metrics;
  final List<Publication>? publications;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() =>
      'AnnouncementParticipationResponse(announcementId: $announcementId, socialNetworkUser: $socialNetworkUser, userId: $userId, metrics: $metrics, publications: $publications, createdAt: $createdAt, updatedAt: $updatedAt)';

  Map<String, dynamic> toJson() =>
      _$AnnouncementParticipationResponseToJson(this);

  AnnouncementParticipationResponse copyWith({
    String? announcementId,
    SocialNetworkUser? socialNetworkUser,
    String? userId,
    Metrics? metrics,
    List<Publication>? publications,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      AnnouncementParticipationResponse(
        announcementId: announcementId ?? this.announcementId,
        socialNetworkUser: socialNetworkUser ?? this.socialNetworkUser,
        userId: userId ?? this.userId,
        metrics: metrics ?? this.metrics,
        publications: publications ?? this.publications,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! AnnouncementParticipationResponse) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      announcementId.hashCode ^
      socialNetworkUser.hashCode ^
      userId.hashCode ^
      metrics.hashCode ^
      publications.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
