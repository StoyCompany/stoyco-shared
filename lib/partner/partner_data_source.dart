import 'package:dio/dio.dart';
import 'package:stoyco_shared/envs/envs.dart';

class PartnerDataSource {
  PartnerDataSource({required this.environment});

  final Dio _dio = Dio();

  final StoycoEnvironment environment;

  /// Gets partner and community data by partner ID using v3 endpoint.
  ///
  /// **Endpoint**: `GET /api/stoyco/v3/partner-community/{id}`
  ///
  /// Returns a [Response] with partner and community data.
  Future<Response> getPartnerCommunityById(String partnerId) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.partnerServiceBaseUrl(version: 'v3')}partner-community/$partnerId',
      cancelToken: cancelToken,
    );
    return response;
  }

  /// Gets all available market segments.
  ///
  /// **Endpoint**: `GET /api/stoyco/v2/market-segments`
  ///
  /// Market segments are categories used to classify partners and communities
  /// based on their industry, genre, or focus area (e.g., "Pop", "Regional Mexicano", "Trap Latino").
  ///
  /// Returns a [Response] with a list of market segments.
  ///
  /// Example:
  /// ```dart
  /// final response = await dataSource.getMarketSegments();
  /// final segments = (response.data as List)
  ///     .map((json) => MarketSegmentModel.fromJson(json))
  ///     .toList();
  /// ```
  Future<Response> getMarketSegments() async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.partnerServiceBaseUrl(version: 'v2')}market-segments',
      cancelToken: cancelToken,
    );
    return response;
  }

  /// Checks if a user follows a partner.
  ///
  /// **Endpoint**: `GET /api/stoyco/v1/partner/follow/check`
  ///
  /// **Parameters:**
  /// - [userId]: The ID of the user to check
  /// - [partnerId]: The ID of the partner to check
  ///
  /// Returns a [Response] with follow status information.
  ///
  /// Example:
  /// ```dart
  /// final response = await dataSource.checkPartnerFollow(
  ///   userId: "user123",
  ///   partnerId: "partner456",
  /// );
  /// final checkResponse = PartnerFollowCheckResponse.fromJson(response.data);
  /// ```
  Future<Response> checkPartnerFollow({
    required String userId,
    required String partnerId,
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.baseUrl(version: 'v1')}partner/follow/check',
      queryParameters: {
        'userId': userId,
        'partnerId': partnerId,
      },
      cancelToken: cancelToken,
    );
    return response;
  }

  /// Gets content availability flags for a given partner.
  ///
  /// This endpoint returns a set of booleans indicating whether different
  /// types of content exist for the specified partner (news, announcements,
  /// events, videos, nfts, products, etc.).
  ///
  /// **Endpoint**: `GET /api/stoyco/v1/feed/partner/{partnerId}/content-availability`
  ///
  /// * [partnerId] The unique identifier of the partner whose content
  ///   availability is being queried.
  ///
  /// Returns a [Response] whose `data` field contains the standard wrapper
  /// (error, messageError, tecMessageError, count) and a nested `data` object
  /// with the availability flags.
  ///
  /// Example:
  /// ```dart
  /// final response = await dataSource.getPartnerContentAvailability('abc123');
  /// final json = response.data as Map<String, dynamic>;
  /// ```
  Future<Response> getPartnerContentAvailability(String partnerId) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.baseUrl(version: 'v1')}feed/partner/$partnerId/content-availability',
      cancelToken: cancelToken,
    );
    return response;
  }
}
