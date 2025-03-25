import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'configuration.g.dart';

@JsonSerializable()
class Configuration {
  @JsonKey(name: 'points_per_like')
  final int? pointsPerLike;
  @JsonKey(name: 'points_per_video')
  final int? pointsPerVideo;

  const Configuration({this.pointsPerLike, this.pointsPerVideo});

  @override
  String toString() {
    return 'Configuration(pointsPerLike: $pointsPerLike, pointsPerVideo: $pointsPerVideo)';
  }

  factory Configuration.fromJson(Map<String, dynamic> json) {
    return _$ConfigurationFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ConfigurationToJson(this);

  Configuration copyWith({
    int? pointsPerLike,
    int? pointsPerVideo,
  }) {
    return Configuration(
      pointsPerLike: pointsPerLike ?? this.pointsPerLike,
      pointsPerVideo: pointsPerVideo ?? this.pointsPerVideo,
    );
  }

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
