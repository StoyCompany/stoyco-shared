import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/cache/repository_cache_mixin.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';

/// Example showing how to use the caching system in a repository.
///
/// This example demonstrates the typical pattern for implementing
/// caching in a repository that follows the DataSource -> Repository pattern.

// Example DataSource (simplified)
class EventDataSource {
  Future<Event> getEventId(String eventId) async {
    // Simulates API call
    await Future.delayed(Duration(milliseconds: 500));
    return Event(id: eventId, name: 'Sample Event');
  }

  Future<List<Event>> getTopEvents() async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      Event(id: '1', name: 'Event 1'),
      Event(id: '2', name: 'Event 2'),
    ];
  }

  Future<bool> participateInEvent(String eventId, String userId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return true;
  }
}

// Example model
class Event {
  Event({required this.id, required this.name});
  final String id;
  final String name;
}

/// Repository implementation WITH caching using [RepositoryCacheMixin].
///
/// Key features:
/// - Mix in [RepositoryCacheMixin] to add caching capabilities
/// - Use [cachedCall] for any method that should cache results
/// - Specify TTL per method based on data volatility
/// - Invalidate cache when data changes (e.g., after mutations)
class EventRepositoryImpl with RepositoryCacheMixin {
  EventRepositoryImpl(this._eventDs);
  final EventDataSource _eventDs;

  /// Fetches a single event with 5-minute cache.
  ///
  /// The first call will hit the API, subsequent calls within 5 minutes
  /// will return the cached result.
  Future<Either<Failure, Event>> getEventId(String eventId) async {
    return cachedCall<Event>(
      key: 'event_$eventId',
      ttl: Duration(minutes: 5),
      fetcher: () async {
        try {
          final event = await _eventDs.getEventId(eventId);
          return Right(event);
        } on DioException catch (error) {
          return Left(DioFailure.decode(error));
        }
      },
    );
  }

  /// Fetches top events with 2-minute cache.
  ///
  /// Lists of data typically change more frequently, so use shorter TTL.
  Future<Either<Failure, List<Event>>> getTopEvents() async {
    return cachedCall<List<Event>>(
      key: 'top_events',
      ttl: Duration(minutes: 2),
      fetcher: () async {
        try {
          final events = await _eventDs.getTopEvents();
          return Right(events);
        } on DioException catch (error) {
          return Left(DioFailure.decode(error));
        }
      },
    );
  }

  /// Force refresh example: bypass cache and get fresh data.
  Future<Either<Failure, Event>> refreshEvent(String eventId) async {
    return cachedCall<Event>(
      key: 'event_$eventId',
      ttl: Duration(minutes: 5),
      forceRefresh: true, // Bypass cache
      fetcher: () async {
        try {
          final event = await _eventDs.getEventId(eventId);
          return Right(event);
        } on DioException catch (error) {
          return Left(DioFailure.decode(error));
        }
      },
    );
  }

  /// Mutation example: invalidate related caches after changes.
  Future<Either<Failure, bool>> participateInEvent(
    String eventId,
    String userId,
  ) async {
    try {
      final result = await _eventDs.participateInEvent(eventId, userId);

      // After successful mutation, invalidate related caches
      if (result) {
        invalidateCache('event_$eventId'); // Single event might have changed
        invalidateCache('top_events'); // List might need refresh
        invalidateCachePattern('user_${userId}_'); // All user-related caches
      }

      return Right(result);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    }
  }

  /// Example of clearing all event-related caches.
  void clearEventCaches() {
    invalidateCachePattern('event_');
    invalidateCache('top_events');
  }
}

// Usage examples
void main() async {
  final dataSource = EventDataSource();
  final repository = EventRepositoryImpl(dataSource);

  // First call: fetches from API (500ms)
  print('First call...');
  final result1 = await repository.getEventId('123');
  print('Got result: ${result1.right.name}');

  // Second call: returns cached result (instant)
  print('Second call (cached)...');
  final result2 = await repository.getEventId('123');
  print('Got result: ${result2.right.name}');

  // Force refresh: bypasses cache
  print('Force refresh...');
  final result3 = await repository.refreshEvent('123');
  print('Got result: ${result3.right.name}');

  // After mutation, cache is invalidated
  await repository.participateInEvent('123', 'user456');
  print('Cache invalidated after participation');

  // Next call will fetch fresh data
  final result4 = await repository.getEventId('123');
  print('Got fresh result: ${result4.right.name}');
}
