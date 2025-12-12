import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/cache/repository_cache_mixin.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';

/// Example showing how to convert an existing repository to use caching.
///
/// This demonstrates the minimal changes needed to add caching to your repository.

// Example DTO (from your code)
class ParticipateInCampaignDto {
  final String eventId;
  final String userId;

  ParticipateInCampaignDto({
    required this.eventId,
    required this.userId,
  });
}

// Example models
class Event {
  final String id;
  final String name;
  final bool isFree;

  Event({required this.id, required this.name, this.isFree = true});
}

// Example DataSource interface (simplified)
abstract class EventDataSource {
  Future<List<Event>> getTopEvent();
  Future<Event> getEventId(String eventId);
  Future<bool> participateInFreeEvent(ParticipateInCampaignDto dto);
  Future<bool> isParticipatingInFreeEvent(String eventId, String userId);
}

// Mock implementation for example purposes
class EventDataSourceImpl implements EventDataSource {
  @override
  Future<List<Event>> getTopEvent() async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      Event(id: '1', name: 'Top Event 1'),
      Event(id: '2', name: 'Top Event 2'),
    ];
  }

  @override
  Future<Event> getEventId(String eventId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return Event(id: eventId, name: 'Event $eventId');
  }

  @override
  Future<bool> participateInFreeEvent(ParticipateInCampaignDto dto) async {
    await Future.delayed(Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> isParticipatingInFreeEvent(String eventId, String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return false;
  }
}

// Example abstract repository interface
abstract class EventRepository {
  Future<Either<Failure, List<Event>>> getTopEvent();
  Future<Either<Failure, Event>> getEventId(String eventId);
  Future<Either<Failure, bool>> participateInFreeEvent(
    ParticipateInCampaignDto participateInCampaignDto,
  );
  Future<Either<Failure, bool>> isParticipatingInFreeEvent(
    String eventId,
    String userId,
  );
}

/// ❌ BEFORE: Repository WITHOUT caching
class EventRepositoryImplWithoutCache implements EventRepository {
  EventRepositoryImplWithoutCache(this._eventDs);
  final EventDataSource _eventDs;

  @override
  Future<Either<Failure, List<Event>>> getTopEvent() async {
    try {
      final result = await _eventDs.getTopEvent();
      return Right(result);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  @override
  Future<Either<Failure, Event>> getEventId(String eventId) async {
    try {
      final result = await _eventDs.getEventId(eventId);
      return Right(result);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  @override
  Future<Either<Failure, bool>> participateInFreeEvent(
    ParticipateInCampaignDto participateInCampaignDto,
  ) async {
    try {
      final result =
          await _eventDs.participateInFreeEvent(participateInCampaignDto);
      return Right(result);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  @override
  Future<Either<Failure, bool>> isParticipatingInFreeEvent(
    String eventId,
    String userId,
  ) async {
    try {
      final result = await _eventDs.isParticipatingInFreeEvent(eventId, userId);
      return Right(result);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }
}

/// ✅ AFTER: Repository WITH caching
///
/// Changes made:
/// 1. Added `with RepositoryCacheMixin` to the class
/// 2. Wrapped read operations (GET) with `cachedCall`
/// 3. Added cache invalidation after write operations (POST/PUT/DELETE)
/// 4. No changes to the error handling logic
class EventRepositoryImplWithCache
    with RepositoryCacheMixin
    implements EventRepository {
  EventRepositoryImplWithCache(this._eventDs);
  final EventDataSource _eventDs;

  /// Read operation: Cached for 3 minutes
  /// Top events change frequently, so use shorter TTL
  @override
  Future<Either<Failure, List<Event>>> getTopEvent() async {
    return cachedCall<List<Event>>(
      key: 'top_events',
      ttl: Duration(minutes: 3),
      fetcher: () async {
        try {
          final result = await _eventDs.getTopEvent();
          return Right(result);
        } on DioException catch (error) {
          return Left(DioFailure.decode(error));
        } on Error catch (error) {
          return Left(ErrorFailure.decode(error));
        } on Exception catch (error) {
          return Left(ExceptionFailure.decode(error));
        }
      },
    );
  }

  /// Read operation: Cached for 5 minutes
  /// Individual events are more stable than lists
  @override
  Future<Either<Failure, Event>> getEventId(String eventId) async {
    return cachedCall<Event>(
      key: 'event_$eventId',
      ttl: Duration(minutes: 5),
      fetcher: () async {
        try {
          final result = await _eventDs.getEventId(eventId);
          return Right(result);
        } on DioException catch (error) {
          return Left(DioFailure.decode(error));
        } on Error catch (error) {
          return Left(ErrorFailure.decode(error));
        } on Exception catch (error) {
          return Left(ExceptionFailure.decode(error));
        }
      },
    );
  }

  /// Write operation: NOT cached, but invalidates related caches
  @override
  Future<Either<Failure, bool>> participateInFreeEvent(
    ParticipateInCampaignDto participateInCampaignDto,
  ) async {
    try {
      final result =
          await _eventDs.participateInFreeEvent(participateInCampaignDto);

      // After successful participation, invalidate related caches
      if (result) {
        invalidateCache('event_${participateInCampaignDto.eventId}');
        invalidateCache('top_events');
        invalidateCachePattern(
            'participation_${participateInCampaignDto.userId}_');
      }

      return Right(result);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  /// Read operation: Cached for 2 minutes
  /// Participation status might change, so shorter TTL
  @override
  Future<Either<Failure, bool>> isParticipatingInFreeEvent(
    String eventId,
    String userId,
  ) async {
    return cachedCall<bool>(
      key: 'participation_${userId}_$eventId',
      ttl: Duration(minutes: 2),
      fetcher: () async {
        try {
          final result =
              await _eventDs.isParticipatingInFreeEvent(eventId, userId);
          return Right(result);
        } on DioException catch (error) {
          return Left(DioFailure.decode(error));
        } on Error catch (error) {
          return Left(ErrorFailure.decode(error));
        } on Exception catch (error) {
          return Left(ExceptionFailure.decode(error));
        }
      },
    );
  }
}

// Comparison and usage example
void main() async {
  final dataSource = EventDataSourceImpl();
  final repoWithCache = EventRepositoryImplWithCache(dataSource);

  print('=== Cache Demo ===\n');

  // First call: Hits the API (500ms delay)
  print('1. First call to getEventId("123")...');
  final start1 = DateTime.now();
  final result1 = await repoWithCache.getEventId('123');
  final duration1 = DateTime.now().difference(start1);
  print('   Result: ${result1.right.name}');
  print('   Duration: ${duration1.inMilliseconds}ms (API call)\n');

  // Second call: Returns cached result (instant)
  print('2. Second call to getEventId("123")...');
  final start2 = DateTime.now();
  final result2 = await repoWithCache.getEventId('123');
  final duration2 = DateTime.now().difference(start2);
  print('   Result: ${result2.right.name}');
  print('   Duration: ${duration2.inMilliseconds}ms (from cache!)\n');

  // Mutation: Invalidates cache
  print('3. Participating in event 123...');
  await repoWithCache.participateInFreeEvent(
    ParticipateInCampaignDto(eventId: '123', userId: 'user456'),
  );
  print('   Cache invalidated for event_123\n');

  // Third call: Cache was invalidated, fetches fresh (500ms delay)
  print('4. Third call to getEventId("123") after cache invalidation...');
  final start3 = DateTime.now();
  final result3 = await repoWithCache.getEventId('123');
  final duration3 = DateTime.now().difference(start3);
  print('   Result: ${result3.right.name}');
  print('   Duration: ${duration3.inMilliseconds}ms (fresh API call)\n');

  print('=== Summary ===');
  print(
      '✅ Cached calls are ~${(duration1.inMilliseconds / duration2.inMilliseconds).toStringAsFixed(1)}x faster');
  print('✅ Cache invalidation works after mutations');
  print('✅ Zero changes to error handling logic');
}
