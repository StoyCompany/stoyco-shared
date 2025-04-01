import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'social_network_user.g.dart';

@JsonSerializable()
class SocialNetworkUser {

  const SocialNetworkUser({this.username, this.platform});

  factory SocialNetworkUser.fromJson(Map<String, dynamic> json) =>
      _$SocialNetworkUserFromJson(json);
  final String? username;
  final String? platform;

  @override
  String toString() =>
      'SocialNetworkUser(username: $username, platform: $platform)';

  Map<String, dynamic> toJson() => _$SocialNetworkUserToJson(this);

  SocialNetworkUser copyWith({
    String? username,
    String? platform,
  }) =>
      SocialNetworkUser(
        username: username ?? this.username,
        platform: platform ?? this.platform,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! SocialNetworkUser) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => username.hashCode ^ platform.hashCode;
}
