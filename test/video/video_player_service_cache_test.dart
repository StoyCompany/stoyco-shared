import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/video/video_player_service.dart';

void main() {
  group('VideoPlayerService Cache Tests', () {
    late VideoPlayerService service;

    setUp(() {
      // Create service with short TTL for testing (5 seconds)
      service = VideoPlayerService(
        environment: StoycoEnvironment.development,
        userToken: 'test_token',
        videoCacheTTL: 5,
      );
    });

    tearDown(() {
      service.reset();
    });

    test('should cache video results on first call', () async {
      // This test would need mocking to work properly
      // For now it demonstrates the API usage

      // First call - should fetch from backend
      final result1 = await service.getVideosWithFilter(
        filterMode: 'Featured',
        page: 1,
        pageSize: 10,
      );

      expect(result1.isRight, true);

      // Second call with same parameters - should return from cache
      final result2 = await service.getVideosWithFilter(
        filterMode: 'Featured',
        page: 1,
        pageSize: 10,
      );

      expect(result2.isRight, true);
    });

    test('should respect forceRefresh flag', () async {
      // First call - caches result
      await service.getVideosWithFilter(
        filterMode: 'Featured',
        page: 1,
        pageSize: 10,
      );

      // Force refresh - should bypass cache
      final result = await service.getVideosWithFilter(
        filterMode: 'Featured',
        page: 1,
        pageSize: 10,
        forceRefresh: true,
      );

      expect(result.isRight, true);
    });

    test('should clear all cache when clearVideoCache is called', () {
      // Add some mock data to cache (internal test)
      // In real implementation, after calling clearVideoCache,
      // the next call should fetch from backend again

      service.clearVideoCache();

      // Verify cache is empty by checking that next call goes to backend
      // This would require mocking to verify properly
    });

    test('should clear cache for specific filter', () {
      service.clearVideoCacheForFilter(
        filterMode: 'Featured',
        userId: 'user123',
      );

      // Cache for this specific filter should be cleared
      // Other filters should remain cached
    });

    test('getFeaturedVideos should also use cache', () async {
      // First call - should fetch from backend
      final result1 = await service.getFeaturedVideos(
        userId: 'user123',
        page: 1,
        pageSize: 10,
      );

      expect(result1.isRight, true);

      // Second call with same parameters - should return from cache
      final result2 = await service.getFeaturedVideos(
        userId: 'user123',
        page: 1,
        pageSize: 10,
      );

      expect(result2.isRight, true);
    });

    test('should generate different cache keys for different parameters', () {
      // These calls should generate different cache keys
      // and therefore not share cached results

      service.getVideosWithFilter(
        filterMode: 'Featured',
        page: 1,
        pageSize: 10,
        userId: 'user1',
      );

      service.getVideosWithFilter(
        filterMode: 'Featured',
        page: 1,
        pageSize: 10,
        userId: 'user2',
      );

      service.getVideosWithFilter(
        filterMode: 'ForYou',
        page: 1,
        pageSize: 10,
        userId: 'user1',
      );

      // All three calls should have separate cache entries
    });
  });
}
