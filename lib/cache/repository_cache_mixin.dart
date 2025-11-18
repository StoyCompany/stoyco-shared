import 'package:either_dart/either.dart';
import '../errors/errors.dart';
import 'cache_manager.dart';
import 'in_memory_cache_manager.dart';
import 'persistent_cache_manager.dart';
import 'dart:io';
import 'models/cache_entry.dart';

/// Mixin that adds caching capabilities to repository classes.
///
/// Provides helper methods to cache and retrieve [Either<Failure, T>] results.
/// Uses a [CacheManager] (defaults to [InMemoryCacheManager]) for storage.
///
/// Example usage:
/// ```dart
/// class EventRepositoryImpl with RepositoryCacheMixin implements EventRepository {
///   EventRepositoryImpl(this._eventDs);
///   final EventDataSource _eventDs;
///
///   @override
///   Future<Either<Failure, Event>> getEventId(String eventId) async {
///     return cachedCall<Event>(
///       key: 'event_$eventId',
///       ttl: Duration(minutes: 5),
///       fetcher: () => _eventDs.getEventId(eventId).then((dataState) {
///         if (dataState.data != null) {
///           return Right(dataState.data!);
///         } else {
///           return Left(Failure(message: 'Event not found'));
///         }
///       }),
///     );
///   }
/// }
/// ```
mixin RepositoryCacheMixin {
  CacheManager? _cacheManager;

  /// The cache manager used by this repository.
  ///
  /// Defaults to [InMemoryCacheManager] if not set.
  CacheManager get cacheManager {
    if (_cacheManager != null) return _cacheManager!;
    // Default to persistent cache manager; fall back to in-memory if file creation fails.
    try {
      final dir = Directory.systemTemp.path; // lightweight default path
      _cacheManager = PersistentCacheManager(directoryPath: dir);
    } catch (_) {
      _cacheManager = InMemoryCacheManager();
    }
    return _cacheManager!;
  }

  /// Sets a custom cache manager.
  ///
  /// Useful for testing or using different cache implementations.
  set cacheManager(CacheManager manager) {
    _cacheManager = manager;
  }

  /// Executes a cached call with automatic caching and expiration.
  ///
  /// First checks if valid cached data exists. If so, returns it.
  /// Otherwise, executes [fetcher], caches the successful result, and returns it.
  ///
  /// Parameters:
  /// - [key]: Unique cache key for this call
  /// - [ttl]: Time-To-Live for the cached data
  /// - [fetcher]: Function that fetches the data if not cached
  /// - [forceRefresh]: If true, bypasses cache and fetches fresh data
  ///
  /// Example:
  /// ```dart
  /// return cachedCall<User>(
  ///   key: 'user_$userId',
  ///   ttl: Duration(minutes: 10),
  ///   fetcher: () => _userDs.getUser(userId),
  /// );
  /// ```
  Future<Either<Failure, T>> cachedCall<T>({
    required String key,
    required Duration ttl,
    required Future<Either<Failure, T>> Function() fetcher,
    bool forceRefresh = false,
  }) async {
    // Check cache first (unless force refresh)
    if (!forceRefresh) {
      final cachedEntry = cacheManager.get<dynamic>(key);
      if (cachedEntry != null && cachedEntry.isValid) {
        final data = cachedEntry.data;
        if (data is Either<Failure, T>) {
          return data;
        }
        if (data is Either<Failure, dynamic> &&
            data.isRight &&
            data.right is T) {
          return Right<Failure, T>(data.right as T);
        }
      }
    }

    // Fetch fresh data
    final result = await fetcher();

    // Only cache successful results
    if (result.isRight) {
      cacheManager.set(
        key,
        CacheEntry<Either<Failure, T>>(
          data: result,
          ttl: ttl,
        ),
      );
    }

    return result;
  }

  /// Invalidates (removes) cached data for a specific key.
  ///
  /// Returns true if the cache entry was removed.
  ///
  /// Example:
  /// ```dart
  /// invalidateCache('event_123');
  /// ```
  bool invalidateCache(String key) {
    return cacheManager.invalidate(key);
  }

  /// Invalidates multiple cache keys at once.
  ///
  /// Useful for clearing related cached data.
  ///
  /// Example:
  /// ```dart
  /// invalidateCacheMultiple(['user_123', 'user_profile_123']);
  /// ```
  void invalidateCacheMultiple(List<String> keys) {
    for (final key in keys) {
      cacheManager.invalidate(key);
    }
  }

  /// Invalidates all cache keys matching a pattern.
  ///
  /// Uses [String.contains] to match patterns.
  ///
  /// Example:
  /// ```dart
  /// invalidateCachePattern('event_'); // Invalidates all event caches
  /// ```
  bool invalidateCachePattern(String pattern) {
    final keysToRemove =
        cacheManager.keys.where((key) => key.contains(pattern)).toList();

    for (final key in keysToRemove) {
      cacheManager.invalidate(key);
    }
    return keysToRemove.isNotEmpty;
  }

  /// Clears all cached data in the cache manager.
  void clearAllCache() {
    cacheManager.clear();
  }
}
