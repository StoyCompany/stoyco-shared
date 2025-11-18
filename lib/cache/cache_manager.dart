import 'models/cache_entry.dart';

/// Abstract cache manager that defines the contract for caching implementations.
///
/// Provides basic operations for storing, retrieving, and invalidating cached data.
/// Implementations can use in-memory storage, shared preferences, secure storage, etc.
///
/// Example implementation:
/// ```dart
/// class MyCache extends CacheManager {
///   final Map<String, CacheEntry> _cache = {};
///
///   @override
///   CacheEntry<T>? get<T>(String key) => _cache[key] as CacheEntry<T>?;
///
///   @override
///   void set<T>(String key, CacheEntry<T> entry) => _cache[key] = entry;
/// }
/// ```
abstract class CacheManager {
  /// Retrieves a cached entry by key.
  ///
  /// Returns null if the key doesn't exist or the entry has expired.
  CacheEntry<T>? get<T>(String key);

  /// Stores a cache entry with the given key.
  ///
  /// If the key already exists, it will be overwritten.
  void set<T>(String key, CacheEntry<T> entry);

  /// Removes a specific cache entry by key.
  ///
  /// Returns true if the entry was removed, false if it didn't exist.
  bool invalidate(String key);

  /// Removes all cache entries.
  void clear();

  /// Checks if a key exists in the cache (regardless of expiration).
  bool containsKey(String key);

  /// Returns the number of cached entries.
  int get length;

  /// Returns all cache keys.
  Iterable<String> get keys;
}
