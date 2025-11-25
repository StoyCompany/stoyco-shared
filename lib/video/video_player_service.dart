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
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_service.dart';

/// Service responsible for managing video playback and reactions.
///
/// This service includes intelligent caching with persistent storage to prevent
/// redundant backend calls when users switch between tabs or filter modes.
/// Cache persists across app sessions using Hive.
///
/// ## Cache Update Strategies
///
/// When video metadata changes (likes, shares, following status), update the cache
/// instead of invalidating to avoid unnecessary backend calls:
///
/// - **Like/Dislike**: Automatically invalidates the specific video cache entry
/// - **Share**: Automatically invalidates the specific video cache entry
/// - **Follow/Unfollow Partner**: Call `updatePartnerFollowingInCache()` to update
///   the `followingCO` field in all videos from that partner
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
/// // After user follows a partner
/// await partnerService.followPartner(partnerId: 'partner123');
/// await videoService.updatePartnerFollowingInCache('partner123', true);
/// // All cached videos from this partner now show followingCO = true
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
  /// [activeSubscriptionService] Service for validating user access to subscription content.
  VideoPlayerService._({
    required this.activeSubscriptionService,
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
    this.videoCacheTTL = 300,
  }) {
    _dataSource = VideoPlayerDataSourceV2(environment);
    _repository = VideoPlayerRepositoryV2(
      _dataSource!,
      userToken,
      activeSubscriptionService,
    );
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
  /// [activeSubscriptionService] Service for validating user access to subscription content.
  ///
  /// Example:
  /// ```dart
  /// var videoService = VideoPlayerService(
  ///   userToken: 'abc123',
  ///   videoCacheTTL: 600,
  ///   activeSubscriptionService: activeSubscriptionService,
  /// );
  /// ```
  factory VideoPlayerService({
    required ActiveSubscriptionService activeSubscriptionService,
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?>? functionToUpdateToken,
    int videoCacheTTL = 300,
  }) {
    _instance = VideoPlayerService._(
      activeSubscriptionService: activeSubscriptionService,
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
      videoCacheTTL: videoCacheTTL,
    );

    return _instance!;
  }

  /// Service for validating user access to subscription content.
  final ActiveSubscriptionService activeSubscriptionService;

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

  /// Flag to track if we've attempted cache initialization
  bool _cacheInitAttempted = false;

  /// Tracks active prefetch operations to avoid duplicate prefetching.
  final Set<String> _activePrefetches = {};

  /// Tracks active fetch operations to prevent duplicate concurrent requests.
  final Map<String, Future<Either<Failure, List<VideoWithMetadata>>>>
      _activeRequests = {};

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
  /// [maxCacheSize] Maximum number of cache entries (default: 500).
  /// [cachePath] Optional custom path for Hive storage.
  ///
  /// Example:
  /// ```dart
  /// await VideoPlayerService.initializeCache(ttl: 600);
  /// ```
  static Future<void> initializeCache({
    int ttl = 300,
    int maxCacheSize = 1500,
    String? cachePath,
  }) async {
    await VideoCacheManager.initialize(
      ttl: ttl,
      maxCacheSize: maxCacheSize,
      cachePath: cachePath,
    );
  }

  /// Gets the cache manager, initializing it if necessary.
  ///
  /// This ensures the cache is always available even if the app restarts
  /// and initialize() wasn't called explicitly.
  Future<VideoCacheManager?> _getCacheManager() async {
    // Always check if there's a valid singleton instance first
    _cacheManager = VideoCacheManager.instance;
    if (_cacheManager != null) {
      return _cacheManager;
    }

    // If no instance exists and we haven't tried initializing yet, try now
    if (!_cacheInitAttempted) {
      _cacheInitAttempted = true;
      try {
        await VideoCacheManager.initialize(
          ttl: videoCacheTTL,
        );
        _cacheManager = VideoCacheManager.instance;
        if (_cacheManager != null) {
          StoyCoLogger.info(
              '[VIDEO_CACHE_INIT] ✅ Cache manager initialized successfully');
        } else {
          StoyCoLogger.warning(
              '[VIDEO_CACHE_INIT] ⚠️ Cache manager initialized but instance is null');
        }
      } catch (e) {
        StoyCoLogger.error(
            '[VIDEO_CACHE_INIT] ❌ Failed to initialize cache manager: $e');
        // Continue without cache
      }
    } else {
      StoyCoLogger.warning(
          '[VIDEO_CACHE_INIT] ⚠️ Cache manager not available and already attempted initialization');
    }

    return _cacheManager;
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
      final reaction = await _handleReaction(result, videoId);

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
      final reaction = await _handleReaction(result, videoId);

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
    String videoId,
  ) async =>
      result.fold(
        (left) => Left(left),
        (reaction) => getVideoReactionsById(
          videoId,
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
      final cacheManager = await _getCacheManager();
      if (!forceRefresh && cacheManager != null) {
        StoyCoLogger.info('[VIDEO_CACHE] 🔍 Checking cache for key: $cacheKey');
        final cached = await cacheManager.get(cacheKey);
        if (cached != null && cached.isNotEmpty) {
          StoyCoLogger.info(
              '[VIDEO_CACHE] ✅ Cache HIT: Found ${cached.length} videos for key: $cacheKey');
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
        } else {
          StoyCoLogger.info(
              '[VIDEO_CACHE] ❌ Cache MISS: No cached data for key: $cacheKey');
        }
      } else if (cacheManager == null) {
        StoyCoLogger.warning(
            '[VIDEO_CACHE] ⚠️ Cache manager not available - fetching from backend');
      }

      // Check if there's already an active request for this key
      if (_activeRequests.containsKey(cacheKey)) {
        StoyCoLogger.info(
            '[VIDEO_CACHE] ⏳ Request already in progress for key: $cacheKey, waiting...');
        return await _activeRequests[cacheKey]!;
      }

      // Fetch from repository and track the request
      final requestFuture = _fetchAndCacheVideos(
        cacheKey: cacheKey,
        filterMode: filterMode,
        page: page,
        pageSize: pageSize,
        userId: userId,
        partnerProfile: partnerProfile,
        partnerId: partnerId,
      );
      _activeRequests[cacheKey] = requestFuture;

      return await requestFuture;
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
      final cacheManager = await _getCacheManager();
      if (!forceRefresh && cacheManager != null) {
        StoyCoLogger.info(
            '[VIDEO_CACHE] 🔍 Checking cache for featured videos key: $cacheKey');
        final cached = await cacheManager.get(cacheKey);
        if (cached != null && cached.isNotEmpty) {
          StoyCoLogger.info(
              '[VIDEO_CACHE] ✅ Cache HIT: Found ${cached.length} featured videos for key: $cacheKey');
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
        } else {
          StoyCoLogger.info(
              '[VIDEO_CACHE] ❌ Cache MISS: No cached featured videos for key: $cacheKey');
        }
      } else if (cacheManager == null) {
        StoyCoLogger.warning(
            '[VIDEO_CACHE] ⚠️ Cache manager not available - fetching featured videos from backend');
      }

      // Check if there's already an active request for this key
      if (_activeRequests.containsKey(cacheKey)) {
        StoyCoLogger.info(
            '[VIDEO_CACHE] ⏳ Request already in progress for key: $cacheKey, waiting...');
        return await _activeRequests[cacheKey]!;
      }

      // Fetch from repository and track the request
      final requestFuture = _fetchAndCacheVideos(
        cacheKey: cacheKey,
        filterMode: 'Featured',
        page: page,
        pageSize: pageSize,
        userId: userId,
        partnerProfile: partnerProfile,
        partnerId: partnerId,
      );
      _activeRequests[cacheKey] = requestFuture;

      return await requestFuture;
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
  /// - Resets cache manager reference (but does NOT clear cached data)
  ///
  /// Note: The cache is NOT cleared to maintain performance across sessions.
  /// Use clearVideoCache() explicitly if you need to clear the cache.
  Future<void> reset() async {
    userToken = '';
    functionToUpdateToken = null;
    _repository?.token = '';
    _dataSource
        ?.updateUserToken(''); // IMPORTANT: Clear token in datasource too!
    // Don't clear video cache - let it persist for better performance
    // await clearVideoCache();
    _cacheManager = null;
    _cacheInitAttempted = false; // Allow cache to be reinitialized
  }

  /// Fetches videos from repository and caches them, with proper cleanup.
  /// Fetches videos from repository and caches them, with proper cleanup.
  Future<Either<Failure, List<VideoWithMetadata>>> _fetchAndCacheVideos({
    required String cacheKey,
    required String filterMode,
    required int page,
    required int pageSize,
    String? userId,
    String? partnerProfile,
    String? partnerId,
  }) async {
    try {
      // Choose the right repository method based on filterMode
      final result = filterMode == 'Featured'
          ? await _repository!.getFeaturedVideos(
              userId: userId,
              pageSize: pageSize,
              page: page,
              partnerProfile: partnerProfile,
              partnerId: partnerId,
            )
          : await _repository!.getVideosWithFilter(
              filterMode: filterMode,
              page: page,
              pageSize: pageSize,
              userId: userId,
              partnerProfile: partnerProfile,
              partnerId: partnerId,
            );

      // Cache successful results
      await result.fold(
        (_) async {},
        (videos) async {
          final cacheManager = await _getCacheManager();
          if (cacheManager != null) {
            StoyCoLogger.info(
                '[VIDEO_CACHE] 💾 Caching ${videos.length} videos for key: $cacheKey');
            await cacheManager.put(cacheKey, videos);

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
          } else {
            StoyCoLogger.warning(
                '[VIDEO_CACHE] ⚠️ Cannot cache videos - cache manager not available');
          }
        },
      );

      return result;
    } finally {
      // Always cleanup active request
      _activeRequests.remove(cacheKey);
    }
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
        final cacheManager = await _getCacheManager();
        if (cacheManager != null) {
          final cached = await cacheManager.get(nextPageKey);
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
            if (cacheManager != null && videos.isNotEmpty) {
              await cacheManager.put(nextPageKey, videos);
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
  /// [userId] Optional user ID. When null, uses "anonymous" to share cache across sessions.
  /// [partnerProfile] Optional partner profile.
  /// [partnerId] Optional partner ID.
  ///
  /// Returns a unique cache key string.
  ///
  /// Note: For non-logged-in users (userId = null), we use "anonymous" as the identifier
  /// so that public content is cached and shared across app sessions on the same device.
  String _buildVideoCacheKey({
    required String filterMode,
    required int page,
    required int pageSize,
    String? userId,
    String? partnerProfile,
    String? partnerId,
  }) {
    // Use "anonymous" for non-logged-in users to share cache across sessions
    final effectiveUserId = userId ?? 'anonymous';
    return '$filterMode:${partnerProfile ?? 'null'}:${partnerId ?? 'null'}:$effectiveUserId:$page:$pageSize';
  }

  /// Clears all video list caches.
  ///
  /// Call this when you need to force a complete refresh of video content,
  /// for example after the user performs a pull-to-refresh action.
  Future<void> clearVideoCache() async {
    final cacheManager = await _getCacheManager();
    if (cacheManager != null) {
      await cacheManager.clear();
    }
  }

  /// Removes a specific video from all cache entries.
  ///
  /// Useful when you need to force a refresh for a specific video
  /// without clearing the entire cache.
  ///
  /// [videoId] The ID of the video to remove from cache.
  Future<void> invalidateVideoCacheForVideo(String videoId) async {
    final cacheManager = await _getCacheManager();
    if (cacheManager == null) return;

    await cacheManager.removeVideoFromCache(videoId);
  }

  /// Updates the following status for all videos from a specific partner in the cache.
  ///
  /// This should be called after a user follows or unfollows a partner to ensure
  /// cached videos reflect the correct following state without requiring a backend fetch.
  ///
  /// [partnerId] The ID of the partner whose videos should be updated.
  /// [isFollowing] The new following state (true = following, false = not following).
  ///
  /// Example:
  /// ```dart
  /// // After user follows a partner
  /// await videoService.updatePartnerFollowingInCache('partner123', true);
  ///
  /// // After user unfollows a partner
  /// await videoService.updatePartnerFollowingInCache('partner123', false);
  /// ```
  Future<void> updatePartnerFollowingInCache(
    String partnerId,
    bool isFollowing,
  ) async {
    final cacheManager = await _getCacheManager();
    if (cacheManager == null) return;

    await cacheManager.updatePartnerFollowingStatus(partnerId, isFollowing);
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
    final cacheManager = await _getCacheManager();
    if (cacheManager == null) return;

    // Build partial key pattern
    final keyPrefix =
        '$filterMode:${partnerProfile ?? 'null'}:${partnerId ?? 'null'}:${userId ?? 'null'}:';

    await cacheManager.clearByPrefix(keyPrefix);
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
