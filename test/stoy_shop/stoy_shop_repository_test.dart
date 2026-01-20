import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:stoyco_shared/cache/in_memory_cache_manager.dart';
import 'package:stoyco_shared/stoy_shop/stoy_shop_repository.dart';
import 'package:stoyco_shared/stoy_shop/stoy_shop_data_source.dart';
import 'package:stoyco_shared/stoy_shop/models/stoy_shop_category.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'stoy_shop_repository_test.mocks.dart';

@GenerateMocks([StoyShopDataSource])
void main() {
  late MockStoyShopDataSource mockDataSource;
  late StoyShopRepository repository;

  setUp(() {
    InMemoryCacheManager.resetInstance();
    mockDataSource = MockStoyShopDataSource();
    repository = StoyShopRepository(dataSource: mockDataSource);
  });

  group('getOptimizedProducts', () {
    test('returns PageResult<StoyShopProductModel> on success', () async {
      final productJson = {
        'id': 'prod1',
        'name': 'Mora AC:2',
        'imageUrl': 'https://example.com/image.jpg',
        'stock': 50,
        'points': 100,
        'typeParametrization': 'NFT_VALUE',
        'createdAt': '2025-01-20T00:00:00.000Z',
        'isSubscriberOnly': false,
        'accessContent': null,
        'productId': 'product123',
        'data': {
          'collectionId': 367,
          'symbol': 'Mora AC:2',
          'maxSupply': 50,
          'minted': 10,
          'contractAddress': '0x123',
          'txHash': null,
          'metadataUri': 'https://qa.nft.stoyco.io/metadata/collection/367',
          'imageUri': 'https://example.com/image.jpg',
          'avatarBackgroundImageUri': null,
          'burned': false,
          'artistOrBrandId': 'artist1',
          'artistOrBrandName': 'Mora',
          'communityId': 'community1',
          'experienceOrProductName': 'Mora AC:2',
          'categories': ['NFT'],
          'isExclusive': false,
        },
      };

      final pageResultJson = {
        'items': [productJson],
        'totalCount': 1,
        'page': 1,
        'pageSize': 100,
      };

      when(mockDataSource.getOptimizedProducts(
        page: 1,
        pageSize: 100,
        category: StoyShopCategory.culturalAssets,
        coId: 'co123',
      )).thenAnswer(
        (_) async => Response(
          data: pageResultJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await repository.getOptimizedProducts(
        page: 1,
        pageSize: 100,
        category: StoyShopCategory.culturalAssets,
        coId: 'co123',
      );

      expect(result.isRight, true);
      expect(result.right.items?.length, 1);
      expect(result.right.items?.first.id, 'prod1');
      expect(result.right.items?.first.name, 'Mora AC:2');
      expect(result.right.items?.first.isNft, true);
      expect(result.right.items?.first.data?.collectionId, 367);
    });

    test('returns Failure on DioException', () async {
      when(mockDataSource.getOptimizedProducts(
        page: 1,
        pageSize: 100,
        category: null,
        coId: null,
      )).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      final result = await repository.getOptimizedProducts(
        page: 1,
        pageSize: 100,
      );

      expect(result.isLeft, true);
      expect(result.left, isA<Failure>());
    });

    test('caches results for subsequent calls', () async {
      final pageResultJson = {
        'items': [],
        'totalCount': 0,
        'page': 1,
        'pageSize': 100,
      };

      when(mockDataSource.getOptimizedProducts(
        page: 1,
        pageSize: 100,
        category: null,
        coId: null,
      )).thenAnswer(
        (_) async => Response(
          data: pageResultJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // First call
      await repository.getOptimizedProducts(page: 1, pageSize: 100);
      
      // Second call - should use cache
      await repository.getOptimizedProducts(page: 1, pageSize: 100);

      // Verify data source was only called once
      verify(mockDataSource.getOptimizedProducts(
        page: 1,
        pageSize: 100,
        category: null,
        coId: null,
      )).called(1);
    });
  });

  group('getNftMetadata', () {
    test('returns NftMetadataModel on success', () async {
      final metadataJson = {
        'name': 'Mora AC:2',
        'description': 'Mora AC:2 activo cultural ambiente QA',
        'image': 'https://qa.nft.stoyco.io/image/collection/2ffa5b3170a8428eb3bb3d87f68a6829',
        'attributes': [
          {'trait_type': 'Artist', 'value': 'Mora'},
          {'trait_type': 'Symbol', 'value': 'Mora AC:2'},
          {'trait_type': 'Collection Type', 'value': 'NFT'},
          {'trait_type': 'Max Supply', 'value': '50'},
          {'trait_type': 'Mora', 'value': '2025'},
          {'trait_type': 'Collection ID', 'value': '367'},
        ],
      };

      final metadataUri = 'https://qa.nft.stoyco.io/metadata/collection/367';

      when(mockDataSource.getNftMetadata(metadataUri)).thenAnswer(
        (_) async => Response(
          data: metadataJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await repository.getNftMetadata(metadataUri);

      expect(result.isRight, true);
      expect(result.right.name, 'Mora AC:2');
      expect(result.right.description, 'Mora AC:2 activo cultural ambiente QA');
      expect(result.right.attributes?.length, 6);
      expect(result.right.getAttributeValue('Artist'), 'Mora');
      expect(result.right.getAttributeValue('Max Supply'), '50');
    });

    test('returns Failure on DioException', () async {
      final metadataUri = 'https://qa.nft.stoyco.io/metadata/collection/367';

      when(mockDataSource.getNftMetadata(metadataUri)).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      final result = await repository.getNftMetadata(metadataUri);

      expect(result.isLeft, true);
      expect(result.left, isA<Failure>());
    });

    test('caches metadata for subsequent calls', () async {
      final metadataUri = 'https://qa.nft.stoyco.io/metadata/collection/367';
      final metadataJson = {
        'name': 'Test',
        'description': 'Test description',
        'image': 'https://example.com/image.jpg',
        'attributes': [],
      };

      when(mockDataSource.getNftMetadata(metadataUri)).thenAnswer(
        (_) async => Response(
          data: metadataJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // First call
      await repository.getNftMetadata(metadataUri);
      
      // Second call - should use cache
      await repository.getNftMetadata(metadataUri);

      // Verify data source was only called once
      verify(mockDataSource.getNftMetadata(metadataUri)).called(1);
    });
  });
}
