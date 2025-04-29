import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/tiktok/tiktok_data_source.dart';

class TikTokRepository {
  final TikTokDataSource _dataSource;

  TikTokRepository({required TikTokDataSource dataSource})
      : _dataSource = dataSource;

  Future<Either<Failure,String>> processAuthCode({
    required String code,
    required String codeVerifier,
    required String userId,
    required String platform,
  }) async {
    try {
      final response = await _dataSource.processAuthCode(
        code: code,
        userId: userId,
        codeVerifier: codeVerifier,
        platform: platform,
      );
      return Right(response.data);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }
}