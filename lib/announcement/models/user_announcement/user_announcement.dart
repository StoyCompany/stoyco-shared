import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'metrics.dart';

part 'user_announcement.g.dart';

@JsonSerializable()
class UserAnnouncement {
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'user_photo')
  final String? userPhoto;
  final String? username;
  final String? platform;
  final Metrics? metrics;
  final int? puntos;

  const UserAnnouncement({
    this.userId,
    this.userPhoto,
    this.username,
    this.platform,
    this.metrics,
    this.puntos,
  });

  @override
  String toString() {
    return 'UserAnnouncement(userId: $userId, userPhoto: $userPhoto, username: $username, platform: $platform, metrics: $metrics, puntos: $puntos)';
  }

  factory UserAnnouncement.fromJson(Map<String, dynamic> json) {
    return _$UserAnnouncementFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserAnnouncementToJson(this);

  UserAnnouncement copyWith({
    String? userId,
    String? userPhoto,
    String? username,
    String? platform,
    Metrics? metrics,
    int? puntos,
  }) {
    return UserAnnouncement(
      userId: userId ?? this.userId,
      userPhoto: userPhoto ?? this.userPhoto,
      username: username ?? this.username,
      platform: platform ?? this.platform,
      metrics: metrics ?? this.metrics,
      puntos: puntos ?? this.puntos,
    );
  }

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
