import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:either_dart/either.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/utils/logger.dart';
import 'package:stoyco_shared/video/models/video_info_with_user_interaction.dart';

import 'package:stoyco_shared/video/video_with_interactions/parallax_video_card.dart';
import 'package:stoyco_shared/video/video_with_interactions/video_cache_service.dart';
import 'package:stoyco_shared/video/video_with_metada/video_with_metadata.dart';
import 'package:stoyco_shared/video/models/video_reaction/user_video_reaction.dart';
import 'package:stoyco_shared/errors/errors.dart';

/// Controller to interact with the VideoSlider
///
/// Allows external control of VideoSlider features such as muting/unmuting.

class VideoSliderController {
  _VideoSliderState? _state;

  /// Toggles mute state of the video slider
  ///
  /// When called, switches between muted and unmuted states
  void toggleMute() {
    _state?.toggleMute();
  }

  /// Gets the current mute state
  ///
  /// Returns `true` if videos are currently muted, `false` otherwise
  /// Returns `null` if the controller is not attached to a VideoSlider
  bool? getMuteState() => _state?.isMuted.value;

  /// Internal method to attach the state
  void _attachState(_VideoSliderState state) {
    _state = state;
  }

  /// Internal method to detach the state
  void _detachState() {
    _state = null;
  }
}

/// A widget that displays a carousel of videos with interactive features.
///
/// This widget provides a smooth video browsing experience with features like:
/// * Video preloading and caching for performance
/// * Thumbnail generation with loading placeholders
/// * Interactive controls (like, dislike, share)
/// * Auto-play for current visible video
/// * Mute/unmute controls with global state
/// * Optimistic UI updates for user interactions
/// * Automatic video disposal for memory management
///
/// Example usage:
/// ```dart
/// VideoSlider(
///   getVideosWithMetadata: () async {
///     // Fetch videos from repository or API
///     return Right([video1, video2, video3]);
///   },
///   getUserVideoInteractionData: ({required String videoId}) async {
///     // Fetch user's interaction with the video
///     return Right(UserVideoReaction(reactionType: 'Like'));
///   },
///   onLike: (video) {
///     // Handle like action
///   },
///   onDislike: (video) {
///     // Handle dislike action
///   },
///   controller: VideoSliderController(),
///   env: StoycoEnvironment.development,
/// )
/// ```
class VideoSlider extends StatefulWidget {
  /// Creates a VideoSlider widget.
  ///
  /// [getVideosWithMetadata] and [getUserVideoInteractionData] are required callbacks
  /// to fetch video data and user interaction data respectively.
  const VideoSlider({
    super.key,
    this.nextVideo,
    this.onPageChanged,
    this.onLike,
    this.onDislike,
    this.onShare,
    this.onMute,
    this.isMute,
    this.controller,
    this.initialMute = false,
    this.showInteractions = true,
    this.width,
    this.height,
    required this.getVideosWithMetadata,
    required this.getUserVideoInteractionData,
    required this.env,
  });

  /// Whether to show interaction buttons (like, dislike, share).
  final bool showInteractions;

  /// Callback triggered when the carousel page changes.
  final void Function(int index)? onPageChanged;

  /// Callback triggered when proceeding to next video.
  /// Provides current mute state and video data.
  final void Function(bool isMute, VideoWithMetadata video)? nextVideo;

  /// Callback triggered when a video is liked.
  final void Function(VideoWithMetadata video)? onLike;

  /// Callback triggered when a video is disliked.
  final void Function(VideoWithMetadata video)? onDislike;

  /// Callback triggered when a video is shared.
  final void Function(VideoWithMetadata video)? onShare;

  /// CallBack triggered mute/unmute video
  final void Function(bool isMuted)? onMute;

  /// Function to check if the video is muted.
  final bool Function()? isMute;

  /// Controller for the VideoSlider
  /// /// Example usage:
  /// ```dart
  /// final videoSliderController = VideoSliderController();
  ///
  /// // Create VideoSlider with controller
  /// VideoSlider(
  ///   controller: videoSliderController,
  ///   // other required parameters...
  /// )
  ///
  /// // Toggle mute state from outside the widget
  /// ElevatedButton(
  ///   onPressed: () => videoSliderController.toggleMute(),
  ///   child: Text('Toggle Mute'),
  /// )
  ///
  /// // Check current mute state
  /// final isMuted = videoSliderController.getMuteState() ?? false;
  /// ```
  final VideoSliderController? controller;

  /// Initial mute state for videos
  final bool initialMute;

  /// Callback to fetch the list of videos with their metadata.
  final Future<Either<Failure, List<VideoWithMetadata>>> Function()
      getVideosWithMetadata;

  /// Callback to fetch user's interaction data for a specific video.
  final Future<Either<Failure, UserVideoReaction>> Function({
    required String videoId,
  }) getUserVideoInteractionData;

  /// Optional width of the slider. If not provided, uses screen width.
  final double? width;

  /// Optional height of the slider. If not provided, uses screen width.
  final double? height;

  /// The current environment.
  final StoycoEnvironment env;

  @override
  State<VideoSlider> createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  List<VideoInfoWithUserInteraction> videosList = [];
  final ValueNotifier<Map<String, Image?>> videoThumbnails =
      ValueNotifier<Map<String, Image?>>({});
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  late ValueNotifier<bool> isMuted;
  final _videoCacheService = VideoCacheService();
  bool allVideosLoaded = false;
  final ValueNotifier<int> videoCount = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();
    isMuted = ValueNotifier<bool>(widget.initialMute);
    widget.controller?._attachState(this);
    widget.onMute?.call(isMuted.value);
    loadVideos();
  }

  //// Toggles the mute state of the video slider
  void toggleMute() {
    isMuted.value = !isMuted.value;
    widget.onMute?.call(isMuted.value);
  }

  /// Loads videos and their associated interaction data.
  ///
  /// 1. Fetches video list
  /// 2. For each video, fetches user interaction data
  /// 3. Generates thumbnails progressively
  /// 4. Updates UI state accordingly
  Future<void> loadVideos() async {
    isLoading.value = true;

    final videosResult = await widget.getVideosWithMetadata();

    await videosResult.fold(
      (failure) {
        isLoading.value = false;
      },
      (videos) async {
        videoCount.value = videos.length;
        videos.sort((a, b) {
          final orderA = a.order ?? 0;
          final orderB = b.order ?? 0;
          return orderA.compareTo(orderB);
        });

        bool isFirstVideoProcessed = false;

        for (final video in videos) {
          final interactionResult =
              await widget.getUserVideoInteractionData(videoId: video.id ?? '');

          videosList.add(
            VideoInfoWithUserInteraction(
              video: video,
              userVideoReaction: interactionResult.fold(
                (failure) => const UserVideoReaction(),
                (reaction) => reaction,
              ),
            ),
          );

          if (!isFirstVideoProcessed) {
            videoThumbnails.value = {};
            isLoading.value = false;
            isFirstVideoProcessed = true;

            // Initialize thumbnail for the first video immediately
            if (videosList.first.video.appUrl?.isNotEmpty == true) {
              final videoId = videosList.first.video.id;
              if (videoId != null) {
                final thumbnail =
                    await getVideoThumbnail(videosList.first.video.appUrl!);
                if (mounted) {
                  videoThumbnails.value = {
                    ...videoThumbnails.value,
                    videoId: thumbnail,
                  };
                }
              }
            }
          } else {
            // Update the list progressively
            if (mounted) {
              setState(() {});
            }
          }
        }

        // Initialize remaining thumbnails
        for (var i = 1; i < videosList.length; i++) {
          final videoUrl = videosList[i].video.appUrl ?? '';
          final videoId = videosList[i].video.id;
          if (videoUrl.isNotEmpty && videoId != null) {
            unawaited(
              getVideoThumbnail(videoUrl).then((value) {
                if (mounted) {
                  videoThumbnails.value = {
                    ...videoThumbnails.value,
                    videoId: value,
                  };
                  if (i == videosList.length - 1) {
                    allVideosLoaded = true;
                  }
                }
              }),
            );
          }
        }
      },
    );
  }

  /// Handles the like action for a video.
  ///
  /// Updates local state optimistically and triggers the onLike callback.
  void _handleLike(VideoWithMetadata video) {
    final videoIndex = videosList.indexWhere((v) => v.video.id == video.id);
    if (videoIndex != -1) {
      final currentVideo = videosList[videoIndex];
      final currentMetadata = currentVideo.video.videoMetadata;
      final wasDisliked = currentVideo.hasDisliked;

      final updatedMetadata = currentMetadata?.copyWith(
        likes: (currentMetadata.likes ?? 0) + (currentVideo.hasLiked ? -1 : 1),
        dislikes: wasDisliked
            ? (currentMetadata.dislikes ?? 0) - 1
            : (currentMetadata.dislikes ?? 0),
      );

      final updatedVideo = currentVideo.video.copyWith(
        videoMetadata: updatedMetadata,
      );

      setState(() {
        videosList[videoIndex] = currentVideo.copyWith(
          video: updatedVideo,
          userVideoReaction: UserVideoReaction(
            reactionType: currentVideo.hasLiked ? '' : 'Like',
          ),
        );
      });
    }
    widget.onLike?.call(video);
  }

  /// Handles the dislike action for a video.
  ///
  /// Updates local state optimistically and triggers the onDislike callback.
  void _handleDislike(VideoWithMetadata video) {
    final videoIndex = videosList.indexWhere((v) => v.video.id == video.id);
    if (videoIndex != -1) {
      final currentVideo = videosList[videoIndex];
      final currentMetadata = currentVideo.video.videoMetadata;
      final wasLiked = currentVideo.hasLiked;

      final updatedMetadata = currentMetadata?.copyWith(
        dislikes: (currentMetadata.dislikes ?? 0) +
            (currentVideo.hasDisliked ? -1 : 1),
        likes: wasLiked
            ? (currentMetadata.likes ?? 0) - 1
            : (currentMetadata.likes ?? 0),
      );

      final updatedVideo = currentVideo.video.copyWith(
        videoMetadata: updatedMetadata,
      );

      setState(() {
        videosList[videoIndex] = currentVideo.copyWith(
          video: updatedVideo,
          userVideoReaction: UserVideoReaction(
            reactionType: currentVideo.hasDisliked ? '' : 'Dislike',
          ),
        );
      });
    }
    widget.onDislike?.call(video);
  }

  /// Handles the share action for a video.
  ///
  /// Updates local share count and triggers the onShare callback.
  void _handleShare(VideoWithMetadata video) {
    final videoIndex = videosList.indexWhere((v) => v.video.id == video.id);
    if (videoIndex != -1) {
      final currentVideo = videosList[videoIndex];
      final currentMetadata = currentVideo.video.videoMetadata;

      final updatedMetadata = currentMetadata?.copyWith(
        shared: (currentMetadata.shared ?? 0) + 1,
      );

      final updatedVideo = currentVideo.video.copyWith(
        videoMetadata: updatedMetadata,
      );

      setState(() {
        videosList[videoIndex] = currentVideo.copyWith(
          video: updatedVideo,
        );
      });
    }
    widget.onShare?.call(video);
  }

  /// Handles carousel page changes.
  ///
  /// Manages video playback states:
  /// * Pauses non-adjacent videos
  /// * Preloads next video
  /// * Updates current index
  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    final previousIndex = currentIndex;
    widget.onPageChanged?.call(index);

    currentIndex.value = index;

    // Pause previous video if it's not adjacent to current
    if ((index - previousIndex.value).abs() > 1) {
      final videoUrl = videosList[previousIndex.value].video.videoUrl;
      if (videoUrl != null) {
        _videoCacheService.pauseController(videoUrl);
      }
    }

    // Preload next video
    if (index < videosList.length - 1) {
      final nextVideoUrl = videosList[index + 1].video.videoUrl;
      if (nextVideoUrl != null) {
        _videoCacheService.preloadNext(nextVideoUrl);
      }
    }
  }

  @override
  void dispose() {
    isLoading.dispose();
    currentIndex.dispose();
    videoCount.dispose();
    videoThumbnails.dispose();
    isMuted.dispose();
    widget.controller?._detachState();
    _videoCacheService.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sliderWidth = widget.width ?? StoycoScreenSize.screenWidth(context);
    final sliderHeight =
        widget.height ?? StoycoScreenSize.screenHeight(context);

    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, isLoadingValue, child) {
        if (isLoadingValue) {
          return SizedBox(
            width: sliderWidth,
            height: sliderHeight,
            child: Shimmer.fromColors(
              baseColor: const Color.fromARGB(255, 11, 18, 44),
              highlightColor: const Color.fromARGB(255, 20, 35, 88),
              child: LayoutBuilder(
                builder: (context, constraints2) {
                  final width = constraints2.maxWidth;
                  return SizedBox(
                    width: width,
                    height: width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ValueListenableBuilder<int>(
                valueListenable: currentIndex,
                builder: (context, currentIndexValue, child) => SizedBox(
                  width: sliderWidth,
                  height: sliderHeight,
                  child: CarouselSlider.builder(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        currentIndex.value = index;
                        _onPageChanged(index, reason);
                      },
                      enableInfiniteScroll:
                          allVideosLoaded && videosList.length > 1,
                    ),
                    itemCount: videosList.length,
                    itemBuilder: (context, index, realIndex) =>
                        ValueListenableBuilder<Map<String, Image?>>(
                      valueListenable: videoThumbnails,
                      builder: (context, thumbnails, child) =>
                          ValueListenableBuilder<bool>(
                        valueListenable: isMuted,
                        builder: (context, isMutedValue, child) =>
                            ParallaxVideoCard(
                          videoInfo: videosList[index],
                          thumbnail: videosList[index].video.id != null
                              ? thumbnails[videosList[index].video.id]
                              : null,
                          play: currentIndexValue == index,
                          showInteractions: widget.showInteractions,
                          onLike: () => _handleLike(videosList[index].video),
                          onDislike: () =>
                              _handleDislike(videosList[index].video),
                          onShare: widget.onShare != null
                              ? () => _handleShare(videosList[index].video)
                              : null,
                          nextVideo: () {
                            widget.nextVideo
                                ?.call(isMutedValue, videosList[index].video);
                            if (videosList.length > 1) {
                              _carouselController.nextPage();
                              if (currentIndexValue == videosList.length - 1) {
                                currentIndex.value = 0;
                              } else {
                                currentIndex.value++;
                              }
                            }
                          },
                          mute: (value) {
                            if (isMuted.value != value) {
                              isMuted.value = value;
                              widget.onMute?.call(value);
                            }
                          },
                          isMuted: isMutedValue,
                          isLooping: videosList.length == 1,
                          env: widget.env,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            buildPaginationIndicators(),
          ],
        );
      },
    );
  }

  Widget buildPaginationIndicators() => ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, currentIndexValue, child) => Container(
          height: StoycoScreenSize.height(
            context,
            21.32,
            phone: 18,
            tablet: 20,
            desktopLarge: 24,
          ),
          alignment: Alignment.center,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: videoCount.value,
            itemBuilder: (context, index) => AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              margin: StoycoScreenSize.symmetric(context, horizontal: 4),
              width: StoycoScreenSize.width(context, 8.0),
              height: StoycoScreenSize.height(context, 8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndexValue == index
                    ? StoycoColors.blue
                    : Colors.white,
              ),
            ),
          ),
        ),
      );

  /// Generates a thumbnail for a video URL.
  ///
  /// Returns null if thumbnail generation fails.
  Future<Image?> getVideoThumbnail(
    String url,
  ) async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: url,
        imageFormat: ImageFormat.JPEG,
      );
      return Image.memory(uint8list);
    } catch (e) {
      StoyCoLogger.error('Error getting video thumbnail: $e');
    }
    return null;
  }
}
