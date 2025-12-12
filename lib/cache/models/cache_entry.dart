/// A generic cache entry that wraps cached data with metadata.
///
/// Stores data with a timestamp and Time-To-Live (TTL) to determine
/// when the cached data should expire.
///
/// Example:
/// ```dart
/// final entry = CacheEntry<String>(
///   data: 'cached value',
///   ttl: Duration(minutes: 5),
/// );
///
/// if (!entry.isExpired) {
///   print(entry.data);
/// }
/// ```
class CacheEntry<T> {
  /// Creates a new cache entry.
  ///
  /// The [data] is the value to cache.
  /// The [ttl] defines how long the data is valid.
  /// The [timestamp] defaults to now if not provided.
  CacheEntry({
    required this.data,
    required this.ttl,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// The cached data.
  final T data;

  /// Time-To-Live: how long this entry is valid.
  final Duration ttl;

  /// When this entry was created/cached.
  final DateTime timestamp;

  /// Whether this cache entry has expired based on TTL.
  bool get isExpired {
    final now = DateTime.now();
    return now.difference(timestamp) > ttl;
  }

  /// Whether this cache entry is still valid.
  bool get isValid => !isExpired;
}
