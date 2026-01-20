import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/stoy_shop/stoy_shop_service.dart';
import 'package:stoyco_shared/stoy_shop/stoy_shop_repository.dart';
import 'package:stoyco_shared/stoy_shop/stoy_shop_data_source.dart';
import 'package:stoyco_shared/stoy_shop/models/stoy_shop_category.dart';
import 'package:stoyco_shared/stoy_shop/models/stoy_shop_product_model.dart';
import 'package:stoyco_shared/stoy_shop/models/nft_metadata_model.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'stoy_shop_service_test.mocks.dart';

@GenerateMocks([StoyShopRepository, StoyShopDataSource])
void _provideMocks() {
  provideDummy<Either<Failure, PageResult<StoyShopProductModel>>>(
    Right(
      PageResult<StoyShopProductModel>(
        items: [],
        totalCount: 0,
        page: 1,
        pageSize: 100,
      ),
    ),
  );

  provideDummy<Either<Failure, NftMetadataModel>>(
    const Right(
      NftMetadataModel(
        name: 'Test NFT',
        description: 'Test description',
        image: 'https://example.com/image.jpg',
        attributes: [],
      ),
    ),
  );
}

void main() {
  late MockStoyShopRepository mockRepository;
  late MockStoyShopDataSource mockDataSource;

  setUp(() {
    mockRepository = MockStoyShopRepository();
    mockDataSource = MockStoyShopDataSource();
    StoyShopService.resetInstance();
    _provideMocks();
  });

  tearDown(() {
    StoyShopService.resetInstance();
  });

  group('StoyShopService', () {
    test('singleton returns same instance', () {
      final service1 = StoyShopService(
        environment: StoycoEnvironment.testing,
      );
      final service2 = StoyShopService(
        environment: StoycoEnvironment.testing,
      );

      expect(identical(service1, service2), isTrue);
    });

    test('resetInstance clears singleton', () {
      final service1 = StoyShopService(
        environment: StoycoEnvironment.testing,
      );
      
      StoyShopService.resetInstance();
      
      final service2 = StoyShopService(
        environment: StoycoEnvironment.testing,
      );

      expect(identical(service1, service2), isFalse);
    });

    test('instance getter returns current instance', () {
      final service = StoyShopService(
        environment: StoycoEnvironment.testing,
      );

      expect(StoyShopService.instance, same(service));
    });

    test('instance is null after resetInstance', () {
      StoyShopService(environment: StoycoEnvironment.testing);
      StoyShopService.resetInstance();

      expect(StoyShopService.instance, isNull);
    });
  });

  group('getOptimizedProducts', () {
    test('returns PageResult on success', () async {
      final product = StoyShopProductModel(
        id: 'prod1',
        name: 'Test Product',
        imageUrl: 'https://example.com/image.jpg',
        stock: 10,
        points: 100,
        typeParametrization: 'NFT_VALUE',
        createdAt: DateTime.now(),
        isSubscriberOnly: false,
        productId: 'product123',
      );

      final pageResult = PageResult<StoyShopProductModel>(
        items: [product],
        totalCount: 1,
        page: 1,
        pageSize: 100,
      );

      when(mockRepository.getOptimizedProducts(
        page: 1,
        pageSize: 100,
        category: null,
        coId: null,
      )).thenAnswer((_) async => Right(pageResult));

      final service = StoyShopService.forTest(
        environment: StoycoEnvironment.testing,
        repository: mockRepository,
      );

      final result = await service.getOptimizedProducts(
        page: 1,
        pageSize: 100,
      );

      expect(result.isRight, true);
      expect(result.right.items?.length, 1);
      expect(result.right.items?.first.name, 'Test Product');

      verify(mockRepository.getOptimizedProducts(
        page: 1,
        pageSize: 100,
        category: null,
        coId: null,
      )).called(1);
    });

    test('returns Failure on error', () async {
      final failure = ExceptionFailure.decode(Exception('Network error'));

      when(mockRepository.getOptimizedProducts(
        page: 1,
        pageSize: 100,
        category: null,
        coId: null,
      )).thenAnswer((_) async => Left(failure));

      final service = StoyShopService.forTest(
        environment: StoycoEnvironment.testing,
        repository: mockRepository,
      );

      final result = await service.getOptimizedProducts(
        page: 1,
        pageSize: 100,
      );

      expect(result.isLeft, true);
      expect(result.left, isA<Failure>());
    });

    test('passes correct parameters to repository', () async {
      when(mockRepository.getOptimizedProducts(
        page: 2,
        pageSize: 50,
        category: StoyShopCategory.culturalAssets,
        coId: 'co123',
      )).thenAnswer(
        (_) async => Right(
          PageResult<StoyShopProductModel>(
            items: [],
            totalCount: 0,
            page: 2,
            pageSize: 50,
          ),
        ),
      );

      final service = StoyShopService.forTest(
        environment: StoycoEnvironment.testing,
        repository: mockRepository,
      );

      await service.getOptimizedProducts(
        page: 2,
        pageSize: 50,
        category: StoyShopCategory.culturalAssets,
        coId: 'co123',
      );

      verify(mockRepository.getOptimizedProducts(
        page: 2,
        pageSize: 50,
        category: StoyShopCategory.culturalAssets,
        coId: 'co123',
      )).called(1);
    });
  });

  group('getCulturalAssets', () {
    test('calls getOptimizedProducts with culturalAssets category', () async {
      when(mockRepository.getOptimizedProducts(
        page: 1,
        pageSize: 100,
        category: StoyShopCategory.culturalAssets,
        coId: 'co123',
      )).thenAnswer(
        (_) async => Right(
          PageResult<StoyShopProductModel>(
            items: [],
            totalCount: 0,
            page: 1,
            pageSize: 100,
          ),
        ),
      );

      final service = StoyShopService.forTest(
        environment: StoycoEnvironment.testing,
        repository: mockRepository,
      );

      await service.getCulturalAssets(page: 1, pageSize: 100, coId: 'co123');

      verify(mockRepository.getOptimizedProducts(
        page: 1,
        pageSize: 100,
        category: StoyShopCategory.culturalAssets,
        coId: 'co123',
      )).called(1);
    });
  });

  group('getNftMetadata', () {
    test('returns NftMetadataModel on success', () async {
      final metadata = const NftMetadataModel(
        name: 'Mora AC:2',
        description: 'Test description',
        image: 'https://example.com/image.jpg',
        attributes: [
          NftAttributeModel(traitType: 'Artist', value: 'Mora'),
        ],
      );

      final metadataUri = 'https://qa.nft.stoyco.io/metadata/collection/367';

      when(mockRepository.getNftMetadata(metadataUri))
          .thenAnswer((_) async => Right(metadata));

      final service = StoyShopService.forTest(
        environment: StoycoEnvironment.testing,
        repository: mockRepository,
      );

      final result = await service.getNftMetadata(metadataUri);

      expect(result.isRight, true);
      expect(result.right.name, 'Mora AC:2');
      expect(result.right.attributes?.length, 1);

      verify(mockRepository.getNftMetadata(metadataUri)).called(1);
    });

    test('returns Failure on error', () async {
      final metadataUri = 'https://qa.nft.stoyco.io/metadata/collection/367';
      final failure = ExceptionFailure.decode(Exception('Failed to fetch'));

      when(mockRepository.getNftMetadata(metadataUri))
          .thenAnswer((_) async => Left(failure));

      final service = StoyShopService.forTest(
        environment: StoycoEnvironment.testing,
        repository: mockRepository,
      );

      final result = await service.getNftMetadata(metadataUri);

      expect(result.isLeft, true);
      expect(result.left, isA<Failure>());
    });
  });

  group('updateToken', () {
    test('updates token in data source', () {
      final service = StoyShopService.forTest(
        environment: StoycoEnvironment.testing,
        dataSource: mockDataSource,
      );

      service.updateToken('new-token-123');

      verify(mockDataSource.updateUserToken('new-token-123')).called(1);
    });
  });
}
