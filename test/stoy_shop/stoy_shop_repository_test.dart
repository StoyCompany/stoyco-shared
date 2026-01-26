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
  });

  group('getNftMetadata', () {
    test('returns NftMetadataModel on success', () async {
      final metadataJson = {
        'name': 'Mora AC:2',
        'description': 'Mora AC:2 activo cultural ambiente QA',
        'image':
            'https://qa.nft.stoyco.io/image/collection/2ffa5b3170a8428eb3bb3d87f68a6829',
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

  group('getMintedNftsByUser', () {
    test('returns List<MintedNftModel> on success', () async {
      final responseJson = {
        'error': -1,
        'messageError': '',
        'tecMessageError': '',
        'count': 2,
        'data': [
          {
            'id': '6973c0d02641d6e0d60c6138',
            'holderAddress': '0xba9Ebc409fB19EB1f0EF162E7952c70869170FA7',
            'collectionId': 367,
            'contractAddress': '0x594b8a9a9dB1274995070663191883499dD5BA56',
            'tokenId': 655,
            'txHash':
                '0xe2ae10334366627ab1bfc862373df20101005c5245d6f144c141ea1a9759defe',
            'metadataUri': 'https://qa.nft.stoyco.io/metadata/token/655',
            'imageUri': 'https://qa.nft.stoyco.io/image/token/655',
            'metadata': {
              'name': 'Mora AC:2',
              'description': 'Mora AC:2 activo cultural ambiente QA',
              'image': 'https://qa.nft.stoyco.io/image/token/655',
              'attributes': [
                {'trait_type': 'Artist', 'value': 'Mora'},
                {'trait_type': 'Symbol', 'value': 'Mora AC:2'},
              ],
            },
            'tags': ['Mora AC:2', 'Mora'],
            'burned': false,
            'isViewed': false,
            'mintSerial': '27/50',
            'tokenStandard': 'ERC-721',
            'createdAt': '2026-01-23T18:41:20.458Z',
            'updatedAt': '0001-01-01T00:00:00Z',
          },
          {
            'id': '696fa129bb4a424428633f2d',
            'holderAddress': '0xba9Ebc409fB19EB1f0EF162E7952c70869170FA7',
            'collectionId': 367,
            'contractAddress': '0x594b8a9a9dB1274995070663191883499dD5BA56',
            'tokenId': 653,
            'txHash':
                '0xb397a691ff1aeeb3a14e1b38ff6b9e1e7b1bb0dac4b5fc2af8e91be897a0818a',
            'metadataUri': 'https://qa.nft.stoyco.io/metadata/token/653',
            'imageUri': 'https://qa.nft.stoyco.io/image/token/653',
            'metadata': {
              'name': 'Mora AC:2',
              'description': 'Mora AC:2 activo cultural ambiente QA',
              'image': 'https://qa.nft.stoyco.io/image/token/653',
              'attributes': [
                {'trait_type': 'Artist', 'value': 'Mora'},
              ],
            },
            'tags': ['Mora AC:2', 'Mora'],
            'burned': false,
            'isViewed': true,
            'mintSerial': '26/50',
            'tokenStandard': 'ERC-721',
            'createdAt': '2026-01-20T15:37:13.523Z',
            'updatedAt': '2026-01-23T18:41:04.312Z',
          },
        ],
      };

      when(mockDataSource.getMintedNftsByUser(
        collectionId: 367,
        userId: 'bxBh1AUyXFODRA36fAdc5xATTgR2',
      )).thenAnswer(
        (_) async => Response(
          data: responseJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await repository.getMintedNftsByUser(
        collectionId: 367,
        userId: 'bxBh1AUyXFODRA36fAdc5xATTgR2',
      );

      expect(result.isRight, true);
      expect(result.right.length, 2);
      expect(result.right[0].id, '6973c0d02641d6e0d60c6138');
      expect(result.right[0].tokenId, 655);
      expect(result.right[0].mintSerial, '27/50');
      expect(result.right[0].isViewed, false);
      expect(result.right[0].metadata?.name, 'Mora AC:2');
      expect(result.right[1].tokenId, 653);
      expect(result.right[1].isViewed, true);
    });

    test('returns Failure when API returns error', () async {
      final responseJson = {
        'error': 1,
        'messageError': 'User not found',
        'tecMessageError': 'ERR_USER_NOT_FOUND',
        'count': 0,
        'data': [],
      };

      when(mockDataSource.getMintedNftsByUser(
        collectionId: 367,
        userId: 'invalid',
      )).thenAnswer(
        (_) async => Response(
          data: responseJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await repository.getMintedNftsByUser(
        collectionId: 367,
        userId: 'invalid',
      );

      expect(result.isLeft, true);
      expect(result.left, isA<Failure>());
    });

    test('returns Failure on DioException', () async {
      when(mockDataSource.getMintedNftsByUser(
        collectionId: 367,
        userId: 'test',
      )).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      final result = await repository.getMintedNftsByUser(
        collectionId: 367,
        userId: 'test',
      );

      expect(result.isLeft, true);
      expect(result.left, isA<Failure>());
    });
  });
}
