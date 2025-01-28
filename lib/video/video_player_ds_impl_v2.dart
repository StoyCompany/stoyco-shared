import 'package:dio/dio.dart';
import 'package:stoyco_shared/envs/envs.dart';

class VideoPlayerDataSourceV2 {
  VideoPlayerDataSourceV2(this.environment) {
    baseUrl = environment.baseUrl(version: 'v2');
    cancelToken = CancelToken();
  }

  /// The current environment.
  final StoycoEnvironment environment;

  /// The user's authentication token
  late String userToken;

  /// The Dio instance used for making network requests
  final Dio _dio = Dio();

  /// Gets the headers for authenticated requests, including the Authorization header
  Map<String, String> _getHeaders() => {
        'Authorization': 'Bearer $userToken',
      };

  late String baseUrl;

  late CancelToken cancelToken;

  /// Updates the user token.
  void updateUserToken(String newUserToken) {
    userToken = newUserToken;
  }

  /// Builds a URI for API requests.
  ///
  /// [endpoint] is the API endpoint.
  /// [queryParams] are optional query parameters.
  String _buildUri(String endpoint, [Map<String, dynamic>? queryParams]) {
    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString =
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
      return '$baseUrl$endpoint?$queryString';
    }
    return '$baseUrl$endpoint';
  }

  Future<Response> getVideos() async {
    final String uri = _buildUri('short-video');
    return _dio.get(
      uri,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response> dislikeVideo(String videoId) async {
    final uri = _buildUri('video-interaction/dislike', {'videoId': videoId});
    return _dio.post(
      uri,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response> likeVideo(String videoId) async {
    final uri = _buildUri('video-interaction/like', {'videoId': videoId});
    return _dio.post(
      uri,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response> getVideoReactionsById(String videoId) async {
    final String uri = _buildUri('short-video/search/$videoId');
    return _dio.get(
      uri,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response> getUserVideoInteractionData(String videoId) async {
    final uri =
        _buildUri('video-interaction/user/interaction', {'videoId': videoId});
    return _dio.get(
      uri,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response> shareVideo(String videoId, String platform) async {
    final uri = _buildUri(
        'video-interaction/share', {'videoId': videoId, 'platform': platform});
    return _dio.post(
      uri,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }
}
