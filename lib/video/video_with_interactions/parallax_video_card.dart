import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/video/models/video_info_with_user_interaction.dart';
import 'package:stoyco_shared/video/video_with_interactions/video_cache_service.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// A video card widget that displays video content with interactive features and parallax effects.
///
/// This widget provides a rich video playback experience with:
/// * Video playback controls
/// * Like/Dislike interactions
/// * Share functionality
/// * Mute/Unmute toggle
/// * Progress indicator
/// * Video metadata display
class ParallaxVideoCard extends StatefulWidget {
  /// Creates a ParallaxVideoCard.
  ///
  /// * [videoInfo] - Contains video data and user interaction state
  /// * [play] - Controls if video should play automatically
  /// * [thumbnail] - Placeholder image shown while video loads
  /// * [nextVideo] - Callback to load the next video
  /// * [mute] - Callback to handle mute state changes
  /// * [isMuted] - Initial mute state
  /// * [isLooping] - Whether video should loop
  /// * [showInteractions] - Whether to show interaction buttons
  /// * [onLike] - Callback when like button is pressed
  /// * [onDislike] - Callback when dislike button is pressed
  /// * [onShare] - Callback when share button is pressed
  const ParallaxVideoCard({
    super.key,
    required this.videoInfo,
    this.play = false,
    required this.thumbnail,
    required this.nextVideo,
    required this.mute,
    this.isMuted = false,
    this.isLooping = false,
    this.showInteractions = true,
    this.onLike,
    this.onDislike,
    this.onShare,
  });

  final VideoInfoWithUserInteraction videoInfo;
  final bool play;
  final Image? thumbnail;
  final bool isMuted;
  final void Function() nextVideo;
  final void Function(bool value) mute;
  final bool isLooping;
  final bool showInteractions;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final VoidCallback? onShare;

  @override
  State<ParallaxVideoCard> createState() => _ParallaxVideoCardState();
}

class _ParallaxVideoCardState extends State<ParallaxVideoCard> {
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlayerInitialized = false;
  final _videoCacheService = VideoCacheService();
  double _currentTime = 0;
  bool isMuted = false;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    isMuted = widget.isMuted;
    _initializeVideoPlayerFuture = _initializeController();
  }

  /// Initializes the video controller and sets up initial playback state.
  ///
  /// This method:
  /// 1. Fetches the video controller from cache
  /// 2. Sets up video completion listener
  /// 3. Configures looping and volume settings
  Future<void> _initializeController() async {
    try {
      final videoUrl = widget.videoInfo.video.videoUrl ?? '';
      final controller = await _videoCacheService.getController(videoUrl);

      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isPlayerInitialized = true;
        _currentTime = 0;
      });

      _controller?.addListener(checkVideoCompletion);
      _controller?.setLooping(widget.isLooping);
      _controller?.setVolume(widget.isMuted ? 0 : 1);

      if (widget.play) {
        _controller?.play();
      }
    } catch (e) {
      debugPrint('Error initializing video controller: $e');
    }
  }

  /// Monitors video playback completion and updates progress.
  ///
  /// When video completes:
  /// * Pauses the video
  /// * Triggers the next video callback
  /// * Updates the progress indicator
  void checkVideoCompletion() {
    if (_controller == null || !mounted || isDisposed) return;

    if (_controller!.value.isCompleted && !isDisposed) {
      _controller?.pause();
      // Schedule the next video call for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !isDisposed) {
          widget.nextVideo();
        }
      });
    }

    // Schedule state update for the next frame
    if (mounted && !isDisposed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !isDisposed) {
          setState(() {
            _currentTime = _controller!.value.position.inMilliseconds /
                max(_controller!.value.duration.inMilliseconds, 1);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.removeListener(checkVideoCompletion);
    }
    isDisposed = true;
    super.dispose();
  }

  /// Handles the mute/unmute toggle functionality.
  ///
  /// Updates both local state and parent widget's mute state.
  void toggleMute() {
    if (_controller == null) return;

    setState(() {
      isMuted = !isMuted;
    });
    _controller?.setVolume(isMuted ? 0 : 1);
    widget.mute(isMuted);
  }

  /// Handles the share functionality for the video.
  ///
  /// This method:
  /// 1. Pauses the video
  /// 2. Shares the video information
  /// 3. Resumes playback if needed
  /// 4. Handles any errors during sharing
  Future<void> _handleShare() async {
    try {
      // Pause video before sharing
      unawaited(_controller?.pause());

      final video = widget.videoInfo.video;
      final String text = '''Mira este video: ${video.name}
${video.description}

Ver video: ${video.videoUrl}''';

      await Share.share(subject: 'Mira este video en Stoyco', text);
      // Resume video playback if it was playing before
      if (widget.play) {
        unawaited(_controller?.play());
      }

      if (widget.onShare != null) {
        widget.onShare!();
      }
    } catch (e) {
      // Resume video playback even if sharing fails
      if (widget.play) {
        unawaited(_controller?.play());
      }
      debugPrint('Error sharing video: $e');
    }
  }

  /// Updates video playback state when widget properties change.
  ///
  /// Manages play/pause state transitions based on [widget.play] changes.
  @override
  void didUpdateWidget(ParallaxVideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller == null || isDisposed) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !isDisposed) {
        if (widget.play && !oldWidget.play) {
          _controller?.play();
        } else if (!widget.play && oldWidget.play) {
          _controller?.pause();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth;
          return SizedBox(
            width: size,
            height: size,
            child: VisibilityDetector(
              key: Key('video-card-${widget.videoInfo.videoUrl}'),
              onVisibilityChanged: (visibilityInfo) {
                if (_controller == null) return;

                final double visiblePercentage =
                    visibilityInfo.visibleFraction * 100;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !isDisposed) {
                    if (visiblePercentage == 0) {
                      _controller?.pause();
                    } else if (widget.play) {
                      _controller?.play();
                    }
                  }
                });
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 6),
                      blurRadius: 8,
                    ),
                  ],
                  image: widget.thumbnail != null
                      ? DecorationImage(
                          image: widget.thumbnail!.image,
                          fit: BoxFit.cover,
                          opacity: 0.3,
                        )
                      : null,
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              _isPlayerInitialized &&
                              _controller != null) {
                            return VideoPlayer(_controller!);
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF4f1fe6),
                              backgroundColor: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Stack(
                        children: [
                          Transform.scale(
                            scale: 0.7,
                            child: CircularProgressIndicator(
                              value: _currentTime,
                              backgroundColor: Colors.white,
                              color: const Color(0xFF4f1fe6),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                _controller?.value.isInitialized == true
                                    ? (_controller!.value.duration.inSeconds -
                                            _controller!
                                                .value.position.inSeconds)
                                        .toString()
                                    : '0',
                                textScaler: TextScaler.noScaling,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      StoycoScreenSize.fontSize(context, 12),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 20,
                      right: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.videoInfo.video.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: StoycoScreenSize.fontSize(context, 16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.videoInfo.video.description ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: StoycoScreenSize.fontSize(context, 14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      bottom: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: toggleMute,
                            child: Icon(
                              isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (widget.showInteractions) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: widget.onLike,
                                      child: SvgPicture.asset(
                                        !widget.videoInfo.hasLiked
                                            ? 'packages/stoyco_shared/lib/assets/icons/reaction_arrow_up.svg'
                                            : 'packages/stoyco_shared/lib/assets/icons/reaction_arrow_up_filled.svg',
                                        width:
                                            StoycoScreenSize.width(context, 20),
                                      ),
                                    ),
                                    Gap(StoycoScreenSize.width(context, 8.05)),
                                    Text(
                                      '${widget.videoInfo.video.videoMetadata?.likes ?? 0}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: StoycoScreenSize.fontSize(
                                          context,
                                          14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(StoycoScreenSize.width(context, 10)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: widget.onDislike,
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationZ(3.14159),
                                        child: SvgPicture.asset(
                                          !widget.videoInfo.hasDisliked
                                              ? 'packages/stoyco_shared/lib/assets/icons/reaction_arrow_up.svg'
                                              : 'packages/stoyco_shared/lib/assets/icons/reaction_arrow_up_filled.svg',
                                          width: StoycoScreenSize.width(
                                            context,
                                            20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gap(StoycoScreenSize.width(context, 8.05)),
                                    Text(
                                      '${widget.videoInfo.video.videoMetadata?.dislikes ?? 0}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: StoycoScreenSize.fontSize(
                                          context,
                                          14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(StoycoScreenSize.width(context, 10)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: _handleShare,
                                      child: SvgPicture.asset(
                                        'packages/stoyco_shared/lib/assets/icons/share_outlined_icon.svg',
                                        width:
                                            StoycoScreenSize.width(context, 20),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Gap(StoycoScreenSize.width(context, 8.05)),
                                    Text(
                                      '${widget.videoInfo.video.videoMetadata?.shared ?? 0}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: StoycoScreenSize.fontSize(
                                          context,
                                          14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
