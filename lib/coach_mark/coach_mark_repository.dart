import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/coach_mark/coach_mark_data_source.dart';
import 'package:stoyco_shared/coach_mark/coach_marks_content/coach_marks_content.dart';
import 'package:stoyco_shared/coach_mark/models/onboarding.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';

class CoachMarkRepository {
  CoachMarkRepository(this._dataSource, this.userToken);
  final CoachMarkDataSource _dataSource;
  late String userToken;

  set token(String token) {
    userToken = token;
    _dataSource.updateUserToken(token);
  }

  Future<Either<Failure, List<Onboarding>>>
      getOnboardingsByUserCoachMarkData() async {
    try {
      final response = await _dataSource.getOnboardingsByUserCoachMarkData();
      if (response.statusCode == 200) {
        final List<Onboarding> onboardings = [];
        for (final item in response.data['data']) {
          onboardings.add(Onboarding.fromJson(item));
        }
        return Right(onboardings);
      } else {
        return Left(
          ExceptionFailure.decode(
            Exception('Error getting onboarding coach mark data'),
          ),
        );
      }
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, Onboarding>> getOnboardingByTypeCoachMarkData({
    required String type,
  }) async {
    try {
      final response = await _dataSource.getOnboardingByTypeCoachMarkData(
        type: type,
      );
      if (response.statusCode == 200) {
        return Right(Onboarding.fromJson(response.data['data']));
      } else {
        return Left(
          ExceptionFailure.decode(
            Exception('Error getting onboarding coach mark data'),
          ),
        );
      }
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, Onboarding>> updateOnboardingCoachMarkData({
    required String type,
    required int step,
    required bool isCompleted,
  }) async {
    try {
      final response = await _dataSource.updateOnboardingCoachMarkData(
        type: type,
        step: step,
        isCompleted: isCompleted,
      );
      if (response.statusCode == 200) {
        return Right(Onboarding.fromJson(response.data['data']));
      } else {
        return Left(
          ExceptionFailure.decode(
            Exception('Error updating onboarding coach mark data'),
          ),
        );
      }
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, Onboarding>> createOnboardingCoachMarkData({
    required String type,
  }) async {
    try {
      final response = await _dataSource.createOnboardingCoachMarkData(
        type: type,
      );
      if (response.statusCode == 200) {
        return Right(Onboarding.fromJson(response.data['data']));
      } else {
        return Left(
          ExceptionFailure.decode(
            Exception('Error creating onboarding coach mark data'),
          ),
        );
      }
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, bool>> resetOnboardingCoachMarkData() async {
    try {
      final response = await _dataSource.resetOnboardingCoachMarkData();
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          ExceptionFailure.decode(
            Exception('Error restarting onboarding coach mark data'),
          ),
        );
      }
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  Future<Either<Failure, CoachMarksContent>> getCoachMarkData() async {
    try {
      final response = await _dataSource.getCoachMarkData();
      if (response.statusCode == 200) {
        return Right(CoachMarksContent.fromJson(response.data));
      } else {
        return Left(
          ExceptionFailure.decode(
            Exception('Error getting coach mark data'),
          ),
        );
      }
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }
}
