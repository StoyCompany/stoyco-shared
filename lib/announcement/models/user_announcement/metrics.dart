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

  const Metrics({
    this.totalPublications,
    this.totalLikes,
    this.totalShares,
  });

  @override
  String toString() {
    return 'Metrics(totalPublications: $totalPublications, totalLikes: $totalLikes, totalShares: $totalShares)';
  }

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return _$MetricsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MetricsToJson(this);

  Metrics copyWith({
    int? totalPublications,
    int? totalLikes,
    int? totalShares,
  }) {
    return Metrics(
      totalPublications: totalPublications ?? this.totalPublications,
      totalLikes: totalLikes ?? this.totalLikes,
      totalShares: totalShares ?? this.totalShares,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Metrics) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      totalPublications.hashCode ^ totalLikes.hashCode ^ totalShares.hashCode;
}
