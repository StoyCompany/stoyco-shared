import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/cache/in_memory_cache_manager.dart';
import 'package:stoyco_shared/cache/models/cache_entry.dart';

void main() {
  group('InMemoryCacheManager', () {
    late InMemoryCacheManager cacheManager;

    setUp(() {
      InMemoryCacheManager.resetInstance();
      cacheManager = InMemoryCacheManager();
    });

    tearDown(() {
      InMemoryCacheManager.resetInstance();
    });

    test('should return singleton instance', () {
      final instance1 = InMemoryCacheManager();
      final instance2 = InMemoryCacheManager();

      expect(instance1, same(instance2));
    });

    test('should store and retrieve cache entry', () {
      final entry = CacheEntry<String>(
        data: 'test value',
        ttl: Duration(minutes: 5),
      );

      cacheManager.set('test_key', entry);
      final retrieved = cacheManager.get<String>('test_key');

      expect(retrieved, isNotNull);
      expect(retrieved!.data, equals('test value'));
    });

    test('should return null for non-existent key', () {
      final retrieved = cacheManager.get<String>('non_existent');

      expect(retrieved, isNull);
    });

    test('should auto-remove expired entries on get', () async {
      final entry = CacheEntry<String>(
        data: 'short lived',
        ttl: Duration(milliseconds: 100),
      );

      cacheManager.set('expiring_key', entry);
      expect(cacheManager.containsKey('expiring_key'), isTrue);

      // Wait for expiration
      await Future.delayed(Duration(milliseconds: 150));

      final retrieved = cacheManager.get<String>('expiring_key');
      expect(retrieved, isNull);
      expect(cacheManager.containsKey('expiring_key'), isFalse);
    });

    test('should invalidate specific key', () {
      final entry = CacheEntry<String>(
        data: 'to be removed',
        ttl: Duration(minutes: 5),
      );

      cacheManager.set('remove_me', entry);
      expect(cacheManager.containsKey('remove_me'), isTrue);

      final removed = cacheManager.invalidate('remove_me');
      expect(removed, isTrue);
      expect(cacheManager.containsKey('remove_me'), isFalse);
    });

    test('should return false when invalidating non-existent key', () {
      final removed = cacheManager.invalidate('does_not_exist');
      expect(removed, isFalse);
    });

    test('should clear all cache entries', () {
      cacheManager.set(
          'key1', CacheEntry(data: 'value1', ttl: Duration(minutes: 5)));
      cacheManager.set(
          'key2', CacheEntry(data: 'value2', ttl: Duration(minutes: 5)));
      cacheManager.set(
          'key3', CacheEntry(data: 'value3', ttl: Duration(minutes: 5)));

      expect(cacheManager.length, equals(3));

      cacheManager.clear();
      expect(cacheManager.length, equals(0));
    });

    test('should report correct length', () {
      expect(cacheManager.length, equals(0));

      cacheManager.set(
          'key1', CacheEntry(data: 'value1', ttl: Duration(minutes: 5)));
      expect(cacheManager.length, equals(1));

      cacheManager.set(
          'key2', CacheEntry(data: 'value2', ttl: Duration(minutes: 5)));
      expect(cacheManager.length, equals(2));

      cacheManager.invalidate('key1');
      expect(cacheManager.length, equals(1));
    });

    test('should check if key exists', () {
      expect(cacheManager.containsKey('test'), isFalse);

      cacheManager.set(
          'test', CacheEntry(data: 'value', ttl: Duration(minutes: 5)));
      expect(cacheManager.containsKey('test'), isTrue);
    });

    test('should return all keys', () {
      cacheManager.set(
          'key1', CacheEntry(data: 'value1', ttl: Duration(minutes: 5)));
      cacheManager.set(
          'key2', CacheEntry(data: 'value2', ttl: Duration(minutes: 5)));
      cacheManager.set(
          'key3', CacheEntry(data: 'value3', ttl: Duration(minutes: 5)));

      final keys = cacheManager.keys.toList();
      expect(keys, containsAll(['key1', 'key2', 'key3']));
      expect(keys.length, equals(3));
    });

    test('should clean expired entries', () async {
      // Add mix of short-lived and long-lived entries
      cacheManager.set(
        'short1',
        CacheEntry(data: 'expires soon', ttl: Duration(milliseconds: 100)),
      );
      cacheManager.set(
        'short2',
        CacheEntry(data: 'also expires', ttl: Duration(milliseconds: 100)),
      );
      cacheManager.set(
        'long',
        CacheEntry(data: 'stays', ttl: Duration(minutes: 10)),
      );

      expect(cacheManager.length, equals(3));

      // Wait for short entries to expire
      await Future.delayed(Duration(milliseconds: 150));

      cacheManager.cleanExpired();

      expect(cacheManager.length, equals(1));
      expect(cacheManager.containsKey('long'), isTrue);
      expect(cacheManager.containsKey('short1'), isFalse);
      expect(cacheManager.containsKey('short2'), isFalse);
    });

    test('should handle different data types', () {
      cacheManager.set(
          'string', CacheEntry(data: 'text', ttl: Duration(minutes: 5)));
      cacheManager.set('int', CacheEntry(data: 42, ttl: Duration(minutes: 5)));
      cacheManager.set(
          'list', CacheEntry(data: [1, 2, 3], ttl: Duration(minutes: 5)));
      cacheManager.set(
          'map', CacheEntry(data: {'key': 'value'}, ttl: Duration(minutes: 5)));

      expect(cacheManager.get<String>('string')!.data, equals('text'));
      expect(cacheManager.get<int>('int')!.data, equals(42));
      expect(cacheManager.get<List<int>>('list')!.data, equals([1, 2, 3]));
      expect(cacheManager.get<Map<String, String>>('map')!.data,
          equals({'key': 'value'}));
    });

    test('should overwrite existing key', () {
      cacheManager.set(
          'key', CacheEntry(data: 'first', ttl: Duration(minutes: 5)));
      expect(cacheManager.get<String>('key')!.data, equals('first'));

      cacheManager.set(
          'key', CacheEntry(data: 'second', ttl: Duration(minutes: 5)));
      expect(cacheManager.get<String>('key')!.data, equals('second'));
      expect(cacheManager.length, equals(1));
    });
  });
}
