import 'package:either_dart/either.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/tiktok/tiktok_data_source.dart';
import 'package:stoyco_shared/tiktok/tiktok_repository.dart';

class TikTokService {
  factory TikTokService({
    required StoycoEnvironment environment,
  }) {
    if (_instance != null && environment != _instance!.environment) {
      return TikTokService._(
        environment: environment,
      );
    }
    _instance ??= TikTokService._(
      environment: environment,
    );
    return _instance!;
  }

  TikTokService._({
    required this.environment,
  }) {
    _dataSource = TikTokDataSource(environment: environment);
    _repository = TikTokRepository(dataSource: _dataSource!);

    _instance = this;
  }

  static TikTokService? _instance;
  StoycoEnvironment environment;
  TikTokRepository? _repository;
  TikTokDataSource? _dataSource;

  Future<Either<Failure, String>> processAuthCode({
    required String code,
    required String userId,
    required String codeVerifier,
    required String platform,
  }) async =>
      _repository!.processAuthCode(
        code: code,
        userId: userId,
        codeVerifier: codeVerifier,
        platform: platform,
      );
}
