import 'package:stoyco_shared/utils/logger.dart';
import 'package:stoyco_shared/cache/cache_manager.dart';

/// Global manager that tracks all cache manager instances across repositories.
///
/// Provides centralized control for invalidating cache across the entire application.
/// All [CacheManager] instances can be registered here for coordinated cache management.
///
/// Example usage:
/// ```dart
/// // Clear all caches in the application
/// GlobalCacheManager.clearAllCaches();
///
/// // Invalidate specific pattern across all caches
/// GlobalCacheManager.invalidatePatternGlobally('news_');
///
/// // Get registered cache count
/// print('Active caches: ${GlobalCacheManager.registeredCacheCount}');
/// ```
class GlobalCacheManager {
  /// Private constructor to prevent instantiation.
  GlobalCacheManager._();

  /// Set of all registered cache managers.
  static final Set<CacheManager> _registeredCaches = {};

  /// Registers a cache manager instance.
  ///
  /// Called automatically by cache implementations when they are created.
  ///
  /// Example:
  /// ```dart
  /// GlobalCacheManager.register(myCacheManager);
  /// ```
  static void register(CacheManager cacheManager) {
    _registeredCaches.add(cacheManager);
    StoyCoLogger.info(
        'GlobalCacheManager: Cache registered. Total: ${_registeredCaches.length}');
  }

  /// Unregisters a cache manager instance.
  ///
  /// Should be called when a cache manager is disposed or no longer needed.
  ///
  /// Example:
  /// ```dart
  /// GlobalCacheManager.unregister(myCacheManager);
  /// ```
  static void unregister(CacheManager cacheManager) {
    _registeredCaches.remove(cacheManager);
    StoyCoLogger.info(
        'GlobalCacheManager: Cache unregistered. Total: ${_registeredCaches.length}');
  }

  /// Clears all data from all registered cache managers.
  ///
  /// This is a destructive operation that removes ALL cached data across
  /// the entire application. Use with caution.
  ///
  /// Typical use cases:
  /// - User logout
  /// - App data reset
  /// - Switching environments
  ///
  /// Example:
  /// ```dart
  /// // On user logout
  /// GlobalCacheManager.clearAllCaches();
  /// ```
  static void clearAllCaches() {
    StoyCoLogger.info(
        'GlobalCacheManager: Clearing all caches (${_registeredCaches.length} instances)');
    for (final cache in _registeredCaches) {
      try {
        cache.clear();
      } catch (e, s) {
        StoyCoLogger.error('GlobalCacheManager: Error clearing cache',
            error: e, stackTrace: s);
      }
    }
  }

  /// Invalidates a specific key across all registered cache managers.
  ///
  /// Returns the total number of successful invalidations.
  ///
  /// Example:
  /// ```dart
  /// final count = GlobalCacheManager.invalidateKeyGlobally('user_123');
  /// print('Invalidated in $count caches');
  /// ```
  static int invalidateKeyGlobally(String key) {
    int count = 0;
    for (final cache in _registeredCaches) {
      try {
        if (cache.invalidate(key)) {
          count++;
        }
      } catch (e, s) {
        StoyCoLogger.error('GlobalCacheManager: Error invalidating key "$key"',
            error: e, stackTrace: s);
      }
    }
    StoyCoLogger.info(
        'GlobalCacheManager: Invalidated key "$key" in $count cache(s)');
    return count;
  }

  /// Invalidates all keys matching a pattern across all registered cache managers.
  ///
  /// Uses [String.contains] to match patterns.
  /// Returns the total number of keys invalidated.
  ///
  /// Example:
  /// ```dart
  /// // Invalidate all news caches
  /// final count = GlobalCacheManager.invalidatePatternGlobally('news_');
  /// print('Invalidated $count keys');
  /// ```
  static int invalidatePatternGlobally(String pattern) {
    int totalCount = 0;
    for (final cache in _registeredCaches) {
      try {
        final keysToRemove =
            cache.keys.where((key) => key.contains(pattern)).toList();
        for (final key in keysToRemove) {
          if (cache.invalidate(key)) {
            totalCount++;
          }
        }
      } catch (e, s) {
        StoyCoLogger.error(
            'GlobalCacheManager: Error invalidating pattern "$pattern"',
            error: e,
            stackTrace: s);
      }
    }
    StoyCoLogger.info(
        'GlobalCacheManager: Invalidated $totalCount key(s) matching pattern "$pattern"');
    return totalCount;
  }

  /// Returns the number of currently registered cache managers.
  static int get registeredCacheCount => _registeredCaches.length;

  /// Returns all registered cache managers.
  ///
  /// Use with caution - this exposes internal state for advanced use cases.
  static Set<CacheManager> get registeredCaches =>
      Set.unmodifiable(_registeredCaches);

  /// Resets the global cache registry.
  ///
  /// For testing purposes only. Clears the registry without affecting
  /// the cache managers themselves.
  ///
  /// Example:
  /// ```dart
  /// void setUp() {
  ///   GlobalCacheManager.resetForTesting();
  /// }
  /// ```
  static void resetForTesting() {
    _registeredCaches.clear();
  }
}
