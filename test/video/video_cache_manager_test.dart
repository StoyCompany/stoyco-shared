import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/video/cache/video_cache_manager.dart';
import 'package:stoyco_shared/video/video_with_metada/video_with_metadata.dart';

void main() {
  group('VideoCacheManager', () {
    late VideoCacheManager cacheManager;

    setUp(() async {
      // Initialize with short TTL for testing
      cacheManager = await VideoCacheManager.initialize(
        ttl: 5, // 5 seconds
        maxCacheSize: 10,
      );
    });

    tearDown(() async {
      await cacheManager.clear();
      await cacheManager.close();
    });

    test('should initialize singleton instance', () {
      expect(VideoCacheManager.instance, isNotNull);
      expect(VideoCacheManager.instance, equals(cacheManager));
    });

    test('should store and retrieve videos from cache', () async {
      final videos = [
        VideoWithMetadata(id: 'video1'),
        VideoWithMetadata(id: 'video2'),
      ];

      await cacheManager.put('test_key', videos);
      final cached = await cacheManager.get('test_key');

      expect(cached, isNotNull);
      expect(cached!.length, equals(2));
      expect(cached[0].id, equals('video1'));
      expect(cached[1].id, equals('video2'));
    });

    test('should return null for non-existent key', () async {
      final cached = await cacheManager.get('non_existent');
      expect(cached, isNull);
    });

    test('should deduplicate videos by ID', () async {
      final videos1 = [
        VideoWithMetadata(id: 'video1'),
        VideoWithMetadata(id: 'video2'),
      ];

      final videos2 = [
        VideoWithMetadata(id: 'video2'), // Duplicate
        VideoWithMetadata(id: 'video3'),
      ];

      await cacheManager.put('key1', videos1);
      await cacheManager.put('key2', videos2);

      final cached2 = await cacheManager.get('key2');

      // video2 should be filtered out, only video3 should be added
      expect(cached2, isNotNull);
      expect(cached2!.length, equals(1));
      expect(cached2[0].id, equals('video3'));
    });

    test('should remove cache entry', () async {
      final videos = [VideoWithMetadata(id: 'video1')];

      await cacheManager.put('test_key', videos);
      expect(await cacheManager.get('test_key'), isNotNull);

      await cacheManager.remove('test_key');
      expect(await cacheManager.get('test_key'), isNull);
    });

    test('should clear all cache', () async {
      await cacheManager.put('key1', [VideoWithMetadata(id: 'video1')]);
      await cacheManager.put('key2', [VideoWithMetadata(id: 'video2')]);

      await cacheManager.clear();

      expect(await cacheManager.get('key1'), isNull);
      expect(await cacheManager.get('key2'), isNull);
    });

    test('should clear cache by prefix', () async {
      await cacheManager
          .put('Featured:Music:null:user1:1:10', [VideoWithMetadata(id: 'v1')]);
      await cacheManager
          .put('Featured:Music:null:user1:2:10', [VideoWithMetadata(id: 'v2')]);
      await cacheManager
          .put('ForYou:Sport:null:user1:1:10', [VideoWithMetadata(id: 'v3')]);

      await cacheManager.clearByPrefix('Featured:Music:');

      expect(await cacheManager.get('Featured:Music:null:user1:1:10'), isNull);
      expect(await cacheManager.get('Featured:Music:null:user1:2:10'), isNull);
      expect(
        await cacheManager.get('ForYou:Sport:null:user1:1:10'),
        isNotNull,
      ); // Should remain
    });

    test('should expire cache after TTL', () async {
      final videos = [VideoWithMetadata(id: 'video1')];

      await cacheManager.put('test_key', videos);
      expect(await cacheManager.get('test_key'), isNotNull);

      // Wait for TTL to expire (5 seconds + buffer)
      await Future.delayed(const Duration(seconds: 6));

      expect(await cacheManager.get('test_key'), isNull);
    });

    test('should handle empty video lists', () async {
      await cacheManager.put('empty_key', []);

      final cached = await cacheManager.get('empty_key');
      expect(cached, isNotNull);
      expect(cached!.isEmpty, isTrue);
    });

    test('should handle videos without IDs gracefully', () async {
      final videos = [
        VideoWithMetadata(id: 'video1'),
        VideoWithMetadata(), // No ID
        VideoWithMetadata(id: 'video3'),
      ];

      await cacheManager.put('test_key', videos);
      final cached = await cacheManager.get('test_key');

      expect(cached, isNotNull);
      // Videos without IDs should still be stored
      expect(cached!.length, equals(3));
    });
  });
}
