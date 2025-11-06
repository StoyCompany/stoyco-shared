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
        'Content-Type': 'application/json',
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

  Future<Response> dislikeVideo(String videoId, String userId) async {
    final urlVideoPlayer = environment.videoPlayerUrl(version: 'v2');

    final uri = '$urlVideoPlayer/dislike';

    return _dio.post(
      uri,
      data: {
        'VideoId': videoId,
        'UserId': userId,
      },
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response> likeVideo(String videoId, String userId) async {
    final urlVideoPlayer = environment.videoPlayerUrl(version: 'v2');

    final uri = '$urlVideoPlayer/like';

    return _dio.post(
      uri,
      data: {
        'VideoId': videoId,
        'UserId': userId,
      },
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response> viewVideo(String videoId) async {
    final urlVideoPlayer = environment.videoPlayerUrl(version: 'v2');
    final uri = '$urlVideoPlayer/viewed';

    return _dio.post(
      uri,
      data: {'VideoId': videoId},
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
    final urlVideoPlayer = environment.videoPlayerUrl(version: 'v2');

    final uri = '$urlVideoPlayer/shared';

    return _dio.post(
      uri,
      data: {
        'VideoId': videoId,
        'Platform': platform,
      },
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response> getVideosWithMetadata() async {
    final String uri = _buildUri('short-video/list');
    return _dio.get(
      uri,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  /// Gets videos with filter mode, pagination, and optional userId
  /// Calls the v3/short-video/videos endpoint
  Future<Response> getVideosWithFilter({
    required String filterMode,
    int page = 1,
    int pageSize = 20,
    String? userId,
    String? partnerProfile,
  }) async {
    // The feed endpoint expects userId and limit (pageSize). Keep filterMode if provided.
    final queryParams = <String, dynamic>{
      'pageSize': pageSize.toString(),
      'pageNumber': page.toString(),
    };

    if (userId != null && userId.isNotEmpty) {
      queryParams['userId'] = userId;
    }

    if (filterMode.isNotEmpty) {
      queryParams['filterMode'] = filterMode;
    }

    if (partnerProfile != null && partnerProfile.isNotEmpty) {
      queryParams['partnerProfile'] = partnerProfile;
    }

    // Use feed endpoint (example: /api/stoyco/feed/user/videos)
    final base = environment.baseUrl();
    final uri = '${base}feed/user/videos';

    final queryString =
        queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
    final fullUri = queryString.isNotEmpty ? '$uri?$queryString' : uri;

    return _dio.get(
      fullUri,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  /// Fetch featured/explore videos (optional userId, pageSize)
  Future<Response> getFeaturedVideos({
    String? userId,
    int pageSize = 10,
    int page = 1,
    String? partnerProfile,
  }) async {
    final queryParams = <String, dynamic>{
      'pageSize': pageSize.toString(),
      'pageNumber': page.toString(),
    };

    if (userId != null && userId.isNotEmpty) {
      queryParams['userId'] = userId;
    }

    if (partnerProfile != null && partnerProfile.isNotEmpty) {
      queryParams['partnerProfile'] = partnerProfile;
    }

    final base = environment.baseUrl();
    final uri = '${base}feed/explore/videos';

    final queryString =
        queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
    final fullUri = queryString.isNotEmpty ? '$uri?$queryString' : uri;

    return _dio.get(
      fullUri,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }
}
