import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'metrics.dart';

part 'user_announcement.g.dart';

@JsonSerializable()
class UserAnnouncement {
  factory UserAnnouncement.fromJson(Map<String, dynamic> json) =>
      _$UserAnnouncementFromJson(json);

  const UserAnnouncement({
    this.userId,
    this.userPhoto,
    this.username,
    this.platform,
    this.metrics,
    this.puntos,
  });
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'user_photo')
  final String? userPhoto;
  final String? username;
  final String? platform;
  final Metrics? metrics;
  final int? puntos;

  @override
  String toString() =>
      'UserAnnouncement(userId: $userId, userPhoto: $userPhoto, username: $username, platform: $platform, metrics: $metrics, puntos: $puntos)';

  Map<String, dynamic> toJson() => _$UserAnnouncementToJson(this);

  UserAnnouncement copyWith({
    String? userId,
    String? userPhoto,
    String? username,
    String? platform,
    Metrics? metrics,
    int? puntos,
  }) =>
      UserAnnouncement(
        userId: userId ?? this.userId,
        userPhoto: userPhoto ?? this.userPhoto,
        username: username ?? this.username,
        platform: platform ?? this.platform,
        metrics: metrics ?? this.metrics,
        puntos: puntos ?? this.puntos,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserAnnouncement) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      userPhoto.hashCode ^
      username.hashCode ^
      platform.hashCode ^
      metrics.hashCode ^
      puntos.hashCode;
}
