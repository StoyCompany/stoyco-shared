import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/cache/models/cache_entry.dart';

void main() {
  group('CacheEntry', () {
    test('should create cache entry with current timestamp', () {
      final entry = CacheEntry<String>(
        data: 'test data',
        ttl: Duration(minutes: 5),
      );

      expect(entry.data, equals('test data'));
      expect(entry.ttl, equals(Duration(minutes: 5)));
      expect(entry.timestamp, isNotNull);
      expect(entry.isValid, isTrue);
      expect(entry.isExpired, isFalse);
    });

    test('should create cache entry with custom timestamp', () {
      final customTime = DateTime.now().subtract(Duration(minutes: 3));
      final entry = CacheEntry<int>(
        data: 42,
        ttl: Duration(minutes: 5),
        timestamp: customTime,
      );

      expect(entry.timestamp, equals(customTime));
      expect(entry.isValid, isTrue);
    });

    test('should detect expired cache entry', () {
      final expiredTime = DateTime.now().subtract(Duration(minutes: 10));
      final entry = CacheEntry<String>(
        data: 'expired data',
        ttl: Duration(minutes: 5),
        timestamp: expiredTime,
      );

      expect(entry.isExpired, isTrue);
      expect(entry.isValid, isFalse);
    });

    test('should handle edge case: entry at exact TTL boundary', () async {
      final entry = CacheEntry<String>(
        data: 'boundary test',
        ttl: Duration(milliseconds: 100),
      );

      expect(entry.isValid, isTrue);

      // Wait for TTL to expire
      await Future.delayed(Duration(milliseconds: 150));

      expect(entry.isExpired, isTrue);
      expect(entry.isValid, isFalse);
    });

    test('should work with different data types', () {
      final stringEntry = CacheEntry<String>(
        data: 'string',
        ttl: Duration(minutes: 1),
      );
      final intEntry = CacheEntry<int>(
        data: 123,
        ttl: Duration(minutes: 1),
      );
      final listEntry = CacheEntry<List<String>>(
        data: ['a', 'b', 'c'],
        ttl: Duration(minutes: 1),
      );

      expect(stringEntry.data, isA<String>());
      expect(intEntry.data, isA<int>());
      expect(listEntry.data, isA<List<String>>());
    });
  });
}
