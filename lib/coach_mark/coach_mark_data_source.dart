import 'package:dio/dio.dart';

/// Represents the different environments the application can run in.
enum StoycoEnvironment {
  /// Development environment.
  development,

  /// Production environment.
  production,

  /// Testing environment.
  testing,
}

/// Extension on `StoycoEnvironment` to provide the base URL for each environment
extension StoycoEnvironmentExtension on StoycoEnvironment {
  /// Gets the base URL for the current environment
  String get baseUrl {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://dev.api.stoyco.io/api/stoyco/v1/';
      case StoycoEnvironment.production:
        return 'https://api.stoyco.io/api/stoyco/v1/';
      case StoycoEnvironment.testing:
        return 'https://qa.api.stoyco.io/api/stoyco/v1/';
    }
  }

  String get dataS3Url {
    switch (this) {
      case StoycoEnvironment.development:
        return 'https://stoyco-medias-dev.s3.amazonaws.com/data/coach_mark_data.json';
      case StoycoEnvironment.production:
        return 'https://stoyco-medias-prod.s3.amazonaws.com/data/coach_mark_data.json';
      case StoycoEnvironment.testing:
        return 'https://stoyco-medias-qa.s3.amazonaws.com/data/coach_mark_data.json';
    }
  }
}

/// A data source class responsible for making network requests related to coach marks.
///
/// This class uses `Dio` to interact with the Stoyco API to fetch, update, create,
/// and reset coach mark and onboarding data.
///
/// It handles authentication using a user token and provides methods for various
/// coach mark related operations.
class CoachMarkDataSource {
  /// Creates a `CoachMarkDataSource` instance.
  ///
  /// * `environment`: The environment to use for determining the base URL.
  CoachMarkDataSource({
    required this.environment,
  });

  /// The current environment.
  final StoycoEnvironment environment;

  /// The Dio instance used for making network requests
  final Dio _dio = Dio();

  /// The user's authentication token
  late String userToken;

  /// Updates the user token.
  void updateUserToken(String newUserToken) {
    userToken = newUserToken;
  }

  /// Gets the headers for authenticated requests, including the Authorization header
  Map<String, String> _getHeaders() => {
        'Authorization': 'Bearer $userToken',
      };

  /// Creates new onboarding coach mark data for the specified type.
  ///
  /// * `type`: The type of onboarding
  ///
  /// Returns a `Response` object from the Dio request
  Future<Response> createOnboardingCoachMarkData({
    required String type,
  }) async {
    final cancelToken = CancelToken();
    final String url = '${environment.baseUrl}onboarding/$type';
    return await _dio.post(
      url,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  /// Updates onboarding coach mark data for the specified type.
  ///
  /// * `type`: The type of onboarding to update
  /// * `step`: The step to update
  /// * `isCompleted`: Whether the step is completed or not
  ///
  /// Returns a `Response` object from the Dio request
  Future<Response> updateOnboardingCoachMarkData({
    required String type,
    required int step,
    required bool isCompleted,
  }) async {
    final cancelToken = CancelToken();
    final String url = '${environment.baseUrl}onboarding/$type';
    return await _dio.put(
      url,
      data: {
        'step': step,
        'isCompleted': isCompleted,
      },
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  /// Gets onboarding coach mark data for the specified type
  ///
  /// * `type`: The type of onboarding
  ///
  /// Returns a `Response` object from the Dio request
  Future<Response> getOnboardingByTypeCoachMarkData({
    required String type,
  }) async {
    final cancelToken = CancelToken();
    final String url = '${environment.baseUrl}onboarding/$type';
    return await _dio.get(
      url,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  /// Gets onboarding coach mark data for the current user.
  ///
  /// Returns a `Response` object from the Dio request
  Future<Response> getOnboardingsByUserCoachMarkData() async {
    final cancelToken = CancelToken();
    final String url = '${environment.baseUrl}onboarding/user';
    return await _dio.get(
      url,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  /// Resets onboarding coach mark data for the current user
  ///
  /// Returns a `Response` object from the Dio request
  Future<Response> resetOnboardingCoachMarkData() async {
    final cancelToken = CancelToken();
    final String url = '${environment.baseUrl}onboarding/user/reset';
    return await _dio.delete(
      url,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  /// Gets general coach mark data.
  ///
  /// Returns a `Response` object from the Dio request
  Future<Response> getCoachMarkData() async {
    final cancelToken = CancelToken();
    final String url = environment.dataS3Url;
    return await _dio.get(
      url,
      cancelToken: cancelToken,
    );
  }
}
