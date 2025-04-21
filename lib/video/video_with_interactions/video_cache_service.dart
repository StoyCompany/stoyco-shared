import 'package:video_player/video_player.dart';

/// A singleton service that manages video player controllers cache.
///
/// This service helps optimize video playback by maintaining a cache of
/// [VideoPlayerController] instances, reducing memory usage and improving
/// performance when dealing with multiple videos.
class VideoCacheService {
  /// Factory constructor that returns the singleton instance.
  factory VideoCacheService() => _instance;

  /// Private constructor for singleton pattern.
  VideoCacheService._internal();

  static final VideoCacheService _instance = VideoCacheService._internal();

  /// Internal cache storage for video controllers.
  final Map<String, VideoPlayerController> _cache = {};

  /// Maximum number of controllers that can be stored in cache.
  final int _maxCacheSize = 5;

  /// Retrieves or creates a [VideoPlayerController] for the given URL.
  ///
  /// If a controller for the URL exists in cache and is initialized,
  /// returns the cached controller. Otherwise, creates a new controller,
  /// initializes it, and stores it in cache.
  ///
  /// If cache is full, the oldest controller will be paused.
  ///
  /// [url] The URL of the video to get the controller for.
  /// Returns a Future that completes with the initialized controller.
  Future<VideoPlayerController> getController(String url) async {
    if (_cache.containsKey(url)) {
      final controller = _cache[url]!;
      if (controller.value.isInitialized) {
        return controller;
      }
    }

    if (_cache.length >= _maxCacheSize) {
      final oldestUrl = _cache.keys.first;
      await _cache[oldestUrl]?.pause();
    }

    final controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions:VideoPlayerOptions(mixWithOthers: true),
    );
    await controller.initialize();
    _cache[url] = controller;
    return controller;
  }

  /// Pauses the video controller associated with the given URL if it exists in cache.
  ///
  /// [url] The URL of the video to pause.
  Future<void> pauseController(String url) async {
    if (_cache.containsKey(url)) {
      await _cache[url]?.pause();
    }
  }

  /// Removes a controller from cache after pausing it.
  ///
  /// [url] The URL of the video to remove from cache.
  Future<void> removeFromCache(String url) async {
    await pauseController(url);
  }

  /// Clears all controllers from cache and disposes them.
  ///
  /// This should be called when the cache is no longer needed to free up resources.
  void clearCache() {
    for (final controller in _cache.values) {
      controller.dispose();
    }
    _cache.clear();
  }

  /// Preloads a video controller for the given URL if it's not already in cache.
  ///
  /// This is useful for preparing videos that are likely to be played soon.
  ///
  /// [url] The URL of the video to preload.
  Future<void> preloadNext(String url) async {
    if (!_cache.containsKey(url)) {
      await getController(url);
    }
  }
}
