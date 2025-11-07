import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stoyco_shared/partner/models/market_segment_model.dart';
import 'package:stoyco_shared/partner/models/partner_community_response.dart';
import 'package:stoyco_shared/partner/partner_data_source.dart';
import 'package:stoyco_shared/partner/partner_repository.dart';

import 'partner_repository_test.mocks.dart';

@GenerateMocks([PartnerDataSource])
void main() {
  late MockPartnerDataSource mockDataSource;
  late PartnerRepository repository;

  setUp(() {
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
}
