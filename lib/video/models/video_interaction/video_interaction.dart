import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_interaction.g.dart';

@JsonSerializable()
class VideoInteraction {
  const VideoInteraction({
    this.id,
    this.title,
    this.url,
    this.likes,
    this.dislikes,
    this.shared,
    this.totalScore,
  });

  factory VideoInteraction.fromJson(Map<String, dynamic> json) =>
      _$VideoInteractionFromJson(json);
  final String? id;
  final String? title;
  final String? url;
  final int? likes;
  final int? dislikes;
  final int? shared;
  final int? totalScore;

  @override
  String toString() =>
      'VideoInteraction(id: $id, title: $title, url: $url, likes: $likes, dislikes: $dislikes, shared: $shared, totalScore: $totalScore)';

  Map<String, dynamic> toJson() => _$VideoInteractionToJson(this);

  VideoInteraction copyWith({
    String? id,
    String? title,
    String? url,
    int? likes,
    int? dislikes,
    int? shared,
    int? totalScore,
  }) =>
      VideoInteraction(
        id: id ?? this.id,
        title: title ?? this.title,
        url: url ?? this.url,
        likes: likes ?? this.likes,
        dislikes: dislikes ?? this.dislikes,
        shared: shared ?? this.shared,
        totalScore: totalScore ?? this.totalScore,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! VideoInteraction) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      url.hashCode ^
      likes.hashCode ^
      dislikes.hashCode ^
      shared.hashCode ^
      totalScore.hashCode;
}
