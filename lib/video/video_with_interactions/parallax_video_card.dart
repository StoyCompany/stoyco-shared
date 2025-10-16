import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/utils/logger.dart';
import 'package:stoyco_shared/video/models/video_info_with_user_interaction.dart';
import 'package:stoyco_shared/video/video_with_interactions/dowload_and_save_file.dart';
import 'package:stoyco_shared/video/video_with_interactions/video_cache_service.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:path_provider/path_provider.dart';

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
  /// * [logoWidth] - Width of the watermark logo (default: 100)
  /// * [logoHeight] - Height of the watermark logo (default: 150)
  /// * [overlayX] - X position offset of the watermark from right edge (default: 30)
  /// * [overlayY] - Y position offset of the watermark from bottom edge (default: 30)
  /// * [shareText] - Custom text to add when sharing (default: video name and URL)
  /// * [env] - StoycoEnvironment for environment-specific configurations
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
    this.logoWidth,
    this.logoHeight,
    this.overlayX,
    this.overlayY,
    this.shareText,
    required this.env,
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
  final int? logoWidth;
  final int? logoHeight;
  final int? overlayX;
  final int? overlayY;
  final String? shareText;
  final StoycoEnvironment env;

  @override
  State<ParallaxVideoCard> createState() => _ParallaxVideoCardState();
}

class _ParallaxVideoCardState extends State<ParallaxVideoCard> {
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlayerInitialized = false;
  final _videoCacheService = VideoCacheService();
  final ValueNotifier<bool> _isSharing = ValueNotifier(false);
  final ValueNotifier<bool> isMuted = ValueNotifier(false);
  double _currentTime = 0;
  bool isDisposed = false;
  String? _cachedGifPath; // New variable for caching GIF path
  Offset? _lastSharePosition;

  /// Gets the video base URL based on the current environment
  String _getVideoBaseUrl() => widget.env.videoBaseUrl;

  @override
  void initState() {
    super.initState();
    isMuted.value = widget.isMuted;
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
      final videoUrl = (widget.videoInfo.video.appUrl ?? '');
      final controller = await _videoCacheService.getController(videoUrl);

      if (!mounted) return;

      setState(() {
        _controller = controller;
        _currentTime = 0;
        _isPlayerInitialized = true;
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
            _currentTime =
                _controller!.value.position.inMilliseconds /
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

    final newMuteState = !isMuted.value;
    isMuted.value = newMuteState;
    _controller?.setVolume(newMuteState ? 0 : 1);
    widget.mute(newMuteState);
  }

  Future<String> _loadGifFromAssets() async {
    if (_cachedGifPath != null) return _cachedGifPath!;
    final byteData = await rootBundle.load(
      'packages/stoyco_shared/lib/assets/gifs/stoyco_icon_animated.gif',
    );
    final tempDir = await getTemporaryDirectory();
    final logoFile = File('${tempDir.path}/stoyco_icon_animated.gif');
    await logoFile.writeAsBytes(byteData.buffer.asUint8List());
    _cachedGifPath = logoFile.path;
    return _cachedGifPath!;
  }

  /// Downloads a video file in an isolate to avoid blocking the main thread.
  Future<File> _downloadFileInIsolate(String videoUrl, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/$fileName';

    final filePath = await compute(
      downloadAndSaveFile,
      DownloadFileParams(videoUrl: videoUrl, filePath: tempFilePath),
    );

    return File(filePath);
  }

  Future<void> _handleShare() async {
    final video = widget.videoInfo.video;
    final videoUrl = (widget.videoInfo.video.appUrl ?? '');
    final shareText =
        widget.shareText ?? '''${video.name} Ver video: $videoUrl''';

    File? tempFile;

    try {
      _isSharing.value = true;

      if (videoUrl.isNotEmpty) {
        final fileName =
            '${video.name?.replaceAll(' ', '_') ?? 'video${video.id}'}.mp4';
        tempFile = await _downloadFileInIsolate(videoUrl, fileName);

        await _controller?.pause();

        // Provide a non-zero sharePositionOrigin for iPad/iOS popover.
        // iOS requires a rect with non-zero width and height within the source view's coordinate space.
        // Use 44x44 (iOS minimum tap target size) to ensure proper popover placement.
        Rect sharePositionOrigin;
        try {
          if (_lastSharePosition != null &&
              _lastSharePosition!.dx > 0 &&
              _lastSharePosition!.dy > 0) {
            // Use the captured tap position if valid, with 44x44 size
            // Adjust to center the rect on the tap position
            sharePositionOrigin = Rect.fromLTWH(
              _lastSharePosition!.dx - 22,
              _lastSharePosition!.dy - 22,
              44,
              44,
            );
            StoyCoLogger.info(
              'Using tap position for share: $sharePositionOrigin',
            );
          } else {
            // Fallback: Use a safe position in the middle-right of the screen
            // where the share button typically appears
            final mq = MediaQuery.maybeOf(context);
            final screenWidth = mq?.size.width ?? 440;
            final screenHeight = mq?.size.height ?? 956;
            // Position in the right side, middle-bottom area where share icon is
            sharePositionOrigin = Rect.fromLTWH(
              screenWidth - 72,
              screenHeight * 0.7 - 22,
              44,
              44,
            );
            StoyCoLogger.info(
              'Using fallback position for share: $sharePositionOrigin',
            );
          }
        } catch (e) {
          // Ultimate fallback: hardcoded safe position with proper size
          sharePositionOrigin = const Rect.fromLTWH(368, 648, 44, 44);
          StoyCoLogger.error(
            'Error computing sharePositionOrigin, using hardcoded fallback: $e',
          );
        }

        await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: shareText,
          sharePositionOrigin: sharePositionOrigin,
        );

        if (widget.onShare != null) {
          widget.onShare!();
        }
      }
    } catch (e) {
      StoyCoLogger.error('Error sharing video: $e');
    } finally {
      if (widget.play) {
        await _controller?.play();
      }
      await _deleteTempFile(tempFile);
      if (mounted && !isDisposed) {
        _isSharing.value = false;
      }
    }
  }

  /// Deletes the temporary file if it exists.
  Future<void> _deleteTempFile(File? tempFile) async {
    try {
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (e) {
      StoyCoLogger.error('Error deleting temporary file: $e');
    }
  }

  /// Updates video playback state when widget properties change.
  ///
  /// Manages play/pause state transitions based on [widget.play] changes.
  @override
  void didUpdateWidget(ParallaxVideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller == null || isDisposed) return;

    // Update mute state without rebuilding if it changed from parent
    if (widget.isMuted != oldWidget.isMuted &&
        widget.isMuted != isMuted.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !isDisposed) {
          isMuted.value = widget.isMuted;
          _controller?.setVolume(widget.isMuted ? 0 : 1);
        }
      });
    }

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
                      if (snapshot.connectionState == ConnectionState.done &&
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
                                _controller!.value.position.inSeconds)
                                .toString()
                                : '0',
                            textScaler: TextScaler.noScaling,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: StoycoScreenSize.fontSize(context, 12),
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
                      ValueListenableBuilder<bool>(
                        valueListenable: isMuted,
                        builder: (context, value, child) => GestureDetector(
                          onTap: toggleMute,
                          child: Icon(
                            value ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                            size: 24,
                          ),
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
                                    width: StoycoScreenSize.width(context, 20),
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
                                GestureDetector(
                                  onTapDown: (details) {
                                    _lastSharePosition = details.globalPosition;
                                  },
                                  child: InkWell(
                                    onTap: _isSharing.value
                                        ? null
                                        : _handleShare,
                                    child: ValueListenableBuilder<bool>(
                                      valueListenable: _isSharing,
                                      builder: (context, isSharing, child) =>
                                      isSharing
                                          ? SizedBox(
                                        width: StoycoScreenSize.width(
                                          context,
                                          20,
                                        ),
                                        height: StoycoScreenSize.width(
                                          context,
                                          20,
                                        ),
                                        child:
                                        const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                          : SvgPicture.asset(
                                        'packages/stoyco_shared/lib/assets/icons/share_outlined_icon.svg',
                                        width: StoycoScreenSize.width(
                                          context,
                                          20,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
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
