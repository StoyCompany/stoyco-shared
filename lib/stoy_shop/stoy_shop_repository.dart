import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/cache/repository_cache_mixin.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/stoy_shop/models/minted_nft_model.dart';
import 'package:stoyco_shared/stoy_shop/models/minted_nft_response_model.dart';
import 'package:stoyco_shared/stoy_shop/models/nft_metadata_model.dart';
import 'package:stoyco_shared/stoy_shop/models/stoy_shop_category.dart';
import 'package:stoyco_shared/stoy_shop/models/stoy_shop_product_model.dart';
import 'package:stoyco_shared/stoy_shop/stoy_shop_data_source.dart';

/// Repository for StoyShop operations.
///
/// Provides data mapping and error handling for store operations.
/// No caching for product lists due to volatile stock information.
class StoyShopRepository with RepositoryCacheMixin {
  StoyShopRepository({required StoyShopDataSource dataSource})
      : _dataSource = dataSource;

  final StoyShopDataSource _dataSource;

  /// Fetches optimized paginated products for a Community Owner.
  ///
  /// No caching is applied because stock information is volatile
  /// and changes frequently with purchases/redemptions.
  ///
  /// Returns [Either] with [Failure] on left or [PageResult<StoyShopProductModel>] on right.
  ///
  /// [page] Page number (1-based).
  /// [pageSize] Number of items per page.
  /// [category] Category filter for products.
  /// [coId] Community Owner ID to filter products.
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.getOptimizedProducts(
  ///   page: 1,
  ///   pageSize: 100,
  ///   category: StoyShopCategory.culturalAssets,
  ///   coId: '66f5bb96fd46e726edae494d',
  /// );
  /// result.fold(
  ///   (failure) => handleError(failure),
  ///   (pageResult) => displayProducts(pageResult.items),
  /// );
  /// ```
  Future<Either<Failure, PageResult<StoyShopProductModel>>>
      getOptimizedProducts({
    int page = 1,
    int pageSize = 100,
    StoyShopCategory? category,
    String? coId,
  }) async {
    try {

      final response = await _dataSource.getOptimizedProducts(
        page: page,
        pageSize: pageSize,
        category: category,
        coId: coId,
      );
  
      final pageResult = PageResult<StoyShopProductModel>.fromJson(
        response.data,
        (item) => StoyShopProductModel.fromJson(item as Map<String, dynamic>),
      );

      return Right(pageResult);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  /// Fetches NFT metadata from the provided URI with 10-minute cache.
  ///
  /// Returns [Either] with [Failure] on left or [NftMetadataModel] on right.
  ///
  /// [metadataUri] Full URL to the metadata JSON file.
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.getNftMetadata(
  ///   'https://qa.nft.stoyco.io/metadata/collection/367',
  /// );
  /// result.fold(
  ///   (failure) => handleError(failure),
  ///   (metadata) => displayMetadata(metadata),
  /// );
  /// ```
  Future<Either<Failure, NftMetadataModel>> getNftMetadata(
    String metadataUri,
  ) async =>
      cachedCall<NftMetadataModel>(
        key: 'nft_metadata_${metadataUri.hashCode}',
        ttl: const Duration(minutes: 10),
        fetcher: () async {
          try {
            final response = await _dataSource.getNftMetadata(metadataUri);
            final metadata = NftMetadataModel.fromJson(response.data);
            return Right(metadata);
          } on DioException catch (error) {
            return Left(DioFailure.decode(error));
          } on Error catch (error) {
            return Left(ErrorFailure.decode(error));
          } on Exception catch (error) {
            return Left(ExceptionFailure.decode(error));
          }
        },
      );

  /// Fetches minted NFTs for a user in a specific collection.
  ///
  /// No caching is applied to ensure fresh data on each request.
  ///
  /// Returns [Either] with [Failure] on left or [List<MintedNftModel>] on right.
  ///
  /// [collectionId] Collection ID to query.
  /// [userId] User ID (Firebase UID).
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.getMintedNftsByUser(
  ///   collectionId: 367,
  ///   userId: 'bxBh1AUyXFODRA36fAdc5xATTgR2',
  /// );
  /// result.fold(
  ///   (failure) => handleError(failure),
  ///   (nfts) => displayNfts(nfts),
  /// );
  /// ```
  Future<Either<Failure, List<MintedNftModel>>> getMintedNftsByUser({
    required int collectionId,
    required String userId,
  }) async {
    try {
      final response = await _dataSource.getMintedNftsByUser(
        collectionId: collectionId,
        userId: userId,
      );

      final responseWrapper = MintedNftResponseModel.fromJson(response.data);

      if (responseWrapper.hasError) {
        return Left(
          ExceptionFailure.decode(
            Exception(
              responseWrapper.messageError ??
                  'Unknown error fetching minted NFTs',
            ),
          ),
        );
      }

      return Right(responseWrapper.data ?? []);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }
}
