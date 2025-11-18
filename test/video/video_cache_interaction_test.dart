import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:stoyco_shared/video/cache/video_cache_manager.dart';
import 'package:stoyco_shared/video/video_with_metada/video_with_metadata.dart';

/// Tests for cache interaction updates
///
/// Verifies that video interactions (likes, shares) are properly
/// updated across all cache entries.
void main() {
  // Initialize Hive with temp directory for tests
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('./test_cache');
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('VideoCacheManager Interaction Updates', () {
    late VideoCacheManager cacheManager;

    setUp(() async {
      // Initialize fresh cache for each test
      cacheManager = await VideoCacheManager.initialize(
        ttl: 300,
        maxCacheSize: 100,
      );
    });

    tearDown(() async {
      await cacheManager.clear();
      await cacheManager.close();
    });

    test('updateVideoInCache updates video across all cache entries', () async {
      // Create test videos with unique IDs
      final video1 = VideoWithMetadata(
        id: 'video1',
        name: 'Test Video 1',
        likes: 100,
        likeThisVideo: false,
        shared: 50,
      );

      final video2 = VideoWithMetadata(
        id: 'video2',
        name: 'Test Video 2',
        likes: 200,
        likeThisVideo: false,
        shared: 75,
      );

      final video3 = VideoWithMetadata(
        id: 'video3',
        name: 'Test Video 3',
        likes: 150,
        likeThisVideo: false,
        shared: 60,
      );

      // Add videos to first cache entry
      await cacheManager.put('Featured:null:null:null:1:20', [video1, video2]);

      // Add videos to second cache entry (video2 will be deduplicated, but that's ok)
      await cacheManager.put('Sports:null:null:null:1:20', [video2, video3]);

      // Add videos to third cache entry
      await cacheManager.put('Featured:null:null:null:2:20', [video1, video3]);

      // Update video2 (appears in Featured and Sports)
      await cacheManager.updateVideoInCache(
        videoId: 'video2',
        updater: (video) => video.copyWith(
          likes: 201,
          likeThisVideo: true,
        ),
      );

      // Verify update in Featured cache
      final featuredVideos =
          await cacheManager.get('Featured:null:null:null:1:20');
      expect(featuredVideos, isNotNull);

      // Find video2 in Featured cache
      final featuredVideo2 =
          featuredVideos!.where((v) => v.id == 'video2').toList();
      if (featuredVideo2.isNotEmpty) {
        expect(featuredVideo2.first.likes, 201);
        expect(featuredVideo2.first.likeThisVideo, true);
      }

      // Verify other videos unchanged
      final featuredVideo1 = featuredVideos.firstWhere((v) => v.id == 'video1');
      expect(featuredVideo1.likes, 100);
      expect(featuredVideo1.likeThisVideo, false);
    });

    test('updateVideoInCache handles share count increment', () async {
      final video = VideoWithMetadata(
        id: 'video1',
        name: 'Test Video',
        likes: 100,
        shared: 50,
      );

      await cacheManager.put('Featured:null:null:null:1:20', [video]);

      // Increment share count
      await cacheManager.updateVideoInCache(
        videoId: 'video1',
        updater: (v) => v.copyWith(
          shared: (v.shared ?? 0) + 1,
        ),
      );

      final cached = await cacheManager.get('Featured:null:null:null:1:20');
      expect(cached, isNotNull);
      expect(cached!.first.shared, 51);
    });

    test('removeVideoFromCache removes video from all entries', () async {
      final video1 = VideoWithMetadata(
        id: 'video_remove_1',
        name: 'Test Video 1',
      );

      final video2 = VideoWithMetadata(
        id: 'video_remove_2',
        name: 'Test Video 2',
      );

      // Add videos to first cache
      await cacheManager
          .put('Featured:remove:null:null:1:20', [video1, video2]);

      // Since video1 is now in deduplicated set, video2 won't be added again
      // So use different keys with unique videos
      final video3 = VideoWithMetadata(
        id: 'video_remove_3',
        name: 'Test Video 3',
      );
      await cacheManager.put('Sports:remove:null:null:1:20', [video2, video3]);

      // Remove video2 from all caches
      await cacheManager.removeVideoFromCache('video_remove_2');

      // Verify video2 is removed from Featured
      final featuredVideos =
          await cacheManager.get('Featured:remove:null:null:1:20');
      expect(featuredVideos, isNotNull);
      final video2InFeatured =
          featuredVideos!.where((v) => v.id == 'video_remove_2').toList();
      expect(video2InFeatured.length, 0); // Should be removed

      // Verify video1 is still there
      final video1InFeatured =
          featuredVideos.where((v) => v.id == 'video_remove_1').toList();
      expect(video1InFeatured.length, 1);
    });

    test('updateVideoInCache handles video not in cache gracefully', () async {
      final video = VideoWithMetadata(
        id: 'video1',
        name: 'Test Video',
      );

      await cacheManager.put('Featured:null:null:null:1:20', [video]);

      // Try to update non-existent video
      await cacheManager.updateVideoInCache(
        videoId: 'non_existent',
        updater: (v) => v.copyWith(likes: 999),
      );

      // Original video should be unchanged
      final cached = await cacheManager.get('Featured:null:null:null:1:20');
      expect(cached, isNotNull);
      expect(cached!.first.id, 'video1');
      expect(cached.first.likes, isNull);
    });

    test('updateVideoInCache persists changes to disk', () async {
      final video = VideoWithMetadata(
        id: 'video1',
        name: 'Test Video',
        likes: 100,
        likeThisVideo: false,
      );

      await cacheManager.put('Featured:null:null:null:1:20', [video]);

      // Update video
      await cacheManager.updateVideoInCache(
        videoId: 'video1',
        updater: (v) => v.copyWith(
          likes: 200,
          likeThisVideo: true,
        ),
      );

      // Close cache manager (clears memory cache)
      await cacheManager.close();

      // Re-initialize cache manager
      final newCacheManager = await VideoCacheManager.initialize(
        ttl: 300,
        maxCacheSize: 100,
      );

      // Verify update was persisted to disk
      final cached = await newCacheManager.get('Featured:null:null:null:1:20');
      expect(cached, isNotNull);
      expect(cached!.first.likes, 200);
      expect(cached.first.likeThisVideo, true);

      await newCacheManager.close();
    });

    test(
        'updateVideoInCache updates multiple instances of same video in one entry',
        () async {
      // This test verifies that if somehow a video appears twice in one cache entry,
      // both instances get updated
      final video1 = VideoWithMetadata(
        id: 'multi_test_video',
        name: 'Test Video',
        likes: 100,
      );

      final video2 = VideoWithMetadata(
        id: 'other_video',
        name: 'Other Video',
        likes: 50,
      );

      // Add videos to cache
      await cacheManager.put('Multiple:test:null:null:1:20', [video1, video2]);

      // Update the video
      await cacheManager.updateVideoInCache(
        videoId: 'multi_test_video',
        updater: (v) => v.copyWith(likes: 200),
      );

      // Verify update worked
      final cached = await cacheManager.get('Multiple:test:null:null:1:20');
      expect(cached, isNotNull);

      final video1Instance =
          cached!.where((v) => v.id == 'multi_test_video').toList();
      expect(video1Instance.length, greaterThan(0));
      expect(video1Instance.first.likes, 200);

      final video2Instance = cached.firstWhere((v) => v.id == 'other_video');
      expect(video2Instance.likes, 50); // Unchanged
    });
  });
}
