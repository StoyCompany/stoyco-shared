import 'package:dio/dio.dart';

enum StoycoEnvironment {
  development,
  production,
  testing,
}

extension StoycoEnvironmentExtension on StoycoEnvironment {
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
}

class CoachMarkDataSource {
  CoachMarkDataSource({
    required this.environment,
  });

  final StoycoEnvironment environment;
  final Dio _dio = Dio();
  late String userToken;

  void updateUserToken(String newUserToken) {
    userToken = newUserToken;
  }

  Map<String, String> _getHeaders() => {
        'Authorization': 'Bearer $userToken',
      };

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

  Future<Response> getOnboardingsByUserCoachMarkData() async {
    final cancelToken = CancelToken();
    final String url = '${environment.baseUrl}onboarding/user';
    return await _dio.get(
      url,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response> resetOnboardingCoachMarkData() async {
    final cancelToken = CancelToken();
    final String url = '${environment.baseUrl}onboarding/user/reset';
    return await _dio.post(
      url,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
  }

  Future<Response> getCoachMarkData() async {
    final cancelToken = CancelToken();
    const String url =
        'https://stoyco-medias-dev.s3.amazonaws.com/data/coach_mark_data.json';
    return await _dio.get(
      url,
      cancelToken: cancelToken,
    );
  }
}
