import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/video/models/video_interaction/video_interaction.dart';

part 'user_video_reaction.g.dart';

/// Represents a user's reaction to a video.
///
/// The `reactionType` can be either "Like" or "Dislike".
@JsonSerializable()
class UserVideoReaction {
  factory UserVideoReaction.fromJson(Map<String, dynamic> json) =>
      _$UserVideoReactionFromJson(json);

  /// Creates a new instance of [UserVideoReaction].
  ///
  /// [id] is the unique identifier.
  /// [videoId] refers to the associated video.
  /// [userId] refers to the user who reacted.
  /// [reactionType] can be "Like" or "Dislike".
  /// [title] is an optional title for the reaction.
  /// [createdAt] is the timestamp of the reaction.
  const UserVideoReaction({
    this.id,
    this.videoId,
    this.userId,
    this.reactionType,
    this.title,
    this.createdAt,
    this.videoMetadata,
  });

  /// The unique identifier of the reaction.
  final String? id;

  /// The identifier of the associated video.
  final String? videoId;

  /// The identifier of the user who reacted.
  final String? userId;

  /// The type of reaction, either "Like" or "Dislike".
  final String? reactionType;

  /// An optional title for the reaction.
  final String? title;

  /// The timestamp when the reaction was created.
  final DateTime? createdAt;

  /// The metadata of the associated video.
  final VideoInteraction? videoMetadata;

  /// Example of creating a [UserVideoReaction].
  ///
  /// ```dart
  /// final reaction = UserVideoReaction(
  ///   id: '123',
  ///   videoId: 'video_456',
  ///   userId: 'user_789',
  ///   reactionType: 'Like',
  ///   title: 'Great video!',
  ///   createdAt: DateTime.now(),
  /// );
  /// ```
  @override
  String toString() =>
      'UserVideoReaction(id: $id, videoId: $videoId, userId: $userId, reactionType: $reactionType, title: $title, createdAt: $createdAt)';

  Map<String, dynamic> toJson() => _$UserVideoReactionToJson(this);

  UserVideoReaction copyWith({
    String? id,
    String? videoId,
    String? userId,
    String? reactionType,
    String? title,
    DateTime? createdAt,
    VideoInteraction? videoMetadata,
  }) =>
      UserVideoReaction(
        id: id ?? this.id,
        videoId: videoId ?? this.videoId,
        userId: userId ?? this.userId,
        reactionType: reactionType ?? this.reactionType,
        title: title ?? this.title,
        createdAt: createdAt ?? this.createdAt,
        videoMetadata: videoMetadata,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserVideoReaction) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson()) && other.title == title;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      videoId.hashCode ^
      userId.hashCode ^
      reactionType.hashCode ^
      title.hashCode ^
      createdAt.hashCode ^
      videoMetadata.hashCode;
}
