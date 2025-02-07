import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/video/models/video_player_model.dart';
import 'package:stoyco_shared/video/models/video_reaction/user_video_reaction.dart';
import 'package:stoyco_shared/video/share_video_widget.dart';
import 'package:stoyco_shared/video/share_video_widget_v2.dart';
import 'package:stoyco_shared/video/video_with_metada/video_with_metadata.dart';

/// A widget that displays video interactions such as like, dislike, and share.
///
/// Example:
/// ```dart
/// VideoInteractionsWidgetV2(
///   video: videoModel,
///   totalScore: '100',
///   onLike: () {},
///   onDislike: () {},
///   onResultAction: () {},
///   loading: false,
/// )
/// ```
class VideoInteractionsWidgetV2 extends StatefulWidget {
  /// Creates a [VideoInteractionsWidgetV2].
  const VideoInteractionsWidgetV2({
    super.key,
    this.userVideoReaction,
    required this.video,
    required this.onLike,
    required this.onDislike,
    required this.onResultAction,
    required this.loading,
    // Customizable properties
    this.dividerColor = const Color(0xff142E43),
    this.likeIconWidth = 18.0,
    this.dislikeIconWidth = 18.0,
    this.animationDurationThreshold1 = 50,
    this.animationDurationThreshold2 = 100,
    this.animationDuration1 = const Duration(milliseconds: 300),
    this.animationDuration2 = const Duration(milliseconds: 500),
    this.animationDuration3 = const Duration(milliseconds: 1000),
    this.textColor = const Color(0xFFFAFAFA),
    this.loadingTextColor = Colors.grey,
    this.iconSplashColor = const Color(0xFF4639E7),
    this.iconBorderRadius = 4.0,
    this.iconPadding = 4.0,
    this.textFontSize = 12.0,
    this.spacing = 10.0,
    this.dividerHeight = 16.0,
  });

  /// Callback when the like button is pressed.
  final VoidCallback onLike;

  /// Callback when the dislike button is pressed.
  final VoidCallback onDislike;

  /// The video model being interacted with.
  final VideoWithMetadata video;

  /// Callback for result actions.
  final VoidCallback onResultAction;

  /// Indicates if the widget is in a loading state.
  final bool loading;

  /// The user's reaction to the video, either like or dislike.
  final UserVideoReaction? userVideoReaction;

  // Customizable properties
  final Color dividerColor;
  final double likeIconWidth;
  final double dislikeIconWidth;
  final int animationDurationThreshold1;
  final int animationDurationThreshold2;
  final Duration animationDuration1;
  final Duration animationDuration2;
  final Duration animationDuration3;
  final Color textColor;
  final Color loadingTextColor;
  final Color iconSplashColor;
  final double iconBorderRadius;
  final double iconPadding;
  final double textFontSize;
  final double spacing;
  final double dividerHeight;

  @override
  VideoInteractionsWidgetV2State createState() => VideoInteractionsWidgetV2State();
}

/// State for [VideoInteractionsWidgetV2].
class VideoInteractionsWidgetV2State extends State<VideoInteractionsWidgetV2> {
  bool isLiked = false;
  bool isDisliked = false;

  @override
  void initState() {
    super.initState();
    if (widget.userVideoReaction?.reactionType == 'Like') {
      isLiked = true;
    } else if (widget.userVideoReaction?.reactionType == 'Dislike') {
      isDisliked = true;
    }
  }

  @override
  void didUpdateWidget(VideoInteractionsWidgetV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userVideoReaction?.reactionType !=
        widget.userVideoReaction?.reactionType) {
      setState(() {
        isLiked = widget.userVideoReaction?.reactionType == 'Like';
        isDisliked = widget.userVideoReaction?.reactionType == 'Dislike';
      });
    }

    if (widget.userVideoReaction?.reactionType == null) {
      setState(() {
        isLiked = false;
        isDisliked = false;
      });
    }
  }

  /// Calculates the animation duration based on the score.
  ///
  /// [score]: The score to base the duration on.
  ///
  /// Returns a [Duration] object.
  Duration calculateDuration(int score) {
    if (score <= widget.animationDurationThreshold1) {
      return widget.animationDuration1;
    }
    if (score <= widget.animationDurationThreshold2) {
      return widget.animationDuration2;
    }
    return widget.animationDuration3;
  }

  /// Handles the like action.
  void handleLike() {
    if (widget.loading || isLiked) return;
    setState(() {
      if (!isLiked) {
        isLiked = true;
        isDisliked = false;
      }
    });
    widget.onLike();
  }

  /// Handles the dislike action.
  void handleDislike() {
    if (widget.loading || isDisliked) return;
    setState(() {
      if (!isDisliked) {
        isDisliked = true;
        isLiked = false;
      }
    });
    widget.onDislike();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Divider(
            color: widget.dividerColor,
            height: StoycoScreenSize.height(context, widget.dividerHeight),
          ),
          Row(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.loading ? null : handleLike,
                    child: Padding(
                      padding:
                          StoycoScreenSize.all(context, widget.iconPadding),
                      child: SvgPicture.asset(
                        !isLiked
                            ? 'packages/stoyco_shared/lib/assets/icons/reaction_arrow_up.svg'
                            : 'packages/stoyco_shared/lib/assets/icons/reaction_arrow_up_filled.svg',
                        width: StoycoScreenSize.width(
                          context,
                          widget.likeIconWidth,
                        ),
                        colorFilter: widget.loading
                            ? const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.srcIn,
                              )
                            : null,
                      ),
                    ),
                  ),
                  Gap(StoycoScreenSize.width(context, widget.spacing)),
                  Text(
                    '${widget.video.videoMetadata?.totalScore ?? 0}',
                    style: TextStyle(
                      color: widget.loading
                          ? widget.loadingTextColor
                          : widget.textColor,
                      fontWeight: FontWeight.w400,
                      fontSize: StoycoScreenSize.width(
                        context,
                        widget.textFontSize,
                      ),
                    ),
                  ),
                  Gap(StoycoScreenSize.width(context, widget.spacing)),
                  GestureDetector(
                    onTap: widget.loading ? null : handleDislike,
                    child: Padding(
                      padding:
                          StoycoScreenSize.all(context, widget.iconPadding),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationZ(3.14159),
                        child: SvgPicture.asset(
                          !isDisliked
                              ? 'packages/stoyco_shared/lib/assets/icons/reaction_arrow_up.svg'
                              : 'packages/stoyco_shared/lib/assets/icons/reaction_arrow_up_filled.svg',
                          width: StoycoScreenSize.width(
                            context,
                            widget.dislikeIconWidth,
                          ),
                          colorFilter: widget.loading
                              ? const ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.srcIn,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ShareVideoWidgetV2(
                video: widget.video,
                onResultAction: widget.onResultAction,
                loading: widget.loading,
              ),
            ],
          ),
        ],
      );
}
