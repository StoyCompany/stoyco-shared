import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stoyco_shared/cache/models/cache_entry.dart';
import 'package:stoyco_shared/cache/persistent_cache_manager.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/news/models/new_model.dart';

void main() {
  group('PersistentCacheManager', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('stoyco_cache_test_');
    });

    test('persists and restores NewModel cache entry', () async {
      final manager1 = PersistentCacheManager(directoryPath: tempDir.path);
      manager1.registerDecoder<NewModel>(
          'NewModel', (json) => NewModel.fromJson(json));

      final model = NewModel(id: '1', title: 'Hello');
      final entry = CacheEntry<Either<Failure, NewModel>>(
        data: Right(model),
        ttl: const Duration(minutes: 5),
      );

      manager1.set('news_1', entry);

      // Recreate manager simulating app restart.
      final manager2 = PersistentCacheManager(directoryPath: tempDir.path);
      manager2.registerDecoder<NewModel>(
          'NewModel', (json) => NewModel.fromJson(json));

      final restored = manager2.get<dynamic>('news_1');
      expect(restored, isNotNull);
      expect(restored!.isValid, isTrue);
      final either = restored.data;
      expect(either, isA<Right>());
      expect(either.isRight, isTrue);
      final restoredModel = (either as Right).right as NewModel;
      expect(restoredModel, equals(model));
    });

    test('expired entry is not returned', () async {
      final manager = PersistentCacheManager(directoryPath: tempDir.path);
      manager.registerDecoder<NewModel>(
          'NewModel', (json) => NewModel.fromJson(json));
      final model = NewModel(id: '2', title: 'Expired');
      final entry = CacheEntry<Either<Failure, NewModel>>(
        data: Right(model),
        ttl: const Duration(milliseconds: 10),
      );
      manager.set('news_expired', entry);
      // Wait > ttl
      await Future.delayed(const Duration(milliseconds: 25));
      final restored = manager.get<dynamic>('news_expired');
      expect(restored, isNull);
    });

    test('invalidate removes entry', () async {
      final manager = PersistentCacheManager(directoryPath: tempDir.path);
      manager.registerDecoder<NewModel>(
          'NewModel', (json) => NewModel.fromJson(json));
      final model = NewModel(id: '3', title: 'Invalidate');
      final entry = CacheEntry<Either<Failure, NewModel>>(
        data: Right(model),
        ttl: const Duration(minutes: 1),
      );
      manager.set('news_invalidate', entry);
      expect(manager.containsKey('news_invalidate'), isTrue);
      final removed = manager.invalidate('news_invalidate');
      expect(removed, isTrue);
      expect(manager.get<dynamic>('news_invalidate'), isNull);
    });
  });
}
