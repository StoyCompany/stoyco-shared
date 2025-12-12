import 'dart:async';

import 'package:dio/dio.dart';
import 'package:stoyco_shared/stoyco_shared.dart';

/// Dio interceptor that attempts to refresh the auth token when a 401/403
/// response is received, then retries the original request once.
///
/// The interceptor requires two callbacks:
/// - [getToken]: returns the current token (may be synchronous)
/// - [refreshToken]: attempts to refresh the token and returns the new token
///
class DioAuthInterceptor extends Interceptor {
  DioAuthInterceptor({
    required this.getToken,
    required this.refreshToken,
  });

  final String? Function() getToken;
  final Future<String?> Function() refreshToken;

  /// If a refresh is already in progress, reuse the same future so
  /// concurrent requests don't trigger multiple refreshes.
  Future<String?>? _refreshingFuture;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final token = getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      StoyCoLogger.error('Error getting token for request: $e');
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler,) async {
    final statusCode = err.response?.statusCode;

    // Only attempt refresh on 401/403
    if (statusCode == 401 || statusCode == 403) {
      StoyCoLogger.info(
          'Received $statusCode - attempting token refresh via interceptor',);

      try {
        // Reuse in-flight refresh if any
        _refreshingFuture ??= refreshToken();
        final newToken = await _refreshingFuture;
        _refreshingFuture = null;

        if (newToken != null && newToken.isNotEmpty) {
          // Update header and retry the request once
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';

          // Create a new Dio instance without this interceptor to avoid loops,
          // but reuse the underlying options from the current request.
          final dio = Dio();

          try {
            final response = await dio.fetch(opts);
            return handler.resolve(response);
          } catch (e) {
            // If retry fails, fallthrough to original error handling
            StoyCoLogger.error('Retry after token refresh failed: $e');
          }
        } else {
          StoyCoLogger.info('Token refresh returned null/empty token');
        }
      } catch (e) {
        StoyCoLogger.error('Token refresh threw: $e');
      }
    }

    return super.onError(err, handler);
  }
}
