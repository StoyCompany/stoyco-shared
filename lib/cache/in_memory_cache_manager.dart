import 'package:stoyco_shared/cache/cache_manager.dart';
import 'package:stoyco_shared/cache/models/cache_entry.dart';

/// In-memory implementation of [CacheManager].
///
/// Stores cache entries in a Map. Data is lost when the app restarts.
/// Automatically removes expired entries when accessed.
///
/// This is a singleton to ensure cache is shared across the app.
///
/// Example:
/// ```dart
/// final cache = InMemoryCacheManager();
///
/// // Store data
/// cache.set(
///   'user_123',
///   CacheEntry(
///     data: userData,
///     ttl: Duration(minutes: 10),
///   ),
/// );
///
/// // Retrieve data
/// final entry = cache.get<UserData>('user_123');
/// if (entry != null && entry.isValid) {
///   print(entry.data);
/// }
/// ```
class InMemoryCacheManager implements CacheManager {
  /// Returns the singleton instance of [InMemoryCacheManager].
  factory InMemoryCacheManager() => _instance;
  InMemoryCacheManager._();

  static final InMemoryCacheManager _instance = InMemoryCacheManager._();

  final Map<String, CacheEntry> _cache = {};

  @override
  CacheEntry<T>? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    // Auto-invalidate expired entries
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    return entry as CacheEntry<T>;
  }

  @override
  void set<T>(String key, CacheEntry<T> entry) {
    _cache[key] = entry;
  }

  @override
  bool invalidate(String key) => _cache.remove(key) != null;

  @override
  void clear() {
    _cache.clear();
  }

  @override
  bool containsKey(String key) => _cache.containsKey(key);

  @override
  int get length => _cache.length;

  @override
  Iterable<String> get keys => _cache.keys;

  /// Removes all expired entries from the cache.
  ///
  /// This can be called periodically to clean up expired data.
  void cleanExpired() {
    final expiredKeys = <String>[];
    _cache.forEach((key, entry) {
      if (entry.isExpired) {
        expiredKeys.add(key);
      }
    });
    for (final key in expiredKeys) {
      _cache.remove(key);
    }
  }

  /// For testing purposes only: resets the singleton instance.
  static void resetInstance() {
    _instance._cache.clear();
  }
}
