import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:stoyco_shared/envs/envs.dart';

class TikTokDataSource {
  TikTokDataSource({required this.environment});
  final StoycoEnvironment environment;
  final Dio _dio = Dio();

  Future<Response> processAuthCode({
    required String code,
    required String userId,
    required String codeVerifier,
    required String platform,
  }) async {
    final response = await _dio.post(
      environment.urlTikTok,
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: jsonEncode(
        {
          'user_id': userId,
          'code': code,
          'code_verifier': codeVerifier,
          'platform': platform
        },
      ),
    );
    return response;
  }
}
