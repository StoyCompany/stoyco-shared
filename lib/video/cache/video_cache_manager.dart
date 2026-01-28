import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:stoyco_shared/video/video_with_metada/video_with_metadata.dart';

/// Manages persistent caching of video lists using Hive.
///
/// This class provides both in-memory and disk-based caching with:
/// - TTL (Time To Live) for cache expiration
/// - LRU eviction policy
/// - Deduplication by video ID
/// - Size limits to prevent unbounded growth
///
/// Example:
/// ```dart
/// final cacheManager = await VideoCacheManager.initialize(ttl: 300);
/// await cacheManager.put('cache_key', videoList);
/// final cached = await cacheManager.get('cache_key');
/// ```
class VideoCacheManager {
  VideoCacheManager._({
    required this.ttl,
    required this.maxCacheSize,
  });

  /// Box name for video cache entries
  static const String _cacheBoxName = 'video_cache';

  /// Box name for cache metadata (timestamps, access times)
  static const String _metadataBoxName = 'video_cache_metadata';

  /// Time to live for cache entries in seconds
  final int ttl;

  /// Maximum number of cache entries before LRU eviction
  final int maxCacheSize;

  /// Hive box for storing video lists
  Box<String>? _cacheBox;

  /// Hive box for storing metadata
  Box<Map<dynamic, dynamic>>? _metadataBox;

  /// In-memory cache for fast access
  final Map<String, List<VideoWithMetadata>> _memoryCache = {};

  /// Set of all cached video IDs for deduplication
  final Set<String> _cachedVideoIds = {};

  /// Singleton instance
  static VideoCacheManager? _instance;

  /// Initializes the video cache manager.
  ///
  /// [ttl] Cache time to live in seconds (default: 60 = 1 minute).
  /// [maxCacheSize] Maximum number of cache entries (default: 100).
  /// [cachePath] Optional custom path for Hive storage.
  ///
  /// Returns the initialized singleton instance.
  static Future<VideoCacheManager> initialize({
    int ttl = 60,
    int maxCacheSize = 1500,
    String? cachePath,
  }) async {
    if (_instance != null) return _instance!;

    if (cachePath != null) {
      Hive.init(cachePath);
    }

    _instance = VideoCacheManager._(
      ttl: ttl,
      maxCacheSize: maxCacheSize,
    );

    await _instance!._openBoxes();
    await _instance!._loadCachedVideoIds();

    return _instance!;
  }

  /// Returns the current instance if initialized, null otherwise.
  static VideoCacheManager? get instance => _instance;

  /// Resets the singleton instance (for testing).
  ///
  /// This method closes all Hive boxes and clears the singleton instance.
  /// Use this in test tearDown to ensure clean state between tests.
  static Future<void> resetInstance() async {
    if (_instance != null) {
      await _instance!.clear();
      await _instance!._cacheBox?.close();
      await _instance!._metadataBox?.close();
      _instance = null;
    }
  }

  /// Opens Hive boxes for cache storage.
  Future<void> _openBoxes() async {
    try {
      _cacheBox = await Hive.openBox<String>(_cacheBoxName);
      _metadataBox = await Hive.openBox<Map>(_metadataBoxName);
    } catch (e) {
      // If boxes fail to open, continue with memory-only cache
      _cacheBox = null;
      _metadataBox = null;
    }
  }

  /// Loads all cached video IDs into memory for deduplication.
  Future<void> _loadCachedVideoIds() async {
    if (_cacheBox == null) return;

    for (final key in _cacheBox!.keys) {
      try {
        final jsonString = _cacheBox!.get(key);
        if (jsonString != null) {
          final List<dynamic> jsonList =
              jsonDecode(jsonString) as List<dynamic>;
          for (final item in jsonList) {
            if (item is Map<String, dynamic>) {
              final video = VideoWithMetadata.fromJson(item);
              final videoId = video.id;
              if (videoId != null && videoId.isNotEmpty) {
                _cachedVideoIds.add(videoId);
              }
            }
          }
        }
      } catch (_) {
        // Skip corrupted entries
      }
    }
  }

  /// Retrieves a cached video list by key.
  ///
  /// [key] The cache key.
  ///
  /// Returns the cached list if valid, null if expired or not found.
  ///
  /// NOTE: Returns a deep copy of the cached objects to prevent shared references.
  /// This ensures that updates to cached data don't affect objects already in use in the UI.
  Future<List<VideoWithMetadata>?> get(String key) async {
    // Check memory cache first
    if (_memoryCache.containsKey(key)) {
      final isValid = await _isValid(key);
      if (isValid) {
        await _updateAccessTime(key);
        // Return a deep copy to prevent shared references
        final cachedVideos = _memoryCache[key]!;
        return cachedVideos
            .map((video) => VideoWithMetadata.fromJson(video.toJson()))
            .toList();
      } else {
        // Expired, remove from memory
        _memoryCache.remove(key);
      }
    }

    // Check disk cache
    if (_cacheBox == null || !_cacheBox!.containsKey(key)) {
      return null;
    }

    // Verify not expired
    if (!await _isValid(key)) {
      await remove(key);
      return null;
    }

    // Load from disk
    try {
      final jsonString = _cacheBox!.get(key);
      if (jsonString == null) return null;

      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      final videos = jsonList
          .map(
            (item) => VideoWithMetadata.fromJson(item as Map<String, dynamic>),
          )
          .toList();

      // Update memory cache
      _memoryCache[key] = videos;
      await _updateAccessTime(key);

      // Return a deep copy to prevent shared references
      return videos
          .map((video) => VideoWithMetadata.fromJson(video.toJson()))
          .toList();
    } catch (e) {
      // Remove corrupted entry
      await remove(key);
      return null;
    }
  }

  /// Stores a video list in cache.
  ///
  /// [key] The cache key.
  /// [videos] The list of videos to cache.
  ///
  /// Each cache key stores its complete video list independently.
  /// No global deduplication is performed to ensure each page caches correctly.
  Future<void> put(String key, List<VideoWithMetadata> videos) async {
    // Store in memory first (always succeeds)
    _memoryCache[key] = videos;

    // Track video IDs for removeVideoFromCache functionality
    for (final video in videos) {
      final videoId = video.id ?? '';
      if (videoId.isNotEmpty) {
        _cachedVideoIds.add(videoId);
      }
    }

    // Store in disk with metadata
    if (_cacheBox != null && _metadataBox != null) {
      try {
        final jsonList = videos.map((v) => v.toJson()).toList();
        final jsonString = jsonEncode(jsonList);

        final now = DateTime.now().millisecondsSinceEpoch;

        // Write metadata FIRST to ensure it exists before cache entry
        await _metadataBox!.put(key, {
          'timestamp': now,
          'accessTime': now,
        });

        // Then write cache entry
        await _cacheBox!.put(key, jsonString);

        // Enforce size limit
        await _evictIfNeeded();
      } catch (e) {
        // If disk write fails, at least we have memory cache
      }
    }
  }

  /// Removes a cache entry by key.
  ///
  /// [key] The cache key to remove.
  Future<void> remove(String key) async {
    // Remove from memory
    final videos = _memoryCache.remove(key);

    // Remove video IDs from set
    if (videos != null) {
      for (final video in videos) {
        final videoId = video.id ?? '';
        if (videoId.isNotEmpty) {
          _cachedVideoIds.remove(videoId);
        }
      }
    }

    // Remove from disk
    if (_cacheBox != null) {
      await _cacheBox!.delete(key);
      await _metadataBox?.delete(key);
    }
  }

  /// Clears all cache entries.
  Future<void> clear() async {
    _memoryCache.clear();
    _cachedVideoIds.clear();

    if (_cacheBox != null) {
      await _cacheBox!.clear();
      await _metadataBox?.clear();
    }
  }

  /// Removes cache entries matching a key prefix.
  ///
  /// [keyPrefix] The prefix to match (e.g., "Featured:Music:").
  Future<void> clearByPrefix(String keyPrefix) async {
    final keysToRemove = <String>[];

    // Find matching keys
    for (final key in _memoryCache.keys) {
      if (key.startsWith(keyPrefix)) {
        keysToRemove.add(key);
      }
    }

    if (_cacheBox != null) {
      for (final key in _cacheBox!.keys) {
        if (key.toString().startsWith(keyPrefix) &&
            !keysToRemove.contains(key)) {
          keysToRemove.add(key.toString());
        }
      }
    }

    // Remove all matching entries
    for (final key in keysToRemove) {
      await remove(key);
    }
  }

  /// Checks if a cache entry is still valid (not expired).
  Future<bool> _isValid(String key) async {
    // If no metadata box, assume memory cache is valid (no TTL check for memory-only)
    if (_metadataBox == null) return true;

    final metadata = _metadataBox!.get(key);
    if (metadata == null) {
      // No metadata but item exists - could be memory-only cache
      // Check if item is in memory cache, if so it's valid
      return _memoryCache.containsKey(key);
    }

    final timestamp = metadata['timestamp'] as int?;
    if (timestamp == null) return false;

    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    return age < ttl * 1000;
  }

  /// Updates the last access time for LRU eviction.
  Future<void> _updateAccessTime(String key) async {
    if (_metadataBox == null) return;

    final metadata = _metadataBox!.get(key);
    if (metadata != null) {
      metadata['accessTime'] = DateTime.now().millisecondsSinceEpoch;
      await _metadataBox!.put(key, metadata);
    }
  }

  /// Evicts least recently used entries if cache size exceeds limit.
  Future<void> _evictIfNeeded() async {
    if (_cacheBox == null || _metadataBox == null) return;
    if (_cacheBox!.length <= maxCacheSize) return;

    // Get all entries with access times
    final entries = <MapEntry<String, int>>[];
    for (final key in _cacheBox!.keys) {
      final metadata = _metadataBox!.get(key);
      if (metadata != null) {
        final accessTime = metadata['accessTime'] as int? ?? 0;
        entries.add(MapEntry(key.toString(), accessTime));
      }
    }

    // Sort by access time (oldest first)
    entries.sort((a, b) => a.value.compareTo(b.value));

    // Remove oldest entries until we're under the limit
    final toRemove = entries.length - maxCacheSize;
    for (var i = 0; i < toRemove; i++) {
      await remove(entries[i].key);
    }
  }

  /// Updates a specific video across all cache entries.
  ///
  /// This is useful when a video's metadata changes (e.g., likes, shares)
  /// and you want to update it everywhere it appears in the cache.
  ///
  /// [videoId] The ID of the video to update.
  /// [updater] Function that receives the old video and returns the updated version.
  ///
  /// Example:
  /// ```dart
  /// await cacheManager.updateVideoInCache(
  ///   videoId: 'video123',
  ///   updater: (video) => video.copyWith(
  ///     likes: (video.likes ?? 0) + 1,
  ///     likeThisVideo: true,
  ///   ),
  /// );
  /// ```
  Future<void> updateVideoInCache({
    required String videoId,
    required VideoWithMetadata Function(VideoWithMetadata) updater,
  }) async {
    // Update in memory cache
    for (final key in _memoryCache.keys.toList()) {
      final videos = _memoryCache[key];
      if (videos == null) continue;

      bool updated = false;
      final updatedVideos = videos.map((video) {
        if (video.id == videoId) {
          updated = true;
          return updater(video);
        }
        return video;
      }).toList();

      if (updated) {
        _memoryCache[key] = updatedVideos;

        // Update in disk cache
        if (_cacheBox != null) {
          try {
            final jsonString = jsonEncode(
              updatedVideos.map((v) => v.toJson()).toList(),
            );
            await _cacheBox!.put(key, jsonString);
          } catch (e) {
            // If update fails, remove the entry
            await remove(key);
          }
        }
      }
    }

    // Update in disk cache (for entries not in memory)
    if (_cacheBox != null) {
      for (final key in _cacheBox!.keys.toList()) {
        final keyString = key.toString();
        // Skip if already in memory cache
        if (_memoryCache.containsKey(keyString)) continue;

        try {
          final jsonString = _cacheBox!.get(key);
          if (jsonString == null) continue;

          final List<dynamic> jsonList =
              jsonDecode(jsonString) as List<dynamic>;
          bool updated = false;
          final updatedVideos = jsonList.map((item) {
            final video =
                VideoWithMetadata.fromJson(item as Map<String, dynamic>);
            if (video.id == videoId) {
              updated = true;
              return updater(video);
            }
            return video;
          }).toList();

          if (updated) {
            final updatedJsonString = jsonEncode(
              updatedVideos.map((v) => v.toJson()).toList(),
            );
            await _cacheBox!.put(key, updatedJsonString);
          }
        } catch (e) {
          // If update fails, remove the entry
          await remove(keyString);
        }
      }
    }
  }

  /// Updates the followingCO status for all videos from a specific partner.
  ///
  /// This should be called when a user follows/unfollows a partner,
  /// updating the follow state in all cached videos from that partner.
  ///
  /// [partnerId] The ID of the partner whose videos should be updated.
  /// [isFollowing] The new following state (true = following, false = not following).
  ///
  /// Example:
  /// ```dart
  /// // After user follows a partner
  /// await cacheManager.updatePartnerFollowingStatus('partner123', true);
  ///
  /// // After user unfollows a partner
  /// await cacheManager.updatePartnerFollowingStatus('partner123', false);
  /// ```
  Future<void> updatePartnerFollowingStatus(
    String partnerId,
    bool isFollowing,
  ) async {
    // Update in memory cache
    for (final key in _memoryCache.keys.toList()) {
      final videos = _memoryCache[key];
      if (videos == null) continue;

      bool updated = false;
      final updatedVideos = videos.map((video) {
        if (video.partnerId == partnerId) {
          updated = true;
          return video.copyWith(followingCO: isFollowing);
        }
        return video;
      }).toList();

      if (updated) {
        _memoryCache[key] = updatedVideos;

        // Update in disk cache
        if (_cacheBox != null) {
          try {
            final jsonString = jsonEncode(
              updatedVideos.map((v) => v.toJson()).toList(),
            );
            await _cacheBox!.put(key, jsonString);
          } catch (e) {
            // If update fails, remove the entry
            await remove(key);
          }
        }
      }
    }

    // Update in disk cache (for entries not in memory)
    if (_cacheBox != null) {
      for (final key in _cacheBox!.keys.toList()) {
        final keyString = key.toString();
        // Skip if already in memory cache
        if (_memoryCache.containsKey(keyString)) continue;

        try {
          final jsonString = _cacheBox!.get(key);
          if (jsonString == null) continue;

          final List<dynamic> jsonList =
              jsonDecode(jsonString) as List<dynamic>;
          bool updated = false;
          final updatedVideos = jsonList.map((item) {
            final video =
                VideoWithMetadata.fromJson(item as Map<String, dynamic>);
            if (video.partnerId == partnerId) {
              updated = true;
              return video.copyWith(followingCO: isFollowing);
            }
            return video;
          }).toList();

          if (updated) {
            final updatedJsonString = jsonEncode(
              updatedVideos.map((v) => v.toJson()).toList(),
            );
            await _cacheBox!.put(key, updatedJsonString);
          }
        } catch (e) {
          // If update fails, remove the entry
          await remove(keyString);
        }
      }
    }
  }

  /// Removes a specific video from all cache entries.
  ///
  /// Useful when you want to force a refresh for a specific video
  /// without clearing the entire cache.
  ///
  /// [videoId] The ID of the video to remove.
  Future<void> removeVideoFromCache(String videoId) async {
    // Remove from deduplication set
    _cachedVideoIds.remove(videoId);

    // Remove from memory cache
    for (final key in _memoryCache.keys.toList()) {
      final videos = _memoryCache[key];
      if (videos == null) continue;

      final filteredVideos = videos.where((v) => v.id != videoId).toList();
      if (filteredVideos.length != videos.length) {
        if (filteredVideos.isEmpty) {
          _memoryCache.remove(key);
          await remove(key);
        } else {
          _memoryCache[key] = filteredVideos;
          if (_cacheBox != null) {
            try {
              final jsonString = jsonEncode(
                filteredVideos.map((v) => v.toJson()).toList(),
              );
              await _cacheBox!.put(key, jsonString);
            } catch (e) {
              await remove(key);
            }
          }
        }
      }
    }

    // Remove from disk cache
    if (_cacheBox != null) {
      for (final key in _cacheBox!.keys.toList()) {
        final keyString = key.toString();
        if (_memoryCache.containsKey(keyString)) continue;

        try {
          final jsonString = _cacheBox!.get(key);
          if (jsonString == null) continue;

          final List<dynamic> jsonList =
              jsonDecode(jsonString) as List<dynamic>;
          final filteredList = jsonList.where((item) {
            final video =
                VideoWithMetadata.fromJson(item as Map<String, dynamic>);
            return video.id != videoId;
          }).toList();

          if (filteredList.length != jsonList.length) {
            if (filteredList.isEmpty) {
              await remove(keyString);
            } else {
              final updatedJsonString = jsonEncode(filteredList);
              await _cacheBox!.put(key, updatedJsonString);
            }
          }
        } catch (e) {
          await remove(keyString);
        }
      }
    }
  }

  /// Closes the cache manager and Hive boxes.
  Future<void> close() async {
    _memoryCache.clear();
    _cachedVideoIds.clear();

    await _cacheBox?.close();
    await _metadataBox?.close();

    _cacheBox = null;
    _metadataBox = null;
    _instance = null;
  }
}
