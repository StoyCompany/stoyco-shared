import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stoyco_shared/cache/in_memory_cache_manager.dart';
import 'package:stoyco_shared/news/models/new_model.dart';
import 'package:stoyco_shared/news/news_data_source.dart';
import 'package:stoyco_shared/news/news_repository.dart';

import 'news_repository_test.mocks.dart';

@GenerateMocks([NewsDataSource])
void main() {
  late MockNewsDataSource mockDataSource;
  late NewsRepository repository;

  setUp(() {
    // Reset cache before each test
    InMemoryCacheManager.resetInstance();
    mockDataSource = MockNewsDataSource();
    repository = NewsRepository(newsDataSource: mockDataSource);
  });

  Response _createResponse(dynamic data) => Response(
        data: data,
        requestOptions: RequestOptions(path: '/'),
        statusCode: 200,
      );

  group('getNewsPaginated', () {
    test('should return PageResult on success', () async {
      final mockData = {
        'Items': [
          {
            'id': 'news1',
            'title': 'Test News',
            'mainImage': 'https://image.url',
            'images': [],
            'content': 'Test body',
            'shortDescription': 'Test description',
            'isDraft': false,
            'isPublished': true,
            'isDeleted': false,
            'viewCount': 0,
            'scheduledPublishDate': null,
            'draftCreationDate': '2025-11-17T00:00:00',
            'lastUpdatedDate': '2025-11-17T00:00:00',
            'deletionDate': null,
            'cronJobId': null,
            'createdBy': 'user1',
            'createdAt': '2025-11-17T00:00:00',
            'communityOwnerId': 'owner1',
            'hasAccess': true,
            'accessContent': null,
          }
        ],
        'PageNumber': 1,
        'PageSize': 10,
        'TotalItems': 1,
        'TotalPages': 1,
      };

      when(mockDataSource.getPaged(
        pageNumber: 1,
        pageSize: 10,
        communityOwnerId: null,
      )).thenAnswer((_) async => _createResponse(mockData));

      final result = await repository.getNewsPaginated(1, 10);

      expect(result.isRight, true);
    });

    test('should return DioFailure on DioException', () async {
      when(mockDataSource.getPaged(
        pageNumber: 1,
        pageSize: 10,
        communityOwnerId: null,
      )).thenThrow(DioException(requestOptions: RequestOptions(path: '/')));

      final result = await repository.getNewsPaginated(1, 10);
      expect(result.isLeft, true);
    });
  });

  group('getNewsById', () {
    test('should return NewModel on success', () async {
      final mockData = {
        'id': 'news1',
        'title': 'Test News',
        'mainImage': 'https://image.url',
        'images': [],
        'content': 'Test body',
        'shortDescription': 'Test description',
        'isDraft': false,
        'isPublished': true,
        'isDeleted': false,
        'viewCount': 0,
        'scheduledPublishDate': null,
        'draftCreationDate': '2025-11-17T00:00:00',
        'lastUpdatedDate': '2025-11-17T00:00:00',
        'deletionDate': null,
        'cronJobId': null,
        'createdBy': 'user1',
        'createdAt': '2025-11-17T00:00:00',
        'communityOwnerId': 'owner1',
        'hasAccess': true,
        'accessContent': null,
      };

      when(mockDataSource.getById('news1'))
          .thenAnswer((_) async => _createResponse(mockData));

      final result = await repository.getNewsById('news1');

      expect(result.isRight, true);
    });

    test('should return DioFailure on DioException', () async {
      when(mockDataSource.getById('news1'))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));

      final result = await repository.getNewsById('news1');
      expect(result.isLeft, true);
    });
  });

  group('Cache behavior', () {
    test('should cache getNewsPaginated results', () async {
      final mockData = {
        'Items': [
          {
            'id': 'news1',
            'title': 'Test News',
            'mainImage': 'https://image.url',
            'images': [],
            'content': 'Test body',
            'shortDescription': 'Test description',
            'isDraft': false,
            'isPublished': true,
            'isDeleted': false,
            'viewCount': 0,
            'scheduledPublishDate': null,
            'draftCreationDate': '2025-11-17T00:00:00',
            'lastUpdatedDate': '2025-11-17T00:00:00',
            'deletionDate': null,
            'cronJobId': null,
            'createdBy': 'user1',
            'createdAt': '2025-11-17T00:00:00',
            'communityOwnerId': 'owner1',
            'hasAccess': true,
            'accessContent': null,
          }
        ],
        'PageNumber': 1,
        'PageSize': 10,
        'TotalItems': 1,
        'TotalPages': 1,
      };

      when(mockDataSource.getPaged(
        pageNumber: 1,
        pageSize: 10,
        communityOwnerId: null,
      )).thenAnswer((_) async => _createResponse(mockData));

      // First call - should hit data source
      await repository.getNewsPaginated(1, 10);

      // Second call - should use cache (data source only called once)
      await repository.getNewsPaginated(1, 10);

      // Verify data source was only called once
      verify(mockDataSource.getPaged(
        pageNumber: 1,
        pageSize: 10,
        communityOwnerId: null,
      )).called(1);
    });

    test('should cache getNewsById results', () async {
      final mockData = {
        'id': 'news1',
        'title': 'Test News',
        'mainImage': 'https://image.url',
        'images': [],
        'content': 'Test body',
        'shortDescription': 'Test description',
        'isDraft': false,
        'isPublished': true,
        'isDeleted': false,
        'viewCount': 0,
        'scheduledPublishDate': null,
        'draftCreationDate': '2025-11-17T00:00:00',
        'lastUpdatedDate': '2025-11-17T00:00:00',
        'deletionDate': null,
        'cronJobId': null,
        'createdBy': 'user1',
        'createdAt': '2025-11-17T00:00:00',
        'communityOwnerId': 'owner1',
        'hasAccess': true,
        'accessContent': null,
      };

      when(mockDataSource.getById('news1'))
          .thenAnswer((_) async => _createResponse(mockData));

      // First call
      await repository.getNewsById('news1');

      // Second call - should use cache
      await repository.getNewsById('news1');

      // Verify data source was only called once
      verify(mockDataSource.getById('news1')).called(1);
    });

    test('should cache getNewsPaginatedWithSearchTerm results', () async {
      final mockData = {
        'Items': [
          {
            'id': 'news1',
            'title': 'Search Result',
            'mainImage': 'https://image.url',
            'images': [],
            'content': 'Test body',
            'shortDescription': 'Test description',
            'isDraft': false,
            'isPublished': true,
            'isDeleted': false,
            'viewCount': 0,
            'scheduledPublishDate': null,
            'draftCreationDate': '2025-11-17T00:00:00',
            'lastUpdatedDate': '2025-11-17T00:00:00',
            'deletionDate': null,
            'cronJobId': null,
            'createdBy': 'user1',
            'createdAt': '2025-11-17T00:00:00',
            'communityOwnerId': 'owner1',
            'hasAccess': true,
            'accessContent': null,
          }
        ],
        'PageNumber': 1,
        'PageSize': 10,
        'TotalItems': 1,
        'TotalPages': 1,
      };

      when(mockDataSource.getPaged(
        pageNumber: 1,
        pageSize: 10,
        searchTerm: 'test',
      )).thenAnswer((_) async => _createResponse(mockData));

      // First call
      await repository.getNewsPaginatedWithSearchTerm(1, 10, 'test');

      // Second call - should use cache
      await repository.getNewsPaginatedWithSearchTerm(1, 10, 'test');

      // Verify data source was only called once
      verify(mockDataSource.getPaged(
        pageNumber: 1,
        pageSize: 10,
        searchTerm: 'test',
      )).called(1);
    });

    test('should not cache error results', () async {
      when(mockDataSource.getById('error'))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));

      // First call - should fail
      await repository.getNewsById('error');

      // Second call - should try again (not cached)
      await repository.getNewsById('error');

      // Verify data source was called twice (errors not cached)
      verify(mockDataSource.getById('error')).called(2);
    });

    test('should invalidate cache for specific news item', () async {
      final mockData = {
        'id': 'news1',
        'title': 'Test News',
        'mainImage': 'https://image.url',
        'images': [],
        'content': 'Test body',
        'shortDescription': 'Test description',
        'isDraft': false,
        'isPublished': true,
        'isDeleted': false,
        'viewCount': 0,
        'scheduledPublishDate': null,
        'draftCreationDate': '2025-11-17T00:00:00',
        'lastUpdatedDate': '2025-11-17T00:00:00',
        'deletionDate': null,
        'cronJobId': null,
        'createdBy': 'user1',
        'createdAt': '2025-11-17T00:00:00',
        'communityOwnerId': 'owner1',
        'hasAccess': true,
        'accessContent': null,
      };

      when(mockDataSource.getById('news1'))
          .thenAnswer((_) async => _createResponse(mockData));

      // First call - cache it
      await repository.getNewsById('news1');

      // Invalidate cache
      repository.invalidateCache('news_by_id_news1');

      // Second call - should hit data source again
      await repository.getNewsById('news1');

      // Verify data source was called twice
      verify(mockDataSource.getById('news1')).called(2);
    });
  });
}
