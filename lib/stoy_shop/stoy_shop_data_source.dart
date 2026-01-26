import 'package:dio/dio.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/stoy_shop/models/stoy_shop_category.dart';

/// Data source for StoyShop HTTP operations.
///
/// Handles raw API calls for store/shop-related endpoints.
/// Returns [Response] objects for the repository to process.
class StoyShopDataSource {
  StoyShopDataSource({
    required this.environment,
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;
  final StoycoEnvironment environment;

  /// User token for authenticated requests.
  String userToken = '';

  /// Updates the user token used in Authorization header.
  void updateUserToken(String newUserToken) {
    userToken = newUserToken;
  }

  /// Headers for authenticated requests.
  Map<String, String> _getHeaders() => {
        'Authorization': 'Bearer $userToken',
      };

  /// Fetches optimized paginated products for a Community Owner (CO).
  ///
  /// **Endpoint**: `GET /api/stoyco/v1/stoy-shop/optimized`
  ///
  /// [page] Page number (1-based).
  /// [pageSize] Number of items per page.
  /// [category] Category filter for products.
  /// [coId] Community Owner ID to filter products.
  ///
  /// Returns a [Response] with paginated product data.
  ///
  /// Example:
  /// ```dart
  /// final response = await dataSource.getOptimizedProducts(
  ///   page: 1,
  ///   pageSize: 100,
  ///   category: StoyShopCategory.culturalAssets,
  ///   coId: '66f5bb96fd46e726edae494d',
  /// );
  /// ```
  Future<Response> getOptimizedProducts({
    int page = 1,
    int pageSize = 100,
    StoyShopCategory? category,
    String? coId,
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.baseUrl()}stoy-shop/optimized',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (category != null) 'Category': category.value,
        if (coId != null) 'coId': coId,
      },
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  /// Fetches NFT metadata from the provided URI.
  ///
  /// **External Endpoint**: The full URI is provided in the product's metadataUri field.
  ///
  /// [metadataUri] Full URL to the metadata JSON file.
  ///
  /// Returns a [Response] with NFT metadata including name, description, image, and attributes.
  ///
  /// Example:
  /// ```dart
  /// final response = await dataSource.getNftMetadata(
  ///   'https://qa.nft.stoyco.io/metadata/collection/367',
  /// );
  /// ```
  Future<Response> getNftMetadata(String metadataUri) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      metadataUri,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  /// Fetches minted NFTs for a user in a specific collection.
  ///
  /// **Endpoint**: `GET /api/stoycoweb3/v1/mint/collection/{collectionId}/user/{userId}`
  ///
  /// [collectionId] Collection ID to query.
  /// [userId] User ID (Firebase UID).
  ///
  /// Returns a [Response] with minted NFTs owned by the user.
  ///
  /// Example:
  /// ```dart
  /// final response = await dataSource.getMintedNftsByUser(
  ///   collectionId: 367,
  ///   userId: 'bxBh1AUyXFODRA36fAdc5xATTgR2',
  /// );
  /// ```
  Future<Response> getMintedNftsByUser({
    required int collectionId,
    required String userId,
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.web3BaseUrl()}mint/collection/$collectionId/user/$userId',
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }
}
