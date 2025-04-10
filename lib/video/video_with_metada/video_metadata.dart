import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_metadata.g.dart';

@JsonSerializable()
class VideoMetadata {
  const VideoMetadata({
    this.id,
    this.videoId,
    this.createdBy,
    this.stoyCoins,
    this.shared,
    this.likes,
    this.dislikes,
    this.totalScore,
    this.enableReward,
    this.rewardPoints,
    this.createdAt,
    this.updatedAt,
    this.publicationDate,
  });

  factory VideoMetadata.fromJson(Map<String, dynamic> json) =>
      _$VideoMetadataFromJson(json);
  final String? id;
  final String? videoId;
  final String? createdBy;
  final int? stoyCoins;
  final int? shared;
  final int? likes;
  final int? dislikes;
  final int? totalScore;
  final bool? enableReward;
  final int? rewardPoints;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publicationDate;

  @override
  String toString() =>
      'VideoMetadata(id: $id, videoId: $videoId, createdBy: $createdBy, stoyCoins: $stoyCoins, shared: $shared, likes: $likes, dislikes: $dislikes, totalScore: $totalScore, enableReward: $enableReward, rewardPoints: $rewardPoints, createdAt: $createdAt, updatedAt: $updatedAt, publicationDate: $publicationDate)';

  Map<String, dynamic> toJson() => _$VideoMetadataToJson(this);

  VideoMetadata copyWith({
    String? id,
    String? videoId,
    String? createdBy,
    int? stoyCoins,
    int? shared,
    int? likes,
    int? dislikes,
    int? totalScore,
    bool? enableReward,
    int? rewardPoints,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publicationDate,
  }) =>
      VideoMetadata(
        id: id ?? this.id,
        videoId: videoId ?? this.videoId,
        createdBy: createdBy ?? this.createdBy,
        stoyCoins: stoyCoins ?? this.stoyCoins,
        shared: shared ?? this.shared,
        likes: likes ?? this.likes,
        dislikes: dislikes ?? this.dislikes,
        totalScore: totalScore ?? this.totalScore,
        enableReward: enableReward ?? this.enableReward,
        rewardPoints: rewardPoints ?? this.rewardPoints,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        publicationDate: publicationDate ?? this.publicationDate,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! VideoMetadata) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      videoId.hashCode ^
      createdBy.hashCode ^
      stoyCoins.hashCode ^
      shared.hashCode ^
      likes.hashCode ^
      dislikes.hashCode ^
      totalScore.hashCode ^
      enableReward.hashCode ^
      rewardPoints.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      publicationDate.hashCode;
}
