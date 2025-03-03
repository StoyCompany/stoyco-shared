//VideoInfoWithUserInteraction

import 'package:stoyco_shared/video/models/video_reaction/user_video_reaction.dart';
import 'package:stoyco_shared/video/video_with_metada/video_with_metadata.dart';

class VideoInfoWithUserInteraction {
  VideoInfoWithUserInteraction({
    this.video = const VideoWithMetadata(),
    this.userVideoReaction = const UserVideoReaction(),
  }) {
    _hasLiked = userVideoReaction.reactionType == 'Like';
    _hasDisliked = userVideoReaction.reactionType == 'Dislike';
  }
  bool _hasLiked = false;
  bool _hasDisliked = false;
  final VideoWithMetadata video;
  final UserVideoReaction userVideoReaction;

  //getters
  bool get hasLiked => _hasLiked;
  bool get hasDisliked => _hasDisliked;

  String get videoId => video.id ?? '';
  String get videoUrl => video.videoUrl ?? '';

  int get order => video.order ?? 0;

  VideoInfoWithUserInteraction copyWith({
    VideoWithMetadata? video,
    UserVideoReaction? userVideoReaction,
  }) =>
      VideoInfoWithUserInteraction(
        video: video ?? this.video,
        userVideoReaction: userVideoReaction ?? this.userVideoReaction,
      );
}
