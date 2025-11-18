import 'dart:convert';
import 'dart:io';

import '../utils/logger.dart';
import 'cache_manager.dart';
import 'models/cache_entry.dart';
import 'package:either_dart/either.dart';
import '../errors/error_handling/failure/failure.dart';

/// A file-backed persistent implementation of [CacheManager].
///
/// Stores successful `Either<Failure, T>` results on disk so they survive
/// app restarts. Only RIGHT (successful) values are persisted; failures are
/// never written.
///
/// Domain objects must expose a `toJson()` method and a matching registered
/// decoder to be reconstructed when the cache is reloaded.
/// Register decoders using [registerDecoder] before calling [get] for a type.
/// If a decoder is missing for a stored entry, that entry is skipped.
///
/// Persistence format (JSON):
/// ```json
/// {
///   "entries": {
///     "key": {
///       "timestamp": "2025-11-17T12:34:56.000Z",
///       "ttlMs": 600000,
///       "type": "NewModel",
///       "value": { /* domain object json */ }
///     }
///   }
/// }
/// ```
///
/// Usage:
/// ```dart
/// final cache = PersistentCacheManager(directoryPath: appSupportDir.path);
/// cache.registerDecoder<NewModel>('NewModel', (json) => NewModel.fromJson(json));
/// // Use via RepositoryCacheMixin by assigning repository.cacheManager = cache;
/// ```
class PersistentCacheManager implements CacheManager {
  /// Creates a new persistent cache manager.
  ///
  /// [directoryPath] should be a writable location (e.g. application support).
  /// A file named [fileName] (default: `stoyco_cache.json`) will be used.
  PersistentCacheManager({
    required String directoryPath,
    String fileName = 'stoyco_cache.json',
  }) : _file = File(_resolveFilePath(directoryPath, fileName)) {
    _ensureReady();
    _loadFromDisk();
  }

  static String _resolveFilePath(String dir, String fileName) {
    final directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return '${directory.path}${directory.path.endsWith('/') ? '' : '/'}$fileName';
  }

  final File _file;

  /// In-memory representation of persisted entries.
  final Map<String, _StoredEntry> _entries = {};

  /// Registered decoders keyed by runtime type name.
  /// Each decoder receives the stored JSON map and returns the domain object.
  final Map<String, dynamic Function(Map<String, dynamic>)> _decoders = {};

  void _ensureReady() {
    try {
      if (!_file.existsSync()) {
        _file.writeAsStringSync(jsonEncode({'entries': {}}));
      }
    } catch (e, s) {
      StoyCoLogger.error('PersistentCacheManager init error',
          error: e, stackTrace: s);
    }
  }

  /// Registers a decoder for a runtime type name.
  /// Call this before attempting to read cached entries for that type.
  void registerDecoder<T>(
      String typeName, T Function(Map<String, dynamic>) decoder) {
    _decoders[typeName] = (map) => decoder(map);
  }

  void _loadFromDisk() {
    try {
      final content = _file.readAsStringSync();
      if (content.isEmpty) return;
      final Map<String, dynamic> jsonMap =
          jsonDecode(content) as Map<String, dynamic>;
      final rawEntries = (jsonMap['entries'] as Map?) ?? {};
      for (final entry in rawEntries.entries) {
        final data = entry.value as Map<String, dynamic>;
        final ts = DateTime.tryParse(data['timestamp'] as String? ?? '');
        final ttlMs = (data['ttlMs'] as num?)?.toInt();
        final typeName = data['type'] as String?;
        final valueJson = data['value'] as Map<String, dynamic>?;
        if (ts == null ||
            ttlMs == null ||
            typeName == null ||
            valueJson == null) continue;
        _entries[entry.key] = _StoredEntry(
          timestamp: ts,
          ttl: Duration(milliseconds: ttlMs),
          typeName: typeName,
          valueJson: valueJson,
        );
      }
    } catch (e, s) {
      StoyCoLogger.error('PersistentCacheManager load error',
          error: e, stackTrace: s);
    }
  }

  void _persist() {
    try {
      final map = <String, dynamic>{
        'entries': _entries.map((key, value) => MapEntry(key, value.toMap())),
      };
      _file.writeAsStringSync(jsonEncode(map));
    } catch (e, s) {
      StoyCoLogger.error('PersistentCacheManager persist error',
          error: e, stackTrace: s);
    }
  }

  @override
  CacheEntry<T>? get<T>(String key) {
    final stored = _entries[key];
    if (stored == null) return null;
    if (stored.isExpired) {
      invalidate(key);
      return null;
    }
    final decoder = _decoders[stored.typeName];
    // Prefer original in-memory object when available (same session)
    if (stored.original != null) {
      final either = Right<Failure, dynamic>(stored.original);
      final entry = CacheEntry<Either<Failure, dynamic>>(
        data: either,
        ttl: stored.ttl,
        timestamp: stored.timestamp,
      );
      return entry as CacheEntry<T>;
    }
    if (decoder == null) return null; // cannot reconstruct after restart
    try {
      final domainObj = decoder(stored.valueJson);
      final either = Right<Failure, dynamic>(domainObj);
      final entry = CacheEntry<Either<Failure, dynamic>>(
        data: either,
        ttl: stored.ttl,
        timestamp: stored.timestamp,
      );
      return entry as CacheEntry<T>;
    } catch (e, s) {
      StoyCoLogger.error('PersistentCacheManager decode error',
          error: e, stackTrace: s);
      return null;
    }
  }

  @override
  void set<T>(String key, CacheEntry<T> entry) {
    // Only persist successful Either values.
    final data = entry.data;
    if (data is Either && data.isRight) {
      final right = data.right;
      Map<String, dynamic>? jsonValue;
      try {
        final dynamic maybeJson = (right as dynamic).toJson();
        if (maybeJson is Map<String, dynamic>) {
          jsonValue = maybeJson;
        }
      } catch (_) {
        // Not serializable; skip persistence to disk but still keep in memory.
      }
      _entries[key] = _StoredEntry(
        timestamp: entry.timestamp,
        ttl: entry.ttl,
        typeName: right.runtimeType.toString(),
        valueJson: jsonValue ?? <String, dynamic>{},
        original: right,
      );
      if (jsonValue != null) {
        _persist();
      }
    }
  }

  @override
  bool invalidate(String key) {
    final removed = _entries.remove(key) != null;
    if (removed) _persist();
    return removed;
  }

  @override
  void clear() {
    _entries.clear();
    _persist();
  }

  @override
  bool containsKey(String key) => _entries.containsKey(key);

  @override
  int get length => _entries.length;

  @override
  Iterable<String> get keys => _entries.keys;
}

class _StoredEntry {
  _StoredEntry({
    required this.timestamp,
    required this.ttl,
    required this.typeName,
    required this.valueJson,
    this.original,
  });
  final DateTime timestamp;
  final Duration ttl;
  final String typeName;
  final Map<String, dynamic> valueJson;
  final Object? original; // non-serialized in-memory copy

  bool get isExpired => DateTime.now().difference(timestamp) > ttl;

  Map<String, dynamic> toMap() => {
        'timestamp': timestamp.toIso8601String(),
        'ttlMs': ttl.inMilliseconds,
        'type': typeName,
        'value': valueJson,
      };
}
