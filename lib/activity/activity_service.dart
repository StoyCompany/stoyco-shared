import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:stoyco_shared/activity/activity_repository.dart';
import 'package:stoyco_shared/activity/activity_data_source.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/activity/models/message_model.dart';
import 'package:stoyco_shared/activity/models/notification_stats_model.dart';
import 'package:stoyco_shared/activity/models/message_stats_model.dart';
import 'package:stoyco_shared/activity/models/activity_summary_model.dart';
import 'package:stoyco_shared/activity/models/user_unified_stats_model.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/stoyco_shared.dart';
import 'package:dio/dio.dart';
import 'package:stoyco_shared/utils/dio_auth_interceptor.dart';

class ActivityService {
  factory ActivityService({
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?> Function()? functionToUpdateToken,
  }) {
    _instance ??= ActivityService._(
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
    );
    _instance!.onInit();
    return _instance!;
  }

  ActivityService._({
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
  }) {
    // Create a Dio instance and install the auth interceptor which will
    // attempt to refresh the token on 401/403 responses.
    final dio = Dio();
    // Keep a reference to the Dio instance so we can update headers when the
    // token changes (some code paths set Authorization directly on options).
    _dio = dio;
    dio.interceptors.add(
      DioAuthInterceptor(
        getToken: () => userToken,
        refreshToken: () async {
          try {
            if (functionToUpdateToken == null) return null;
            final String? newToken = await functionToUpdateToken!();
            if (newToken != null && newToken.isNotEmpty) {
              // Update the service token which will propagate to _dio and
              // _dataSource via the setter.
              token = newToken;
              return newToken;
            }
            return null;
          } catch (e) {
            StoyCoLogger.error('refreshToken closure threw: $e');
            return null;
          }
        },
      ),
    );

    _dataSource = ActivityDataSource(environment: environment, dio: dio);
    _repository = ActivityRepository(dataSource: _dataSource!);
    _dataSource!.updateUserToken(userToken);

    // Ensure Dio has the Authorization header set initially if a token was
    // provided so requests use the right token immediately.
    if (userToken.isNotEmpty) {
      _dio?.options.headers['Authorization'] = 'Bearer $userToken';
    }
  }

  static ActivityService? _instance;
  static ActivityService? get instance => _instance;

  StoycoEnvironment environment;
  ActivityRepository? _repository;
  ActivityDataSource? _dataSource;

  /// Dio client used by the data source. Stored so we can update headers
  /// when the token is refreshed; some setups rely on `dio.options.headers`
  /// instead of re-evaluating the interceptor's getToken closure.
  Dio? _dio;

  String userToken;
  Future<String?> Function()? functionToUpdateToken;

  /// If a token refresh is in progress, reuse its Future so concurrent callers
  /// don't trigger multiple refreshes.
  Future<Either<Failure, void>>? _refreshingTokenFuture;

  /// Timeout to apply to token refresh operations. Can be adjusted in tests.
  final Duration _refreshTimeout = Duration(seconds: 30);

  static void resetInstance() => _instance = null;

  void onInit() {}

  /// Test helper: construct the service with injected repository/dataSource/dio.
  /// This factory is only used by tests to avoid creating real network clients.
  factory ActivityService.forTest({
    required ActivityRepository repository,
    required ActivityDataSource dataSource,
    Dio? dio,
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?> Function()? functionToUpdateToken,
  }) {
    _instance = ActivityService._forTest(
      repository: repository,
      dataSource: dataSource,
      dio: dio,
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
    );
    _instance!.onInit();
    return _instance!;
  }

  ActivityService._forTest({
    required ActivityRepository repository,
    required ActivityDataSource dataSource,
    Dio? dio,
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
  }) {
    _repository = repository;
    _dataSource = dataSource;
    _dio = dio;
    // Ensure data source gets the initial token
    _dataSource!.updateUserToken(userToken);
    if (_dio != null && userToken.isNotEmpty) {
      _dio?.options.headers['Authorization'] = 'Bearer $userToken';
    }
  }

  /// Updates the stored token and propagates it to data source and repository.
  set token(String token) {
    userToken = token;
    _dataSource?.updateUserToken(token);
    // Also update Dio options so subsequent requests use the refreshed token.
    if (token.isNotEmpty) {
      _dio?.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio?.options.headers.remove('Authorization');
    }
  }

  /// Sets the function used to update the token when missing.
  void setFunctionToUpdateToken(Future<String?> Function()? function) {
    functionToUpdateToken = function;
  }

  /// Ensures a token is available. Returns Either with Failure on error or Right(void) on success.
  Future<Either<Failure, void>> verifyToken() async {
    if (userToken.isNotEmpty) return const Right(null);

    if (functionToUpdateToken == null) {
      return Left(
        ExceptionFailure.decode(
          Exception('Function to update token not set'),
        ),
      );
    }

    // Reuse in-flight refresh if present.
    if (_refreshingTokenFuture != null) {
      StoyCoLogger.info('Reusing token refresh');
      return await _refreshingTokenFuture!;
    }

    // Start refresh but enforce a timeout so callers don't wait forever.
    _refreshingTokenFuture = _startTokenRefresh().timeout(
      _refreshTimeout,
      onTimeout: () {
        StoyCoLogger.info('Token refresh timed out after $_refreshTimeout');
        return Left(ExceptionFailure.decode(
            Exception('Token refresh timed out after $_refreshTimeout')));
      },
    );
    try {
      return await _refreshingTokenFuture!;
    } finally {
      _refreshingTokenFuture = null;
    }
  }

  /// Starts the token refresh flow and returns an Either with the result.
  Future<Either<Failure, void>> _startTokenRefresh() async {
    try {
      final String? newToken = await functionToUpdateToken!();
      if (newToken != null && newToken.isNotEmpty) {
        token = newToken;
        return const Right(null);
      }
      return Left(ExceptionFailure.decode(Exception('Failed to update token')));
    } catch (e) {
      return Left(ExceptionFailure.decode(Exception(e.toString())));
    }
  }

  /// Helper to run repository calls with token verification and centralized error handling.
  /// Helper to run repository calls with token verification and centralized error handling.
  ///
  /// Behavior:
  /// - Ensures a token is available before the first request (calls [verifyToken]).
  /// - Executes the provided [action]. If it fails with a [DioFailure]
  ///   whose `statusCode` is 401 or 403, attempts to refresh the token
  ///   (again via [verifyToken]) and retries the action exactly once.
  /// - If token refresh fails, or the retry fails, returns the original failure.
  Future<Either<Failure, T>> _withAuth<T>(
    Future<Either<Failure, T>> Function() action,
  ) async {
    try {
      // Ensure we have a token before the first call
      final verifyResult = await verifyToken();
      if (verifyResult.isLeft) return Left(verifyResult.left);

      // First attempt. The action may either return an Either<Failure,T>
      // or throw (for example DioException). Handle both cases so we can
      // attempt a token refresh+retry on 401/403 regardless of whether the
      // lower layer returns a Left or throws.
      Either<Failure, T> result;
      try {
        result = await action();
      } catch (e) {
        // If a DioException was thrown, decode it and reuse the same retry
        // logic as when a Left(DioFailure) is returned.
        if (e is DioException) {
          final dioFailure = DioFailure.decode(e);
          if (dioFailure.statusCode == 401 || dioFailure.statusCode == 403) {
            StoyCoLogger.info(
                'Received ${dioFailure.statusCode} (thrown), attempting token refresh and one retry');

            // Attempt to refresh token
            userToken = '';
            final refreshResult = await verifyToken();
            if (refreshResult.isLeft) {
              return Left(dioFailure);
            }

            // Retry the action once with the refreshed token
            try {
              final retryResult = await action();
              return retryResult;
            } catch (e2) {
              return Left(ExceptionFailure.decode(Exception(e2.toString())));
            }
          }

          // Non-auth Dio error - return it as a Failure
          return Left(dioFailure);
        }

        // Non-Dio exception - convert to generic failure
        return Left(ExceptionFailure.decode(Exception(e.toString())));
      }

      // If the call failed and it's a DioFailure with 401/403, try to refresh token and retry once
      if (result.isLeft && result.left is DioFailure) {
        final dioFailure = result.left as DioFailure;
        if (dioFailure.statusCode == 401 || dioFailure.statusCode == 403) {
          StoyCoLogger.info(
              'Received ${dioFailure.statusCode}, attempting token refresh and one retry');

          // Attempt to refresh token
          userToken = '';
          final refreshResult = await verifyToken();
          if (refreshResult.isLeft) {
            // Could not refresh token, return original failure
            return Left(result.left);
          }

          // Retry the action once with the refreshed token
          try {
            final retryResult = await action();
            return retryResult;
          } catch (e) {
            return Left(ExceptionFailure.decode(Exception(e.toString())));
          }
        }
      }

      return result;
    } catch (e) {
      return Left(ExceptionFailure.decode(Exception(e.toString())));
    }
  }

  Future<Either<Failure, PageResult<NotificationModel>>> getNotifications(
    int page,
    int limit, {
    int? type,
    bool? unreadOnly,
    bool? expiredOnly,
  }) async =>
      _withAuth(
        () => _repository!.getNotifications(
          page: page,
          limit: limit,
          type: type,
          unreadOnly: unreadOnly,
          expiredOnly: expiredOnly,
        ),
      );

  Future<Either<Failure, PageResult<NotificationModel>>> searchNotifications(
    String q,
    int page,
    int limit,
  ) async =>
      _withAuth(
        () => _repository!.searchNotifications(q, page: page, limit: limit),
      );

  Future<Either<Failure, bool>> markNotificationViewed(String id) async =>
      _withAuth(() => _repository!.markNotificationViewed(id));

  Future<Either<Failure, bool>> deleteNotification(String id) async =>
      _withAuth(() => _repository!.deleteNotification(id));

  Future<Either<Failure, NotificationStatsModel>> getNotificationStats({
    bool? expiredOnly,
    bool? unreadOnly,
  }) async =>
      _withAuth(
        () => _repository!.getNotificationStats(
          expiredOnly: expiredOnly,
          unreadOnly: unreadOnly,
        ),
      );

  // Messages
  Future<Either<Failure, PageResult<MessageModel>>> getMessages(
    int page,
    int limit, {
    String? category,
    bool? unreadOnly,
    int? ageDays,
  }) async =>
      _withAuth(
        () => _repository!.getMessages(
          page: page,
          limit: limit,
          category: category,
          unreadOnly: unreadOnly,
          ageDays: ageDays,
        ),
      );

  Future<Either<Failure, PageResult<MessageModel>>> searchMessages(
    String q,
    int page,
    int limit,
  ) async =>
      _withAuth(() => _repository!.searchMessages(q, page: page, limit: limit));

  Future<Either<Failure, bool>> markMessageViewed(String id) async =>
      _withAuth(() => _repository!.markMessageViewed(id));

  Future<Either<Failure, bool>> deleteMessage(String id) async =>
      _withAuth(() => _repository!.deleteMessage(id));

  Future<Either<Failure, MessageStatsModel>> getMessageStats({
    int? ageDays,
    bool? unreadOnly,
  }) async =>
      _withAuth(
        () => _repository!
            .getMessageStats(ageDays: ageDays, unreadOnly: unreadOnly),
      );

  Future<Either<Failure, ActivitySummaryModel>> getActivitySummary({
    bool? unreadOnly,
    bool? expiredOnly,
    int? ageDays,
  }) async =>
      _withAuth(
        () => _repository!.getActivitySummary(
          unreadOnly: unreadOnly,
          expiredOnly: expiredOnly,
          ageDays: ageDays,
        ),
      );

  Future<Either<Failure, UserUnifiedStatsModel>> getUserUnifiedStats({
    bool? unreadOnly,
    bool? expiredOnly,
    int? ageDays,
  }) async =>
      _withAuth(
        () => _repository!.getUserUnifiedStats(
          unreadOnly: unreadOnly,
          expiredOnly: expiredOnly,
          ageDays: ageDays,
        ),
      );
}
