import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/utils/logger.dart';
import 'package:stoyco_shared/video/models/video_info_with_user_interaction.dart';
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
  double _currentTime = 0;
  bool isMuted = false;
  bool isDisposed = false;
  bool _isSharing = false; // Add this variable to track sharing state
  String? _cachedGifPath; // New variable for caching GIF path

  /// Gets the video base URL based on the current environment
  String _getVideoBaseUrl() => widget.env.videoBaseUrl;

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
      final videoUrl = (widget.videoInfo.video.appUrl ?? '');
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

  Future<String> _loadGifFromAssets() async {
    if (_cachedGifPath != null) return _cachedGifPath!;
    final byteData = await rootBundle.load(
        'packages/stoyco_shared/lib/assets/gifs/stoyco_icon_animated.gif');
    final tempDir = await getTemporaryDirectory();
    final logoFile = File('${tempDir.path}/stoyco_icon_animated.gif');
    await logoFile.writeAsBytes(byteData.buffer.asUint8List());
    _cachedGifPath = logoFile.path;
    return _cachedGifPath!;
  }

  Future<void> _handleShare() async {
    File? tempFile;
    File? originalFile;

    // Configuration variables for the logo with fallback values
    final int logoWidth = widget.logoWidth ?? 100;
    final int logoHeight = widget.logoHeight ?? 150;
    final int overlayXOffset = widget.overlayX ?? 30;
    final int overlayYOffset = widget.overlayY ?? 30;

    // Build the position strings for FFmpeg overlay filter
    final String overlayX = 'main_w-overlay_w-$overlayXOffset';
    final String overlayY = 'main_h-overlay_h-$overlayYOffset';

    // Build the FFmpeg filter using the variables
    final String filterComplex =
        '[1:v]scale=$logoWidth:$logoHeight[logo];[0:v][logo]overlay=$overlayX:$overlayY:shortest=1';

    // Text to share
    final video = widget.videoInfo.video;
    final videoUrl = (widget.videoInfo.video.appUrl ?? '');
    final shareText = widget.shareText ??
        '''${video.name}
Watch video: $videoUrl''';

    try {
      setState(() {
        _isSharing = true;
      });

      if (videoUrl != videoUrl) {
        // Load animated GIF from assets and obtain the path
        final gifPath = await _loadGifFromAssets();

        final outputPath =
            '${(await getTemporaryDirectory()).path}/${video.name?.replaceAll(' ', '_') ?? 'video${video.id}'}_with_watermark.mp4';
        debugPrint('Output path: $outputPath');
        tempFile = File(outputPath);

        // Local function that executes a command and shares the video if successful
        Future<bool> tryExecuteCommand(String command) async {
          final session = await FFmpegKit.execute(command);
          final returnCode = await session.getReturnCode();
          if (ReturnCode.isSuccess(returnCode) && await tempFile!.exists()) {
            await _controller?.pause();
            await Share.shareXFiles([XFile(tempFile!.path)], text: shareText);
            return true;
          }
          return false;
        }

        // First attempt: using h264_mediacodec
        final command1 =
            '-i $videoUrl -stream_loop -1 -i $gifPath -filter_complex "$filterComplex" -c:v h264_mediacodec -c:a copy $outputPath';
        if (!(await tryExecuteCommand(command1))) {
          // Second attempt: using mpeg4 codec
          final command2 =
              '-i $videoUrl -stream_loop -1 -i $gifPath -filter_complex "$filterComplex" -c:v mpeg4 -q:v 3 -c:a copy $outputPath';
          if (!(await tryExecuteCommand(command2))) {
            // Third attempt: share original video without watermark
            final tempOrigPath =
                '${(await getTemporaryDirectory()).path}/original_${video.name?.replaceAll(' ', '_') ?? 'video${video.id}'}.mp4';
            originalFile = File(tempOrigPath);
            final result =
                await FFmpegKit.execute('-i $videoUrl -c copy $tempOrigPath');
            final origReturnCode = await result.getReturnCode();
            if (ReturnCode.isSuccess(origReturnCode) &&
                await originalFile.exists()) {
              await Share.shareXFiles([XFile(originalFile.path)],
                  text: shareText);
            }
          }
        }
      }

      if (widget.play) {
        await _controller?.play();
      }
      if (widget.onShare != null) {
        widget.onShare!();
      }
    } catch (e) {
      if (widget.play) {
        await _controller?.play();
      }
      debugPrint('Error sharing video: $e');
    } finally {
      try {
        if (tempFile != null && await tempFile.exists()) {
          await tempFile.delete();
        }
        if (originalFile != null && await originalFile.exists()) {
          await originalFile.delete();
        }
      } catch (e) {
        StoyCoLogger.error('Error deleting temporary files: $e');
      }
      if (mounted && !isDisposed) {
        setState(() {
          _isSharing = false;
        });
      }
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
                                      onTap: _isSharing ? null : _handleShare,
                                      child: _isSharing
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
