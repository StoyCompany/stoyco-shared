import 'package:stoyco_shared/cache/global_cache_manager.dart';

/// Utility class providing easy access to global cache operations.
///
/// This class provides static methods that can be called from anywhere
/// in the application (including UI layer, services, or repositories)
/// to manage cache globally.
///
/// Example usage in a UI logout button:
/// ```dart
/// ElevatedButton(
///   onPressed: () {
///     CacheUtils.clearAllCaches();
///     Navigator.pushReplacementNamed(context, '/login');
///   },
///   child: Text('Logout'),
/// )
/// ```
///
/// Example usage in a service:
/// ```dart
/// class AuthService {
///   Future<void> logout() async {
///     await _clearTokens();
///     CacheUtils.clearAllCaches(); // Clear all repository caches
///     await _navigateToLogin();
///   }
/// }
/// ```
class CacheUtils {
  /// Private constructor to prevent instantiation.
  CacheUtils._();

  /// Clears all caches across all repositories in the application.
  ///
  /// This is a destructive operation that removes ALL cached data.
  ///
  /// Typical use cases:
  /// - User logout
  /// - App data reset
  /// - Switching environments or accounts
  /// - Data synchronization issues
  ///
  /// Example:
  /// ```dart
  /// // In a logout flow
  /// CacheUtils.clearAllCaches();
  /// ```
  static void clearAllCaches() {
    GlobalCacheManager.clearAllCaches();
  }

  /// Invalidates a specific key across all repository caches.
  ///
  /// Returns the number of caches where the key was found and invalidated.
  ///
  /// Use this when you know a specific piece of data has changed
  /// and needs to be refreshed everywhere.
  ///
  /// Example:
  /// ```dart
  /// // After updating user profile
  /// final count = CacheUtils.invalidateKey('user_123');
  /// print('Updated cache in $count repositories');
  /// ```
  static int invalidateKey(String key) =>
      GlobalCacheManager.invalidateKeyGlobally(key);

  /// Invalidates all keys matching a pattern across all repository caches.
  ///
  /// Uses [String.contains] to match patterns.
  /// Returns the total number of keys invalidated.
  ///
  /// Useful for invalidating groups of related data.
  ///
  /// Example:
  /// ```dart
  /// // Clear all news-related caches
  /// CacheUtils.invalidatePattern('news_');
  ///
  /// // Clear all data for a specific user
  /// CacheUtils.invalidatePattern('user_${userId}_');
  ///
  /// // Clear all event caches
  /// CacheUtils.invalidatePattern('event_');
  /// ```
  static int invalidatePattern(String pattern) =>
      GlobalCacheManager.invalidatePatternGlobally(pattern);

  /// Returns the number of currently registered cache managers.
  ///
  /// Useful for debugging or monitoring cache usage.
  ///
  /// Example:
  /// ```dart
  /// print('Active caches: ${CacheUtils.registeredCacheCount}');
  /// ```
  static int get registeredCacheCount =>
      GlobalCacheManager.registeredCacheCount;
}
