import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:stoyco_shared/video/cache/video_cache_manager.dart';
import 'package:stoyco_shared/video/video_with_metada/video_with_metadata.dart';

/// Tests for partner following status updates in video cache
void main() {
  group('VideoCacheManager Partner Following Tests', () {
    late VideoCacheManager cacheManager;
    late Directory tempDir;

    setUpAll(() async {
      // Create a temporary directory for Hive
      tempDir = await Directory.systemTemp.createTemp('partner_follow_test_');
      Hive.init(tempDir.path);
    });

    setUp(() async {
      // Initialize cache manager
      await VideoCacheManager.initialize(
        ttl: 300,
        maxCacheSize: 100,
      );
      cacheManager = VideoCacheManager.instance!;
    });

    tearDown(() async {
      await VideoCacheManager.resetInstance();
    });

    tearDownAll(() async {
      await Hive.close();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('should update followingCO for all videos from a partner', () async {
      // Create test videos from different partners
      final video1 = VideoWithMetadata(
        id: 'video1',
        partnerId: 'partner123',
        name: 'Video 1',
        followingCO: false,
      );

      final video2 = VideoWithMetadata(
        id: 'video2',
        partnerId: 'partner123',
        name: 'Video 2',
        followingCO: false,
      );

      final video3 = VideoWithMetadata(
        id: 'video3',
        partnerId: 'partner456',
        name: 'Video 3',
        followingCO: false,
      );

      // Cache the videos
      await cacheManager.put('key1', [video1, video2]);
      await cacheManager.put('key2', [video3]);

      // Update partner123 following status to true
      await cacheManager.updatePartnerFollowingStatus('partner123', true);

      // Verify videos from partner123 have followingCO = true
      final cachedVideos1 = await cacheManager.get('key1');
      expect(cachedVideos1, isNotNull);
      expect(cachedVideos1!.length, 2);
      expect(cachedVideos1[0].followingCO, true);
      expect(cachedVideos1[1].followingCO, true);

      // Verify videos from other partners remain unchanged
      final cachedVideos2 = await cacheManager.get('key2');
      expect(cachedVideos2, isNotNull);
      expect(cachedVideos2!.length, 1);
      expect(cachedVideos2[0].followingCO, false);
    });

    test('should update followingCO to false when unfollowing', () async {
      final video1 = VideoWithMetadata(
        id: 'video1',
        partnerId: 'partner123',
        name: 'Video 1',
        followingCO: true, // Initially following
      );

      await cacheManager.put('key1', [video1]);

      // Unfollow the partner
      await cacheManager.updatePartnerFollowingStatus('partner123', false);

      // Verify followingCO is now false
      final cachedVideos = await cacheManager.get('key1');
      expect(cachedVideos, isNotNull);
      expect(cachedVideos!.length, 1);
      expect(cachedVideos[0].followingCO, false);
    });

    test('should update followingCO across multiple cache entries', () async {
      // Create videos in different cache entries (different pages)
      final page1Videos = [
        VideoWithMetadata(
          id: 'video1',
          partnerId: 'partner123',
          followingCO: false,
        ),
        VideoWithMetadata(
          id: 'video2',
          partnerId: 'partner123',
          followingCO: false,
        ),
      ];

      final page2Videos = [
        VideoWithMetadata(
          id: 'video3',
          partnerId: 'partner123',
          followingCO: false,
        ),
        VideoWithMetadata(
          id: 'video4',
          partnerId: 'partner456', // Different partner
          followingCO: false,
        ),
      ];

      await cacheManager.put('Featured:null:null:user1:1:10', page1Videos);
      await cacheManager.put('Featured:null:null:user1:2:10', page2Videos);

      // Follow partner123
      await cacheManager.updatePartnerFollowingStatus('partner123', true);

      // Verify all videos from partner123 are updated across both pages
      final cached1 = await cacheManager.get('Featured:null:null:user1:1:10');
      expect(cached1![0].followingCO, true);
      expect(cached1[1].followingCO, true);

      final cached2 = await cacheManager.get('Featured:null:null:user1:2:10');
      expect(cached2![0].followingCO, true); // partner123 video
      expect(cached2[1].followingCO, false); // partner456 video unchanged
    });

    test('should handle cache with no videos from the partner', () async {
      final video1 = VideoWithMetadata(
        id: 'video1',
        partnerId: 'partner456',
        followingCO: false,
      );

      await cacheManager.put('key1', [video1]);

      // Update different partner - should not affect cached video
      await cacheManager.updatePartnerFollowingStatus('partner123', true);

      final cachedVideos = await cacheManager.get('key1');
      expect(cachedVideos, isNotNull);
      expect(cachedVideos![0].followingCO, false); // Unchanged
    });

    test('should persist followingCO updates to disk cache', () async {
      final video1 = VideoWithMetadata(
        id: 'video1',
        partnerId: 'partner123',
        followingCO: false,
      );

      await cacheManager.put('key1', [video1]);

      // Update following status
      await cacheManager.updatePartnerFollowingStatus('partner123', true);

      // Clear memory cache to force read from disk
      await VideoCacheManager.resetInstance();
      await VideoCacheManager.initialize(ttl: 300, maxCacheSize: 100);
      final newManager = VideoCacheManager.instance!;

      // Verify the update persisted to disk
      final cachedVideos = await newManager.get('key1');
      expect(cachedVideos, isNotNull);
      expect(cachedVideos![0].followingCO, true);
    });
  });
}
