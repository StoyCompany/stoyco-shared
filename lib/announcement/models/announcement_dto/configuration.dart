import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'configuration.g.dart';

@JsonSerializable()
class Configuration {
  const Configuration({this.pointsPerLike, this.pointsPerVideo});

  factory Configuration.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationFromJson(json);
  @JsonKey(name: 'points_per_like')
  final int? pointsPerLike;
  @JsonKey(name: 'points_per_video')
  final int? pointsPerVideo;

  @override
  String toString() =>
      'Configuration(pointsPerLike: $pointsPerLike, pointsPerVideo: $pointsPerVideo)';

  Map<String, dynamic> toJson() => _$ConfigurationToJson(this);

  Configuration copyWith({
    int? pointsPerLike,
    int? pointsPerVideo,
  }) =>
      Configuration(
        pointsPerLike: pointsPerLike ?? this.pointsPerLike,
        pointsPerVideo: pointsPerVideo ?? this.pointsPerVideo,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Configuration) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => pointsPerLike.hashCode ^ pointsPerVideo.hashCode;
}
