import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/stoy_shop/models/nft_metadata_model.dart';
import 'package:stoyco_shared/stoy_shop/models/stoy_shop_category.dart';
import 'package:stoyco_shared/stoy_shop/models/stoy_shop_product_model.dart';
import 'package:stoyco_shared/stoy_shop/stoy_shop_data_source.dart';
import 'package:stoyco_shared/stoy_shop/stoy_shop_repository.dart';
import 'package:stoyco_shared/utils/dio_auth_interceptor.dart';
import 'package:stoyco_shared/utils/logger.dart';

/// Service for StoyShop operations.
///
/// This service follows a singleton pattern and provides:
/// - Fetching optimized products for a Community Owner
/// - Filtering by category
/// - Pagination support
///
/// Example usage:
/// ```dart
/// final stoyShopService = StoyShopService(
///   environment: StoycoEnvironment.production,
/// );
///
/// // Get cultural assets for a specific CO
/// final result = await stoyShopService.getOptimizedProducts(
///   category: StoyShopCategory.culturalAssets,
///   coId: '66f5bb96fd46e726edae494d',
/// );
///
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (pageResult) => print('Found ${pageResult.totalItems} products'),
/// );
/// ```
class StoyShopService {
  /// Factory constructor for singleton instance.
  ///
  /// [environment] is required to configure API endpoints.
  /// [firebaseAuth] is optional for testing (defaults to FirebaseAuth.instance).
  factory StoyShopService({
    required StoycoEnvironment environment,
    FirebaseAuth? firebaseAuth,
  }) =>
      _instance ??= StoyShopService._(
        environment: environment,
        firebaseAuth: firebaseAuth,
      );

  StoyShopService._({
    required this.environment,
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    final dio = Dio();
    _dio = dio;

    dio.interceptors.add(
      DioAuthInterceptor(
        getToken: () => _userToken,
        refreshToken: _refreshFirebaseToken,
      ),
    );

    _dataSource = StoyShopDataSource(environment: environment, dio: dio);
    _repository = StoyShopRepository(dataSource: _dataSource!);
    _instance = this;
  }

  /// Constructor for testing with injectable dependencies.
  ///
  /// Allows injecting mock repository and data source for unit tests.
  StoyShopService.forTest({
    required this.environment,
    StoyShopRepository? repository,
    StoyShopDataSource? dataSource,
  }) : _firebaseAuth = FirebaseAuth.instance {
    _repository = repository;
    _dataSource = dataSource;
  }

  static StoyShopService? _instance;

  static StoyShopService? get instance => _instance;

  static void resetInstance() => _instance = null;

  final StoycoEnvironment environment;
  final FirebaseAuth _firebaseAuth;

  Dio? _dio;
  StoyShopDataSource? _dataSource;
  StoyShopRepository? _repository;

  String _userToken = '';

  /// Updates the authentication token in the service and datasource.
  void updateToken(String token) {
    _userToken = token;
    _dataSource?.updateUserToken(token);
    if (_dio != null) {
      _dio!.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  /// Refreshes the Firebase authentication token.
  Future<String?> _refreshFirebaseToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      final newToken = await user.getIdToken(true);
      if (newToken != null && newToken.isNotEmpty) {
        updateToken(newToken);
        return newToken;
      }
      return null;
    } catch (e) {
      StoyCoLogger.error('Failed to refresh Firebase token: $e');
      return null;
    }
  }

  /// Fetches optimized paginated products for a Community Owner.
  ///
  /// Returns [Either] with [Failure] on left or [PageResult<StoyShopProductModel>] on right.
  ///
  /// [page] Page number (1-based). Defaults to 1.
  /// [pageSize] Number of items per page. Defaults to 100.
  /// [category] Category filter for products (e.g., CulturalAssets).
  /// [coId] Community Owner ID to filter products.
  ///
  /// Example:
  /// ```dart
  /// final result = await stoyShopService.getOptimizedProducts(
  ///   category: StoyShopCategory.culturalAssets,
  ///   coId: '66f5bb96fd46e726edae494d',
  /// );
  /// ```
  Future<Either<Failure, PageResult<StoyShopProductModel>>> getOptimizedProducts({
    int page = 1,
    int pageSize = 100,
    StoyShopCategory? category,
    String? coId,
  }) =>
      _repository!.getOptimizedProducts(
        page: page,
        pageSize: pageSize,
        category: category,
        coId: coId,
      );

  /// Fetches all cultural assets for a Community Owner.
  ///
  /// Convenience method that filters by [StoyShopCategory.culturalAssets].
  ///
  /// [coId] Community Owner ID.
  /// [page] Page number (1-based). Defaults to 1.
  /// [pageSize] Number of items per page. Defaults to 100.
  Future<Either<Failure, PageResult<StoyShopProductModel>>> getCulturalAssets({
    required String coId,
    int page = 1,
    int pageSize = 100,
  }) =>
      getOptimizedProducts(
        page: page,
        pageSize: pageSize,
        category: StoyShopCategory.culturalAssets,
        coId: coId,
      );

  /// Fetches NFT metadata from the provided URI.
  ///
  /// Returns detailed information about an NFT including name, description,
  /// image, and custom attributes.
  ///
  /// [metadataUri] Full URL to the metadata JSON file.
  ///
  /// Example:
  /// ```dart
  /// final product = await stoyShopService.getOptimizedProducts(...);
  /// final metadataUri = product.data?.metadataUri;
  ///
  /// if (metadataUri != null) {
  ///   final result = await stoyShopService.getNftMetadata(metadataUri);
  ///   result.fold(
  ///     (failure) => print('Error: ${failure.message}'),
  ///     (metadata) {
  ///       print('Name: ${metadata.name}');
  ///       print('Image: ${metadata.image}');
  ///       print('Artist: ${metadata.getAttributeValue('Artist')}');
  ///     },
  ///   );
  /// }
  /// ```
  Future<Either<Failure, NftMetadataModel>> getNftMetadata(
    String metadataUri,
  ) =>
      _repository!.getNftMetadata(metadataUri);
}
