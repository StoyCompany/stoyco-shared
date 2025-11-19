import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/cache/global_cache_manager.dart';
import 'package:stoyco_shared/cache/persistent_cache_manager.dart';
import 'package:stoyco_shared/cache/in_memory_cache_manager.dart';
import 'package:stoyco_shared/cache/models/cache_entry.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'dart:io';

void main() {
  group('GlobalCacheManager', () {
    late Directory tempDir1;
    late Directory tempDir2;

    setUp(() {
      GlobalCacheManager.resetForTesting();
      tempDir1 = Directory.systemTemp.createTempSync('cache_test_1_');
      tempDir2 = Directory.systemTemp.createTempSync('cache_test_2_');
    });

    tearDown(() {
      GlobalCacheManager.resetForTesting();
      if (tempDir1.existsSync()) tempDir1.deleteSync(recursive: true);
      if (tempDir2.existsSync()) tempDir2.deleteSync(recursive: true);
    });

    test('should register cache managers automatically', () {
      expect(GlobalCacheManager.registeredCacheCount, 0);

      final cache1 = PersistentCacheManager(directoryPath: tempDir1.path);
      expect(GlobalCacheManager.registeredCacheCount, 1);

      final cache2 = PersistentCacheManager(directoryPath: tempDir2.path);
      expect(GlobalCacheManager.registeredCacheCount, 2);

      cache1.dispose();
      cache2.dispose();
    });

    test('should unregister cache managers on dispose', () {
      final cache1 = PersistentCacheManager(directoryPath: tempDir1.path);
      final cache2 = PersistentCacheManager(directoryPath: tempDir2.path);

      expect(GlobalCacheManager.registeredCacheCount, 2);

      cache1.dispose();
      expect(GlobalCacheManager.registeredCacheCount, 1);

      cache2.dispose();
      expect(GlobalCacheManager.registeredCacheCount, 0);
    });

    test('should clear all caches globally', () {
      final cache1 = PersistentCacheManager(directoryPath: tempDir1.path);
      final cache2 = PersistentCacheManager(directoryPath: tempDir2.path);

      // Add data to both caches
      cache1.set(
          'key1',
          CacheEntry(
              data: Right<Failure, String>('value1'),
              ttl: Duration(minutes: 5)));
      cache2.set(
          'key2',
          CacheEntry(
              data: Right<Failure, String>('value2'),
              ttl: Duration(minutes: 5)));

      expect(cache1.containsKey('key1'), true);
      expect(cache2.containsKey('key2'), true);

      // Clear all
      GlobalCacheManager.clearAllCaches();

      expect(cache1.containsKey('key1'), false);
      expect(cache2.containsKey('key2'), false);

      cache1.dispose();
      cache2.dispose();
    });

    test('should invalidate key globally', () {
      final cache1 = PersistentCacheManager(directoryPath: tempDir1.path);
      final cache2 = PersistentCacheManager(directoryPath: tempDir2.path);

      // Add same key to both caches
      cache1.set(
          'shared_key',
          CacheEntry(
              data: Right<Failure, String>('value1'),
              ttl: Duration(minutes: 5)));
      cache2.set(
          'shared_key',
          CacheEntry(
              data: Right<Failure, String>('value2'),
              ttl: Duration(minutes: 5)));

      final count = GlobalCacheManager.invalidateKeyGlobally('shared_key');

      expect(count, 2);
      expect(cache1.containsKey('shared_key'), false);
      expect(cache2.containsKey('shared_key'), false);

      cache1.dispose();
      cache2.dispose();
    });

    test('should invalidate pattern globally', () {
      final cache1 = PersistentCacheManager(directoryPath: tempDir1.path);
      final cache2 = PersistentCacheManager(directoryPath: tempDir2.path);

      // Add keys with pattern
      cache1.set(
          'news_1',
          CacheEntry(
              data: Right<Failure, String>('news1'),
              ttl: Duration(minutes: 5)));
      cache1.set(
          'news_2',
          CacheEntry(
              data: Right<Failure, String>('news2'),
              ttl: Duration(minutes: 5)));
      cache1.set(
          'event_1',
          CacheEntry(
              data: Right<Failure, String>('event1'),
              ttl: Duration(minutes: 5)));

      cache2.set(
          'news_3',
          CacheEntry(
              data: Right<Failure, String>('news3'),
              ttl: Duration(minutes: 5)));
      cache2.set(
          'user_1',
          CacheEntry(
              data: Right<Failure, String>('user1'),
              ttl: Duration(minutes: 5)));

      final count = GlobalCacheManager.invalidatePatternGlobally('news_');

      expect(count, 3); // news_1, news_2, news_3
      expect(cache1.containsKey('news_1'), false);
      expect(cache1.containsKey('news_2'), false);
      expect(cache1.containsKey('event_1'), true);
      expect(cache2.containsKey('news_3'), false);
      expect(cache2.containsKey('user_1'), true);

      cache1.dispose();
      cache2.dispose();
    });

    test('should work with mixed cache types', () {
      final persistentCache =
          PersistentCacheManager(directoryPath: tempDir1.path);
      final memoryCache = InMemoryCacheManager();

      // Manually register in-memory cache
      GlobalCacheManager.register(memoryCache);

      expect(GlobalCacheManager.registeredCacheCount, 2);

      persistentCache.set(
          'key1',
          CacheEntry(
              data: Right<Failure, String>('value1'),
              ttl: Duration(minutes: 5)));
      memoryCache.set(
          'key2',
          CacheEntry(
              data: Right<Failure, String>('value2'),
              ttl: Duration(minutes: 5)));

      GlobalCacheManager.clearAllCaches();

      expect(persistentCache.containsKey('key1'), false);
      expect(memoryCache.containsKey('key2'), false);

      persistentCache.dispose();
      GlobalCacheManager.unregister(memoryCache);
    });

    test('should handle errors gracefully when clearing caches', () {
      final cache = PersistentCacheManager(directoryPath: tempDir1.path);
      cache.set(
          'key',
          CacheEntry(
              data: Right<Failure, String>('value'),
              ttl: Duration(minutes: 5)));

      // This should not throw even if there are issues
      expect(() => GlobalCacheManager.clearAllCaches(), returnsNormally);

      cache.dispose();
    });

    test('should return correct registered cache count', () {
      expect(GlobalCacheManager.registeredCacheCount, 0);

      final caches = <PersistentCacheManager>[];
      for (int i = 0; i < 3; i++) {
        final dir = Directory.systemTemp.createTempSync('cache_test_$i');
        caches.add(PersistentCacheManager(directoryPath: dir.path));
      }

      expect(GlobalCacheManager.registeredCacheCount, 3);

      for (final cache in caches) {
        cache.dispose();
      }

      expect(GlobalCacheManager.registeredCacheCount, 0);
    });
  });
}
