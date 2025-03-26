import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'publication.dart';
import 'social_network_user.dart';

part 'announcement_participation.g.dart';


@JsonSerializable()
class AnnouncementParticipation {
  const AnnouncementParticipation({
    this.userId,
    this.socialNetworkUser,
    this.publications,
  });

  factory AnnouncementParticipation.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementParticipationFromJson(json);
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'social_network_user')
  final SocialNetworkUser? socialNetworkUser;
  final List<Publication>? publications;

  @override
  String toString() =>
      'AnnouncementParticipation(userId: $userId, socialNetworkUser: $socialNetworkUser, publications: $publications)';

  Map<String, dynamic> toJson() => _$AnnouncementParticipationToJson(this);

  AnnouncementParticipation copyWith({
    String? userId,
    SocialNetworkUser? socialNetworkUser,
    List<Publication>? publications,
  }) =>
      AnnouncementParticipation(
        userId: userId ?? this.userId,
        socialNetworkUser: socialNetworkUser ?? this.socialNetworkUser,
        publications: publications ?? this.publications,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! AnnouncementParticipation) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      userId.hashCode ^ socialNetworkUser.hashCode ^ publications.hashCode;
}
