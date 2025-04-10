import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/tiktok/tiktok_repository.dart';

class TikTokService {
  final TikTokRepository _repository;

  TikTokService({required TikTokRepository repository})
      : _repository = repository;

  Future<Either<Failure, String>> processAuthCode({
    required String code,
    required String userId,
    required String codeVerifier,
  }) async => _repository.processAuthCode(code: code, userId: userId, codeVerifier: codeVerifier);
}