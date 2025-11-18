import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stoyco_shared/cache/in_memory_cache_manager.dart';
import 'package:stoyco_shared/partner/models/market_segment_model.dart';
import 'package:stoyco_shared/partner/models/partner_community_response.dart';
import 'package:stoyco_shared/partner/models/partner_follow_check_response.dart';
import 'package:stoyco_shared/partner/partner_data_source.dart';
import 'package:stoyco_shared/partner/partner_repository.dart';

import 'partner_repository_test.mocks.dart';

@GenerateMocks([PartnerDataSource])
void main() {
  late MockPartnerDataSource mockDataSource;
  late PartnerRepository repository;

  setUp(() {
    // Reset cache before each test
    InMemoryCacheManager.resetInstance();
    mockDataSource = MockPartnerDataSource();
    repository = PartnerRepository(partnerDataSource: mockDataSource);
  });

  Response _createResponse(dynamic data) => Response(
        data: data,
        requestOptions: RequestOptions(path: '/'),
        statusCode: 200,
      );

  group('getPartnerCommunityById', () {
    test('should return PartnerCommunityResponse on success', () async {
      final mockData = {
        'Partner': {
          'Id': '690bd75ed53b645941ae9f7c',
          'Profile': 'Music',
          'CommunityId': '690bd75ed53b645941ae9f7e',
          'Name': 'Grupo Poder',
          'Description': 'Grupo de musica con sabor',
          'MusicalGenre': 'Regional Mexicano',
          'Category': 'Requeton',
          'City': 'Bogota',
          'Country': 'Colombia',
          'CountryFlag': 'https://flagicons.lipis.dev/flags/4x3/mx.svg',
          'FrontImage': 'https://example.com/front.jpg',
          'BannerImage': 'https://example.com/banner.jpg',
          'AdditionalImages': [],
          'SocialNetworkStatistic': {
            'id': '001',
            'Name': 'Co-Cre8',
            'Photo': 'https://example.com/photo.jpg'
          },
          'SocialNetwork': [
            {
              'Name': 'URL Web',
              'Url': 'https://web.stoyco.io/',
              'KeyChartMetric': null,
              'Followers': 0
            }
          ],
          'NumberEvents': 0,
          'NumberProducts': 0,
          'CreatedDate': '2025-11-05T18:01:50.663000',
          'Active': true,
          'CollectionId': '488304050497',
          'HandleShopify': 'stoyco-2',
          'PartnerUrl': '',
          'FollowersCount': 10,
          'Order': 0,
          'CoLines': '681c3e92181ac22e220f552a',
          'CoTypes': '68373325772fc6dce3ce0384',
          'MainMarketSegment': '683615c72b494351e141dfc5',
          'SecondaryMarketSegments': ['683616722b494351e141dfd1']
        },
        'Community': {
          'Id': '690bd75ed53b645941ae9f7e',
          'EventId': null,
          'PartnerId': '690bd75ed53b645941ae9f7c',
          'PartnerName': 'Grupo Poder',
          'PartnerType': 'Music',
          'Name': 'Grupo Poderes',
          'NumberOfEvents': null,
          'NumberOfProducts': null,
          'Category': [],
          'NumberOfMembers': 0,
          'BonusMoneyPerUser': '0',
          'CommunityFund': '0',
          'CommunityFundGoal': false,
          'PublishedDate': '2025-11-05T18:01:46.159377',
          'CreatedDate': '2025-11-05T18:01:46.159377',
          'UpdatedDate': '2025-11-05T18:01:46.159377',
          'FullFunds': false,
          'NumberOfProjects': 0,
          'SeshUrl': ''
        }
      };

      when(mockDataSource.getPartnerCommunityById(any))
          .thenAnswer((_) async => _createResponse(mockData));

      final result =
          await repository.getPartnerCommunityById('690bd75ed53b645941ae9f7c');

      expect(result.isRight, true);
      final response = result.right;
      expect(response, isA<PartnerCommunityResponse>());
      expect(response.partner.name, 'Grupo Poder');
      expect(response.community.name, 'Grupo Poderes');
    });

    test('should return DioFailure on DioException', () async {
      when(mockDataSource.getPartnerCommunityById(any))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));

      final result =
          await repository.getPartnerCommunityById('690bd75ed53b645941ae9f7c');

      expect(result.isLeft, true);
    });

    test('should return ErrorFailure on Error thrown', () async {
      when(mockDataSource.getPartnerCommunityById(any))
          .thenThrow(StateError('Test error'));

      final result =
          await repository.getPartnerCommunityById('690bd75ed53b645941ae9f7c');

      expect(result.isLeft, true);
    });

    test('should return ExceptionFailure on Exception thrown', () async {
      when(mockDataSource.getPartnerCommunityById(any))
          .thenThrow(Exception('Test exception'));

      final result =
          await repository.getPartnerCommunityById('690bd75ed53b645941ae9f7c');

      expect(result.isLeft, true);
    });
  });

  group('getMarketSegments', () {
    test('should return list of MarketSegmentModel on success', () async {
      final mockData = [
        {'id': '681c3f57181ac22e220f552e', 'name': 'Pop'},
        {'id': '683615c72b494351e141dfc5', 'name': 'Regional Mexicano'},
        {'id': '683616722b494351e141dfd1', 'name': 'Trap Latino'},
      ];

      when(mockDataSource.getMarketSegments())
          .thenAnswer((_) async => _createResponse(mockData));

      final result = await repository.getMarketSegments();

      expect(result.isRight, true);
      final segments = result.right;
      expect(segments, isA<List<MarketSegmentModel>>());
      expect(segments.length, 3);
      expect(segments[0].name, 'Pop');
      expect(segments[1].name, 'Regional Mexicano');
      expect(segments[2].name, 'Trap Latino');
    });

    test('should return DioFailure on DioException', () async {
      when(mockDataSource.getMarketSegments())
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));

      final result = await repository.getMarketSegments();

      expect(result.isLeft, true);
    });

    test('should return ErrorFailure on Error thrown', () async {
      when(mockDataSource.getMarketSegments())
          .thenThrow(StateError('Test error'));

      final result = await repository.getMarketSegments();

      expect(result.isLeft, true);
    });

    test('should return ExceptionFailure on Exception thrown', () async {
      when(mockDataSource.getMarketSegments())
          .thenThrow(Exception('Test exception'));

      final result = await repository.getMarketSegments();

      expect(result.isLeft, true);
    });
  });

  group('checkPartnerFollow', () {
    test('should return PartnerFollowCheckResponse on success', () async {
      final mockData = {
        'error': -1,
        'messageError': '',
        'tecMessageError': '',
        'count': -1,
        'data': true,
      };

      when(mockDataSource.checkPartnerFollow(
        userId: 'user123',
        partnerId: 'partner456',
      )).thenAnswer((_) async => _createResponse(mockData));

      final result = await repository.checkPartnerFollow(
        userId: 'user123',
        partnerId: 'partner456',
      );

      expect(result.isRight, true);
      final followCheck = result.right;
      expect(followCheck.isFollowing, true);
      expect(followCheck.data, true);
      expect(followCheck.error, -1);
      expect(followCheck.messageError, '');
      expect(followCheck.tecMessageError, '');
      expect(followCheck.count, -1);
    });

    test('should return PartnerFollowCheckResponse when not following',
        () async {
      final mockData = {
        'error': -1,
        'messageError': '',
        'tecMessageError': '',
        'count': -1,
        'data': false,
      };

      when(mockDataSource.checkPartnerFollow(
        userId: 'user123',
        partnerId: 'partner456',
      )).thenAnswer((_) async => _createResponse(mockData));

      final result = await repository.checkPartnerFollow(
        userId: 'user123',
        partnerId: 'partner456',
      );

      expect(result.isRight, true);
      final followCheck = result.right;
      expect(followCheck.isFollowing, false);
      expect(followCheck.data, false);
      expect(followCheck.error, -1);
      expect(followCheck.messageError, '');
      expect(followCheck.tecMessageError, '');
      expect(followCheck.count, -1);
    });

    test('should return DioFailure on DioException', () async {
      when(mockDataSource.checkPartnerFollow(
        userId: 'user123',
        partnerId: 'partner456',
      )).thenThrow(DioException(requestOptions: RequestOptions(path: '/')));

      final result = await repository.checkPartnerFollow(
        userId: 'user123',
        partnerId: 'partner456',
      );

      expect(result.isLeft, true);
    });

    test('should return ErrorFailure on Error thrown', () async {
      when(mockDataSource.checkPartnerFollow(
        userId: 'user123',
        partnerId: 'partner456',
      )).thenThrow(StateError('Test error'));

      final result = await repository.checkPartnerFollow(
        userId: 'user123',
        partnerId: 'partner456',
      );

      expect(result.isLeft, true);
    });

    test('should return ExceptionFailure on Exception thrown', () async {
      when(mockDataSource.checkPartnerFollow(
        userId: 'user123',
        partnerId: 'partner456',
      )).thenThrow(Exception('Test exception'));

      final result = await repository.checkPartnerFollow(
        userId: 'user123',
        partnerId: 'partner456',
      );

      expect(result.isLeft, true);
    });
  });

  group('getPartnerContentAvailability', () {
    test('should return PartnerContentAvailabilityResponse on success',
        () async {
      final mockData = {
        'error': -1,
        'messageError': '',
        'tecMessageError': '',
        'count': 1,
        'data': {
          'partnerId': '66f5bd918d77fca522545f01',
          'news': false,
          'announcements': false,
          'eventsFree': false,
          'otherEvents': false,
          'videos': false,
          'nfts': true,
          'products': false,
        }
      };

      when(mockDataSource
              .getPartnerContentAvailability('66f5bd918d77fca522545f01'))
          .thenAnswer((_) async => _createResponse(mockData));

      final result = await repository
          .getPartnerContentAvailability('66f5bd918d77fca522545f01');

      expect(result.isRight, true);
      final availability = result.right;
      expect(availability.data.partnerId, '66f5bd918d77fca522545f01');
      expect(availability.data.nfts, true);
      expect(availability.data.hasAnyContent, true); // because nfts true
      expect(availability.error, -1);
    });

    test('should return DioFailure on DioException', () async {
      when(mockDataSource.getPartnerContentAvailability('any'))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));

      final result = await repository.getPartnerContentAvailability('any');
      expect(result.isLeft, true);
    });

    test('should return ErrorFailure on Error thrown', () async {
      when(mockDataSource.getPartnerContentAvailability('any'))
          .thenThrow(StateError('Test error'));

      final result = await repository.getPartnerContentAvailability('any');
      expect(result.isLeft, true);
    });

    test('should return ExceptionFailure on Exception thrown', () async {
      when(mockDataSource.getPartnerContentAvailability('any'))
          .thenThrow(Exception('Test exception'));

      final result = await repository.getPartnerContentAvailability('any');
      expect(result.isLeft, true);
    });
  });

  group('Cache behavior', () {
    test('should cache getPartnerCommunityById results', () async {
      final mockData = {
        'Partner': {
          'Id': 'test123',
          'Profile': 'Music',
          'CommunityId': 'comm123',
          'Name': 'Test Partner',
          'Description': 'Test description',
          'MusicalGenre': 'Pop',
          'Category': 'Music',
          'City': 'Test City',
          'Country': 'Test Country',
          'CountryFlag': 'https://flag.url',
          'FrontImage': 'https://front.url',
          'BannerImage': 'https://banner.url',
          'AdditionalImages': [],
          'SocialNetworkStatistic': {
            'id': '001',
            'Name': 'Test',
            'Photo': 'https://photo.url'
          },
          'SocialNetwork': [],
          'NumberEvents': 0,
          'NumberProducts': 0,
          'CreatedDate': '2025-11-17T00:00:00',
          'Active': true,
          'CollectionId': '123',
          'HandleShopify': 'test',
          'PartnerUrl': '',
          'FollowersCount': 0,
          'Order': 0,
          'CoLines': 'test',
          'CoTypes': 'test',
          'MainMarketSegment': 'test',
          'SecondaryMarketSegments': []
        },
        'Community': {
          'Id': 'comm123',
          'EventId': null,
          'PartnerId': 'test123',
          'PartnerName': 'Test Partner',
          'PartnerType': 'Music',
          'Name': 'Test Community',
          'NumberOfEvents': null,
          'NumberOfProducts': null,
          'Category': [],
          'NumberOfMembers': 0,
          'BonusMoneyPerUser': '0',
          'CommunityFund': '0',
          'CommunityFundGoal': false,
          'PublishedDate': '2025-11-17T00:00:00',
          'CreatedDate': '2025-11-17T00:00:00',
          'UpdatedDate': '2025-11-17T00:00:00',
          'FullFunds': false,
          'NumberOfProjects': 0,
          'SeshUrl': ''
        }
      };

      when(mockDataSource.getPartnerCommunityById('test123'))
          .thenAnswer((_) async => _createResponse(mockData));

      // First call - should hit data source
      await repository.getPartnerCommunityById('test123');

      // Second call - should use cache (data source only called once)
      await repository.getPartnerCommunityById('test123');

      // Verify data source was only called once
      verify(mockDataSource.getPartnerCommunityById('test123')).called(1);
    });

    test('should cache getMarketSegments results', () async {
      final mockData = [
        {'id': '1', 'name': 'Segment 1'},
        {'id': '2', 'name': 'Segment 2'},
      ];

      when(mockDataSource.getMarketSegments())
          .thenAnswer((_) async => _createResponse(mockData));

      // First call
      await repository.getMarketSegments();

      // Second call - should use cache
      await repository.getMarketSegments();

      // Verify data source was only called once
      verify(mockDataSource.getMarketSegments()).called(1);
    });

    test('should cache checkPartnerFollow results', () async {
      final mockData = {
        'error': -1,
        'messageError': '',
        'tecMessageError': '',
        'count': -1,
        'data': true,
      };

      when(mockDataSource.checkPartnerFollow(
        userId: 'user1',
        partnerId: 'partner1',
      )).thenAnswer((_) async => _createResponse(mockData));

      // First call
      await repository.checkPartnerFollow(
        userId: 'user1',
        partnerId: 'partner1',
      );

      // Second call - should use cache
      await repository.checkPartnerFollow(
        userId: 'user1',
        partnerId: 'partner1',
      );

      // Verify data source was only called once
      verify(mockDataSource.checkPartnerFollow(
        userId: 'user1',
        partnerId: 'partner1',
      )).called(1);
    });

    test('should cache getPartnerContentAvailability results', () async {
      final mockData = {
        'error': -1,
        'messageError': '',
        'tecMessageError': '',
        'count': 1,
        'data': {
          'partnerId': 'partner1',
          'news': true,
          'announcements': false,
          'eventsFree': true,
          'otherEvents': false,
          'videos': true,
          'nfts': false,
          'products': true,
        }
      };

      when(mockDataSource.getPartnerContentAvailability('partner1'))
          .thenAnswer((_) async => _createResponse(mockData));

      // First call
      await repository.getPartnerContentAvailability('partner1');

      // Second call - should use cache
      await repository.getPartnerContentAvailability('partner1');

      // Verify data source was only called once
      verify(mockDataSource.getPartnerContentAvailability('partner1'))
          .called(1);
    });

    test('should not cache error results', () async {
      when(mockDataSource.getPartnerCommunityById('error'))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));

      // First call - should fail
      await repository.getPartnerCommunityById('error');

      // Second call - should try again (not cached)
      await repository.getPartnerCommunityById('error');

      // Verify data source was called twice (errors not cached)
      verify(mockDataSource.getPartnerCommunityById('error')).called(2);
    });
  });
}
