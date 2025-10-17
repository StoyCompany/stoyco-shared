import 'package:dio/dio.dart';
import 'package:stoyco_shared/envs/envs.dart';
// Dio instance is injected; auth interceptor should be installed by the caller.

// Note: ActivityDataSource supports an optional token refresh callback which
// will be used by the internal interceptor to refresh tokens on 401/403.

class ActivityDataSource {
  ActivityDataSource({
    required this.environment,
    required Dio dio,
  }) : _dio = dio;

  final StoycoEnvironment environment;

  /// Dio instance injected via constructor
  final Dio _dio;

  /// User token for authenticated requests
  late String userToken;

  /// Update user token used in Authorization header
  void updateUserToken(String newUserToken) {
    userToken = newUserToken;
  }

  /// Headers for authenticated requests
  Map<String, String> _getHeaders() => {
        'Authorization': 'Bearer $userToken',
      };

  Future<Response> getNotifications({
    int page = 1,
    int limit = 20,
    int? type,
    bool? unreadOnly,
    bool? expiredOnly,
  }) async {
    final cancelToken = CancelToken();
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (type != null) params['type'] = type;
    if (unreadOnly != null) params['unreadOnly'] = unreadOnly;
    if (expiredOnly != null) params['expiredOnly'] = expiredOnly;

    final response = await _dio.get(
      '${environment.urlActivity}/notifications',
      queryParameters: params,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  Future<Response> searchNotifications({
    required String q,
    int page = 1,
    int limit = 20,
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.urlActivity}/notifications/search',
      queryParameters: {
        'q': q,
        'page': page,
        'limit': limit,
      },
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  Future<Response> markNotificationViewed(String id) async {
    final cancelToken = CancelToken();
    final response = await _dio.put(
      '${environment.urlActivity}/notifications/$id/viewed',
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  Future<Response> deleteNotification(String id) async {
    final cancelToken = CancelToken();
    final response = await _dio.delete(
      '${environment.urlActivity}/notifications/$id',
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  Future<Response> getNotificationStats(
      {bool? expiredOnly, bool? unreadOnly}) async {
    final cancelToken = CancelToken();
    final params = <String, dynamic>{};
    if (expiredOnly != null) params['expiredOnly'] = expiredOnly;
    if (unreadOnly != null) params['unreadOnly'] = unreadOnly;

    final response = await _dio.get(
      '${environment.urlActivity}/notifications/stats',
      queryParameters: params,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  // Messages
  Future<Response> getMessages({
    int page = 1,
    int limit = 20,
    String? category,
    bool? unreadOnly,
    int? ageDays,
  }) async {
    final cancelToken = CancelToken();
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (category != null) params['category'] = category;
    if (unreadOnly != null) params['unreadOnly'] = unreadOnly;
    if (ageDays != null) params['ageDays'] = ageDays;

    final response = await _dio.get(
      '${environment.urlActivity}/messages',
      queryParameters: params,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  Future<Response> searchMessages({
    required String q,
    int page = 1,
    int limit = 20,
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.urlActivity}/messages/search',
      queryParameters: {
        'q': q,
        'page': page,
        'limit': limit,
      },
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  Future<Response> markMessageViewed(String id) async {
    final cancelToken = CancelToken();
    final response = await _dio.put(
      '${environment.urlActivity}/messages/$id/viewed',
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  Future<Response> deleteMessage(String id) async {
    final cancelToken = CancelToken();
    final response = await _dio.delete(
      '${environment.urlActivity}/messages/$id',
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  Future<Response> getMessageStats({int? ageDays, bool? unreadOnly}) async {
    final cancelToken = CancelToken();
    final params = <String, dynamic>{};
    if (ageDays != null) params['ageDays'] = ageDays;
    if (unreadOnly != null) params['unreadOnly'] = unreadOnly;

    final response = await _dio.get(
      '${environment.urlActivity}/messages/stats',
      queryParameters: params,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  Future<Response> getActivitySummary(
      {bool? unreadOnly, bool? expiredOnly, int? ageDays}) async {
    final cancelToken = CancelToken();
    final params = <String, dynamic>{};
    if (unreadOnly != null) params['unreadOnly'] = unreadOnly;
    if (expiredOnly != null) params['expiredOnly'] = expiredOnly;
    if (ageDays != null) params['ageDays'] = ageDays;

    final response = await _dio.get(
      '${environment.urlActivity}/activity/summary',
      queryParameters: params,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  Future<Response> getUserUnifiedStats(
      {bool? unreadOnly, bool? expiredOnly, int? ageDays}) async {
    final cancelToken = CancelToken();
    final params = <String, dynamic>{};
    if (unreadOnly != null) params['unreadOnly'] = unreadOnly;
    if (expiredOnly != null) params['expiredOnly'] = expiredOnly;
    if (ageDays != null) params['ageDays'] = ageDays;

    final response = await _dio.get(
      '${environment.urlActivity}/user/stats',
      queryParameters: params,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }
}
