import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/cache/cache_utils.dart';
import 'package:stoyco_shared/cache/persistent_cache_manager.dart';
import 'package:stoyco_shared/cache/in_memory_cache_manager.dart';
import 'package:stoyco_shared/cache/global_cache_manager.dart';
import 'package:stoyco_shared/cache/models/cache_entry.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'dart:io';

void main() {
  group('CacheUtils', () {
    late Directory tempDir1;
    late Directory tempDir2;

    setUp(() {
      GlobalCacheManager.resetForTesting();
      InMemoryCacheManager.resetInstance();
      tempDir1 = Directory.systemTemp.createTempSync('cache_test_1_');
      tempDir2 = Directory.systemTemp.createTempSync('cache_test_2_');
    });

    tearDown(() {
      GlobalCacheManager.resetForTesting();
      InMemoryCacheManager.resetInstance();
      if (tempDir1.existsSync()) tempDir1.deleteSync(recursive: true);
      if (tempDir2.existsSync()) tempDir2.deleteSync(recursive: true);
    });

    test('should clear all caches using CacheUtils', () {
      final cache1 = PersistentCacheManager(directoryPath: tempDir1.path);
      final cache2 = InMemoryCacheManager();

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

      CacheUtils.clearAllCaches();

      expect(cache1.containsKey('key1'), false);
      expect(cache2.containsKey('key2'), false);

      cache1.dispose();
    });

    test('should invalidate key globally using CacheUtils', () {
      final cache1 = PersistentCacheManager(directoryPath: tempDir1.path);
      final cache2 = PersistentCacheManager(directoryPath: tempDir2.path);

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

      final count = CacheUtils.invalidateKey('shared_key');

      expect(count, 2);
      expect(cache1.containsKey('shared_key'), false);
      expect(cache2.containsKey('shared_key'), false);

      cache1.dispose();
      cache2.dispose();
    });

    test('should invalidate pattern globally using CacheUtils', () {
      final cache1 = PersistentCacheManager(directoryPath: tempDir1.path);
      final cache2 = InMemoryCacheManager();

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

      final count = CacheUtils.invalidatePattern('news_');

      expect(count, 3);
      expect(cache1.containsKey('news_1'), false);
      expect(cache1.containsKey('news_2'), false);
      expect(cache1.containsKey('event_1'), true);
      expect(cache2.containsKey('news_3'), false);
      expect(cache2.containsKey('user_1'), true);

      cache1.dispose();
    });

    test('should return correct registered cache count', () {
      expect(CacheUtils.registeredCacheCount, 0);

      final cache1 = PersistentCacheManager(directoryPath: tempDir1.path);
      expect(CacheUtils.registeredCacheCount, 1);

      final cache2 = InMemoryCacheManager();
      expect(CacheUtils.registeredCacheCount, 2);

      cache1.dispose();
      cache2.dispose();
      expect(CacheUtils.registeredCacheCount, 0);
    });

    test('should work from any layer of the application', () {
      // Simulate repository layer
      final cache1 = PersistentCacheManager(directoryPath: tempDir1.path);
      cache1.set(
          'user_123',
          CacheEntry(
              data: Right<Failure, String>('John'), ttl: Duration(minutes: 5)));

      // Simulate service layer
      final cache2 = InMemoryCacheManager();
      cache2.set(
          'session_token',
          CacheEntry(
              data: Right<Failure, String>('token123'),
              ttl: Duration(minutes: 30)));

      expect(cache1.containsKey('user_123'), true);
      expect(cache2.containsKey('session_token'), true);

      // Simulate UI layer calling CacheUtils on logout
      CacheUtils.clearAllCaches();

      expect(cache1.containsKey('user_123'), false);
      expect(cache2.containsKey('session_token'), false);

      cache1.dispose();
    });
  });
}
