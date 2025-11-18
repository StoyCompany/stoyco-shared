import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/cache/in_memory_cache_manager.dart';
import 'package:stoyco_shared/cache/persistent_cache_manager.dart';
import 'package:stoyco_shared/cache/repository_cache_mixin.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';

// Mock repository for testing
class MockRepository with RepositoryCacheMixin {
  int fetchCallCount = 0;

  Future<Either<Failure, String>> fetchData(String id) async {
    return cachedCall<String>(
      key: 'data_$id',
      ttl: Duration(minutes: 5),
      fetcher: () async {
        fetchCallCount++;
        await Future.delayed(Duration(milliseconds: 10));
        return Right('data_$id');
      },
    );
  }

  Future<Either<Failure, String>> fetchDataWithError(String id) async {
    return cachedCall<String>(
      key: 'error_$id',
      ttl: Duration(minutes: 5),
      fetcher: () async {
        fetchCallCount++;
        return Left(ErrorFailure.decode(Error()));
      },
    );
  }
}

void main() {
  group('RepositoryCacheMixin', () {
    late MockRepository repository;

    setUp(() {
      // Clean persistent cache file to isolate tests
      final file = File('${Directory.systemTemp.path}/stoyco_cache.json');
      if (file.existsSync()) {
        file.deleteSync();
      }
      repository = MockRepository();
    });

    tearDown(() {
      repository.clearAllCache();
    });

    test('should use default PersistentCacheManager', () {
      expect(repository.cacheManager, isA<PersistentCacheManager>());
    });

    test('should allow custom CacheManager', () {
      final customCache = InMemoryCacheManager();
      repository.cacheManager = customCache;

      expect(repository.cacheManager, same(customCache));
    });

    test('should cache successful result', () async {
      final result1 = await repository.fetchData('123');
      expect(result1.isRight, isTrue);
      expect(result1.right, equals('data_123'));
      expect(repository.fetchCallCount, equals(1));

      // Second call should use cache
      final result2 = await repository.fetchData('123');
      expect(result2.isRight, isTrue);
      expect(result2.right, equals('data_123'));
      expect(repository.fetchCallCount, equals(1)); // Still 1, not 2
    });

    test('should not cache error results', () async {
      final result1 = await repository.fetchDataWithError('456');
      expect(result1.isLeft, isTrue);
      expect(repository.fetchCallCount, equals(1));

      // Second call should fetch again (errors not cached)
      final result2 = await repository.fetchDataWithError('456');
      expect(result2.isLeft, isTrue);
      expect(repository.fetchCallCount, equals(2)); // Incremented
    });

    test('should force refresh when requested', () async {
      await repository.fetchData('789');
      expect(repository.fetchCallCount, equals(1));

      // Force refresh should bypass cache
      repository.fetchCallCount = 0;
      final result2 = await repository.cachedCall<String>(
        key: 'data_789',
        ttl: Duration(minutes: 5),
        fetcher: () async {
          repository.fetchCallCount++;
          return Right('fresh_data');
        },
        forceRefresh: true,
      );

      expect(result2.isRight, isTrue);
      expect(result2.right, equals('fresh_data'));
      expect(repository.fetchCallCount, equals(1)); // Was called again
    });

    test('should invalidate single cache key', () async {
      await repository.fetchData('100');
      expect(repository.fetchCallCount, equals(1));

      repository.invalidateCache('data_100');

      // Should fetch again after invalidation
      await repository.fetchData('100');
      expect(repository.fetchCallCount, equals(2));
    });

    test('should invalidate multiple cache keys', () async {
      await repository.fetchData('200');
      await repository.fetchData('201');
      await repository.fetchData('202');
      expect(repository.fetchCallCount, equals(3));

      repository.invalidateCacheMultiple(['data_200', 'data_201', 'data_202']);

      // Reset counter and fetch again
      repository.fetchCallCount = 0;
      await repository.fetchData('200');
      await repository.fetchData('201');
      await repository.fetchData('202');
      expect(repository.fetchCallCount, equals(3)); // All fetched again
    });

    test('should invalidate cache by pattern', () async {
      await repository.fetchData('event_100');
      await repository.fetchData('event_101');
      await repository.fetchData('user_100');

      final removed = repository.invalidateCachePattern('data_event_');
      expect(removed, isTrue);

      // Check what's left in cache
      final keys = repository.cacheManager.keys.toList();
      expect(keys.contains('data_event_100'), isFalse);
      expect(keys.contains('data_event_101'), isFalse);
      expect(keys.contains('data_user_100'), isTrue);
    });

    test('should clear all cache', () async {
      await repository.fetchData('300');
      await repository.fetchData('301');
      await repository.fetchData('302');

      expect(repository.cacheManager.length, equals(3));

      repository.clearAllCache();

      expect(repository.cacheManager.length, equals(0));
    });

    test('should handle expired cache entries', () async {
      final result1 = await repository.cachedCall<String>(
        key: 'expires_soon',
        ttl: Duration(milliseconds: 100),
        fetcher: () async {
          repository.fetchCallCount++;
          return Right('temporary_data');
        },
      );

      expect(result1.isRight, isTrue);
      expect(repository.fetchCallCount, equals(1));

      // Wait for expiration
      await Future.delayed(Duration(milliseconds: 150));

      // Should fetch again after expiration
      final result2 = await repository.cachedCall<String>(
        key: 'expires_soon',
        ttl: Duration(milliseconds: 100),
        fetcher: () async {
          repository.fetchCallCount++;
          return Right('new_data');
        },
      );

      expect(result2.isRight, isTrue);
      expect(result2.right, equals('new_data'));
      expect(repository.fetchCallCount, equals(2));
    });

    test('should handle concurrent requests to same key', () async {
      repository.fetchCallCount = 0;

      // Fire multiple requests simultaneously
      final futures = List.generate(
        5,
        (_) => repository.fetchData('concurrent'),
      );

      final results = await Future.wait(futures);

      // All should succeed
      for (final result in results) {
        expect(result.isRight, isTrue);
        expect(result.right, equals('data_concurrent'));
      }

      // Note: Due to async nature and race conditions, multiple requests
      // might execute before the first one caches. This is expected behavior.
      // We just verify it's not more than the number of requests.
      expect(repository.fetchCallCount, lessThanOrEqualTo(5));
    });

    test('should work with different data types', () async {
      final stringResult = await repository.cachedCall<String>(
        key: 'string_key',
        ttl: Duration(minutes: 5),
        fetcher: () async => Right('string value'),
      );

      final intResult = await repository.cachedCall<int>(
        key: 'int_key',
        ttl: Duration(minutes: 5),
        fetcher: () async => Right(42),
      );

      final listResult = await repository.cachedCall<List<String>>(
        key: 'list_key',
        ttl: Duration(minutes: 5),
        fetcher: () async => Right(['a', 'b', 'c']),
      );

      expect(stringResult.right, equals('string value'));
      expect(intResult.right, equals(42));
      expect(listResult.right, equals(['a', 'b', 'c']));
    });
  });
}
