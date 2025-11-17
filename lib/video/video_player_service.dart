import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:stoyco_shared/coach_mark/errors/exception.dart';

import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/utils/utils.dart';
import 'package:stoyco_shared/video/models/video_interaction/video_interaction.dart';
import 'package:stoyco_shared/video/models/video_reaction/user_video_reaction.dart';
import 'package:stoyco_shared/video/models/video_player_model.dart';
import 'dart:collection';

import 'package:stoyco_shared/video/cache/video_cache_manager.dart';
import 'package:stoyco_shared/video/video_player_ds_impl_v2.dart';
import 'package:stoyco_shared/video/video_player_repository_v2.dart';
import 'package:stoyco_shared/video/video_with_metada/video_with_metadata.dart';

/// Service responsible for managing video playback and reactions.
///
/// This service includes intelligent caching with persistent storage to prevent
/// redundant backend calls when users switch between tabs or filter modes.
/// Videos are automatically deduplicated to prevent duplicates when content shifts between pages.
/// Cache persists across app sessions using Hive.
///
/// Example:
/// ```dart
/// // Initialize cache manager first (one time, at app startup)
/// await VideoCacheManager.initialize(ttl: 300);
///
/// // Create service with caching enabled
/// var videoService = VideoPlayerService(
///   environment: StoycoEnvironment.development,
///   userToken: 'user_token',
///   videoCacheTTL: 300, // 5 minutes
/// );
///
/// // Fetch videos - automatically cached to disk
/// var videos = await videoService.getVideosWithFilter(
///   filterMode: 'Featured',
///   page: 1,
///   pageSize: 20,
/// );
///
/// // Clear cache on user refresh
/// await videoService.clearVideoCache();
/// ```
class VideoPlayerService {
  /// Private constructor for [VideoPlayerService].
  ///
  /// [environment] The environment configuration.
  /// [userToken] The user token.
  /// [functionToUpdateToken] Function to update the user token.
  /// [videoCacheTTL] Time to live for video cache in seconds (default: 300 = 5 minutes).
  VideoPlayerService._({
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
    this.videoCacheTTL = 300,
  }) {
    _dataSource = VideoPlayerDataSourceV2(environment);
    _repository = VideoPlayerRepositoryV2(_dataSource!, userToken);
    _repository!.token = userToken;
    _dataSource!.updateUserToken(userToken);
    _cacheManager = VideoCacheManager.instance;
  }

  /// Factory constructor for [VideoPlayerService].
  ///
  /// [environment] The environment configuration.
  /// [userToken] The user token.
  /// [functionToUpdateToken] Function to update the user token.
  /// [videoCacheTTL] Time to live for video cache in seconds (default: 300 = 5 minutes).
  ///
  /// Example:
  /// ```dart
  /// var videoService = VideoPlayerService(userToken: 'abc123', videoCacheTTL: 600);
  /// ```
  factory VideoPlayerService({
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?>? functionToUpdateToken,
    int videoCacheTTL = 300,
  }) {
    _instance = VideoPlayerService._(
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
      videoCacheTTL: videoCacheTTL,
    );

    return _instance!;
  }

  /// Function to update the user token.
  Future<String?>? functionToUpdateToken;

  /// Sets the function to update the user token.
  ///
  /// [function] The function to set.
  void setFunctionToUpdateToken(Future<String?> function) {
    functionToUpdateToken = function;
    userToken = '';
  }

  /// The environment configuration used for initializing data sources and repositories.
  StoycoEnvironment environment;

  /// Repository responsible for handling video operations.
  VideoPlayerRepositoryV2? _repository;

  /// Data source used to fetch raw video data.
  VideoPlayerDataSourceV2? _dataSource;

  static VideoPlayerService? _instance;

  /// Singleton instance of [VideoPlayerService].
  static VideoPlayerService? get instance => _instance;

  /// Cache for storing [UserVideoReaction] with timestamps.
  final Map<String, _CachedVideoInteraction> _reactionCache = HashMap();

  /// Time to live for video cache in seconds.
  final int videoCacheTTL;

  /// Persistent cache manager instance (optional, provides disk-based caching).
  VideoCacheManager? _cacheManager;

  /// Tracks active prefetch operations to avoid duplicate prefetching.
  final Set<String> _activePrefetches = {};

  /// Enable/disable automatic prefetching of next page (default: true).
  bool enablePrefetching = true;

  /// The token of the user.
  String userToken = '';

  /// Initializes the persistent cache manager.
  ///
  /// Call this method once at app startup before using video services.
  /// If not called, the service will work without persistent caching.
  ///
  /// [ttl] Cache time to live in seconds (default: 300 = 5 minutes).
  /// [maxCacheSize] Maximum number of cache entries (default: 100).
  /// [cachePath] Optional custom path for Hive storage.
  ///
  /// Example:
  /// ```dart
  /// await VideoPlayerService.initializeCache(ttl: 600);
  /// ```
  static Future<void> initializeCache({
    int ttl = 300,
    int maxCacheSize = 100,
    String? cachePath,
  }) async {
    await VideoCacheManager.initialize(
      ttl: ttl,
      maxCacheSize: maxCacheSize,
      cachePath: cachePath,
    );
  }

  /// Sets the user token and updates the repository and data source.
  ///
  /// [token] The new user token.
  set token(String token) {
    userToken = token;
    _repository!.token = token;
    _dataSource!.updateUserToken(token);
  }

  /// Verifies the user token and updates it if necessary.
  ///
  /// Throws an exception if token update fails.
  Future<void> verifyToken() async {
    if (userToken.isEmpty) {
      if (functionToUpdateToken == null) {
        throw FunctionToUpdateTokenNotSetException();
      }

      final String? newToken = await functionToUpdateToken!;

      if (newToken != null && newToken.isNotEmpty) {
        userToken = newToken;
        _repository!.token = newToken;
      } else {
        throw EmptyUserTokenException('Failed to update token');
      }
    }
  }

  /// Retrieves a list of videos.
  ///
  /// Returns an [Either] containing a [Failure] or a list of [VideoPlayerModel].
  ///
  /// Example:
  /// ```dart
  /// var videos = await videoService.getVideos();
  /// ```
  Future<Either<Failure, List<VideoPlayerModel>>> getVideos() async =>
      await _repository!.getVideos();

  /// Retrieves video reactions by video ID, with an option to force update.
  ///
  /// [videoId] The ID of the video.
  /// [force] Whether to force update the reactions.
  ///
  /// Returns an [Either] containing a [Failure] or a [VideoInteraction].
  Future<Either<Failure, VideoInteraction>> getVideoReactionsById(
    String videoId, {
    bool force = false,
  }) async {
    try {
      await verifyToken();

      final cached = _reactionCache[videoId];
      final now = DateTime.now();

      if (!force &&
          cached != null &&
          now.difference(cached.timestamp).inSeconds < 30) {
        return Right(cached.reaction);
      }

      final result = await _repository!.getVideoReactionsById(videoId);
      result.fold(
        (_) {},
        (reaction) {
          _reactionCache[videoId] = _CachedVideoInteraction(reaction, now);
        },
      );
      return result;
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Likes a video.
  ///
  /// [videoId] The ID of the video to like.
  ///
  /// Returns an [Either] containing a [Failure] or a [VideoInteraction].
  Future<Either<Failure, VideoInteraction>> likeVideo({
    required String videoId,
    required String userId,
  }) async {
    try {
      await verifyToken();
      final result = await _repository!.likeVideo(
        videoId,
        userId,
      );
      final reaction = await _handleReaction(result);

      // Invalidate video cache (don't await - fire and forget)
      // Next fetch will get fresh data from backend
      // ignore: unawaited_futures
      reaction.fold(
        (failure) => null,
        (videoInteraction) => invalidateVideoCacheForVideo(videoId),
      );

      return reaction;
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Dislikes a video.
  ///
  /// [videoId] The ID of the video to dislike.
  ///
  /// Returns an [Either] containing a [Failure] or a [VideoInteraction].
  Future<Either<Failure, VideoInteraction>> dislikeVideo({
    required String videoId,
    required String userId,
  }) async {
    try {
      await verifyToken();
      final result = await _repository!.dislikeVideo(
        videoId,
        userId,
      );
      final reaction = await _handleReaction(result);

      // Invalidate video cache (don't await - fire and forget)
      // Next fetch will get fresh data from backend
      // ignore: unawaited_futures
      reaction.fold(
        (failure) => null,
        (videoInteraction) => invalidateVideoCacheForVideo(videoId),
      );

      return reaction;
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Handles the reaction after liking or disliking a video.
  ///
  /// [result] The result of the like or dislike operation.
  ///
  /// Returns an [Either] containing a [Failure] or a [VideoInteraction].
  Future<Either<Failure, VideoInteraction>> _handleReaction(
    Either<Failure, UserVideoReaction> result,
  ) async =>
      result.fold(
        (left) => Left(left),
        (reaction) => getVideoReactionsById(
          reaction.videoId!,
          force: true,
        ),
      );

  /// Shares a video.
  ///
  /// [videoId] The ID of the video to share.
  ///
  /// Returns an [Either] containing a [Failure] or a boolean indicating success.
  Future<Either<Failure, bool>> shareVideo({
    required String videoId,
    bool isWeb = false,
  }) async {
    try {
      await verifyToken();
      final result = await _repository!.shareVideo(
        videoId,
        !isWeb ? getPlatform() : 'web',
      );

      // Invalidate video cache (don't await - fire and forget)
      // Next fetch will get fresh data from backend
      result.fold(
        (failure) => null,
        (success) {
          if (success) {
            invalidateVideoCacheForVideo(videoId);
          }
        },
      );

      return result;
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Views a video.
  ///
  /// [videoId] The ID of the video to view.
  ///
  /// Returns an [Either] containing a [Failure] or a boolean indicating success.
  Future<Either<Failure, bool>> viewVideo({
    required String videoId,
  }) async {
    try {
      return await _repository!.viewVideo(
        videoId,
      );
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Retrieves user video interaction data.
  ///
  /// [videoId] The ID of the video.
  ///
  /// Returns an [Either] containing a [Failure] or a [UserVideoReaction].
  Future<Either<Failure, UserVideoReaction>> getUserVideoInteractionData({
    required String videoId,
  }) async {
    try {
      await verifyToken();
      return await _repository!.getUserVideoInteractionData(videoId);
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Retrieves a list of videos with metadata.
  ///
  /// Returns an [Either] containing a [Failure] or a list of [VideoWithMetadata].
  Future<Either<Failure, List<VideoWithMetadata>>>
      getVideosWithMetadata() async {
    try {
      return await _repository!.getVideosWithMetadata();
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Retrieves videos with filter mode, pagination, and optional userId
  ///
  /// [filterMode] The filter mode (e.g., 'Featured', 'ForYou')
  /// [page] The page number (default: 1)
  /// [pageSize] The number of items per page (default: 20)
  /// [userId] Optional user ID for personalized content
  /// [partnerProfile] Optional partner profile filter (Music, Sport, Brand)
  /// [partnerId] Optional partner ID to filter videos by specific partner
  /// [forceRefresh] Force refresh cache (default: false)
  ///
  /// Returns an [Either] containing a [Failure] or a list of [VideoWithMetadata].
  /// Results are cached to disk and memory to avoid repeated calls when switching between tabs.
  /// Videos are deduplicated by ID to prevent duplicates if content shifts between pages.
  Future<Either<Failure, List<VideoWithMetadata>>> getVideosWithFilter({
    required String filterMode,
    int page = 1,
    int pageSize = 20,
    String? userId,
    String? partnerProfile,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = _buildVideoCacheKey(
        filterMode: filterMode,
        page: page,
        pageSize: pageSize,
        userId: userId,
        partnerProfile: partnerProfile,
        partnerId: partnerId,
      );

      // Check cache first (if cache manager is initialized)
      if (!forceRefresh && _cacheManager != null) {
        final cached = await _cacheManager!.get(cacheKey);
        if (cached != null && cached.isNotEmpty) {
          // Prefetch next page in background if enabled
          if (enablePrefetching) {
            _prefetchNextPage(
              filterMode: filterMode,
              currentPage: page,
              pageSize: pageSize,
              userId: userId,
              partnerProfile: partnerProfile,
              partnerId: partnerId,
            );
          }
          return Right(cached);
        }
      }

      // Fetch from repository
      final result = await _repository!.getVideosWithFilter(
        filterMode: filterMode,
        page: page,
        pageSize: pageSize,
        userId: userId,
        partnerProfile: partnerProfile,
        partnerId: partnerId,
      );

      // Cache successful results with deduplication (if cache manager is initialized)
      await result.fold(
        (_) async {},
        (videos) async {
          if (_cacheManager != null) {
            await _cacheManager!.put(cacheKey, videos);

            // Prefetch next page after successful fetch if enabled and has results
            if (enablePrefetching && videos.isNotEmpty) {
              _prefetchNextPage(
                filterMode: filterMode,
                currentPage: page,
                pageSize: pageSize,
                userId: userId,
                partnerProfile: partnerProfile,
                partnerId: partnerId,
              );
            }
          }
        },
      );

      return result;
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Retrieves featured / explore videos.
  ///
  /// [userId] Optional user id to personalize results.
  /// [pageSize] Number of items to fetch (default: 10).
  /// [page] Page number for pagination (default: 1).
  /// [partnerProfile] Optional partner profile filter (Music, Sport, Brand).
  /// [partnerId] Optional partner ID to filter videos by specific partner.
  /// [forceRefresh] Force refresh cache (default: false).
  ///
  /// Results are cached to disk and memory to avoid repeated calls when switching between tabs.
  /// Videos are deduplicated by ID to prevent duplicates if content shifts between pages.
  Future<Either<Failure, List<VideoWithMetadata>>> getFeaturedVideos({
    String? userId,
    int pageSize = 10,
    int page = 1,
    String? partnerProfile,
    String? partnerId,
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = _buildVideoCacheKey(
        filterMode: 'Featured',
        page: page,
        pageSize: pageSize,
        userId: userId,
        partnerProfile: partnerProfile,
        partnerId: partnerId,
      );

      // Check cache first (if cache manager is initialized)
      if (!forceRefresh && _cacheManager != null) {
        final cached = await _cacheManager!.get(cacheKey);
        if (cached != null && cached.isNotEmpty) {
          // Prefetch next page in background if enabled
          if (enablePrefetching) {
            _prefetchNextPage(
              filterMode: 'Featured',
              currentPage: page,
              pageSize: pageSize,
              userId: userId,
              partnerProfile: partnerProfile,
              partnerId: partnerId,
            );
          }
          return Right(cached);
        }
      }

      // Fetch from repository
      final result = await _repository!.getFeaturedVideos(
        userId: userId,
        pageSize: pageSize,
        page: page,
        partnerProfile: partnerProfile,
        partnerId: partnerId,
      );

      // Cache successful results with deduplication (if cache manager is initialized)
      await result.fold(
        (_) async {},
        (videos) async {
          if (_cacheManager != null) {
            await _cacheManager!.put(cacheKey, videos);

            // Prefetch next page after successful fetch if enabled and has results
            if (enablePrefetching && videos.isNotEmpty) {
              _prefetchNextPage(
                filterMode: 'Featured',
                currentPage: page,
                pageSize: pageSize,
                userId: userId,
                partnerProfile: partnerProfile,
                partnerId: partnerId,
              );
            }
          }
        },
      );

      return result;
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Determines the platform the app is running on.
  ///
  /// Returns a string representing the platform.
  String getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// Resets the service to its initial state.
  ///
  /// This method:
  /// - Clears the user token
  /// - Removes the function to update token
  /// - Updates the datasource to clear the token
  /// - Clears all video caches
  Future<void> reset() async {
    userToken = '';
    functionToUpdateToken = null;
    _repository?.token = '';
    _dataSource
        ?.updateUserToken(''); // IMPORTANT: Clear token in datasource too!
    await clearVideoCache();
  }

  /// Prefetches the next page in the background.
  ///
  /// This method runs asynchronously without blocking the current request.
  /// It checks if the next page is already cached or being fetched before making a request.
  void _prefetchNextPage({
    required String filterMode,
    required int currentPage,
    required int pageSize,
    String? userId,
    String? partnerProfile,
    String? partnerId,
  }) {
    final nextPage = currentPage + 1;
    final nextPageKey = _buildVideoCacheKey(
      filterMode: filterMode,
      page: nextPage,
      pageSize: pageSize,
      userId: userId,
      partnerProfile: partnerProfile,
      partnerId: partnerId,
    );

    // Avoid duplicate prefetch operations
    if (_activePrefetches.contains(nextPageKey)) {
      return;
    }

    // Mark as active
    _activePrefetches.add(nextPageKey);

    // Run prefetch in background
    Future.microtask(() async {
      try {
        // Check if next page is already cached
        if (_cacheManager != null) {
          final cached = await _cacheManager!.get(nextPageKey);
          if (cached != null && cached.isNotEmpty) {
            _activePrefetches.remove(nextPageKey);
            return; // Already cached, no need to prefetch
          }
        }

        // Fetch next page from repository
        final result = filterMode == 'Featured'
            ? await _repository!.getFeaturedVideos(
                userId: userId,
                pageSize: pageSize,
                page: nextPage,
                partnerProfile: partnerProfile,
                partnerId: partnerId,
              )
            : await _repository!.getVideosWithFilter(
                filterMode: filterMode,
                page: nextPage,
                pageSize: pageSize,
                userId: userId,
                partnerProfile: partnerProfile,
                partnerId: partnerId,
              );

        // Cache the prefetched results
        await result.fold(
          (_) async {}, // Ignore errors in background prefetch
          (videos) async {
            if (_cacheManager != null && videos.isNotEmpty) {
              await _cacheManager!.put(nextPageKey, videos);
            }
          },
        );
      } catch (e) {
        // Silently fail prefetch - don't affect user experience
        StoyCoLogger.error('Prefetch failed for page $nextPage: $e');
      } finally {
        _activePrefetches.remove(nextPageKey);
      }
    });
  }

  /// Builds a cache key for video list requests.
  ///
  /// [filterMode] The filter mode.
  /// [page] The page number.
  /// [pageSize] The page size.
  /// [userId] Optional user ID.
  /// [partnerProfile] Optional partner profile.
  /// [partnerId] Optional partner ID.
  ///
  /// Returns a unique cache key string.
  String _buildVideoCacheKey({
    required String filterMode,
    required int page,
    required int pageSize,
    String? userId,
    String? partnerProfile,
    String? partnerId,
  }) =>
      '$filterMode:${partnerProfile ?? 'null'}:${partnerId ?? 'null'}:${userId ?? 'null'}:$page:$pageSize';

  /// Clears all video list caches.
  ///
  /// Call this when you need to force a complete refresh of video content,
  /// for example after the user performs a pull-to-refresh action.
  Future<void> clearVideoCache() async {
    _cacheManager ??= VideoCacheManager.instance;
    if (_cacheManager != null) {
      await _cacheManager!.clear();
    }
  }

  /// Removes a specific video from all cache entries.
  ///
  /// Useful when you need to force a refresh for a specific video
  /// without clearing the entire cache.
  ///
  /// [videoId] The ID of the video to remove from cache.
  Future<void> invalidateVideoCacheForVideo(String videoId) async {
    _cacheManager ??= VideoCacheManager.instance;
    if (_cacheManager == null) return;

    await _cacheManager!.removeVideoFromCache(videoId);
  }

  /// Clears video cache for a specific filter configuration.
  ///
  /// [filterMode] The filter mode.
  /// [userId] Optional user ID.
  /// [partnerProfile] Optional partner profile.
  /// [partnerId] Optional partner ID.
  ///
  /// This clears all pages for the given filter combination.
  Future<void> clearVideoCacheForFilter({
    required String filterMode,
    String? userId,
    String? partnerProfile,
    String? partnerId,
  }) async {
    _cacheManager ??= VideoCacheManager.instance;
    if (_cacheManager == null) return;

    // Build partial key pattern
    final keyPrefix =
        '$filterMode:${partnerProfile ?? 'null'}:${partnerId ?? 'null'}:${userId ?? 'null'}:';

    await _cacheManager!.clearByPrefix(keyPrefix);
  }
}

/// Cached video interaction with a timestamp.
class _CachedVideoInteraction {
  /// Creates a new cached video interaction.
  ///
  /// [reaction] The video interaction reaction.
  /// [timestamp] The time the reaction was cached.
  _CachedVideoInteraction(this.reaction, this.timestamp);
  final VideoInteraction reaction;
  final DateTime timestamp;
}
