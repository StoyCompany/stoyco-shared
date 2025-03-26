import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'metrics.g.dart';

@JsonSerializable()
class Metrics {
  @JsonKey(name: 'total_publications')
  final int? totalPublications;
  @JsonKey(name: 'total_likes')
  final int? totalLikes;
  @JsonKey(name: 'total_shares')
  final int? totalShares;
  @JsonKey(name: 'total_views')
  final int? totalViews;

  const Metrics({
    this.totalPublications,
    this.totalLikes,
    this.totalShares,
    this.totalViews,
  });

  @override
  String toString() =>
      'Metrics(totalPublications: $totalPublications, totalLikes: $totalLikes, totalShares: $totalShares, totalViews: $totalViews)';

  factory Metrics.fromJson(Map<String, dynamic> json) =>
      _$MetricsFromJson(json);

  Map<String, dynamic> toJson() => _$MetricsToJson(this);

  Metrics copyWith({
    int? totalPublications,
    int? totalLikes,
    int? totalShares,
    int? totalViews,
  }) =>
      Metrics(
        totalPublications: totalPublications ?? this.totalPublications,
        totalLikes: totalLikes ?? this.totalLikes,
        totalShares: totalShares ?? this.totalShares,
        totalViews: totalViews ?? this.totalViews,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Metrics) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      totalPublications.hashCode ^
      totalLikes.hashCode ^
      totalShares.hashCode ^
      totalViews.hashCode;
}
