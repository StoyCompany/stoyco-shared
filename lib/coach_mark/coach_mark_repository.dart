import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/coach_mark/coach_mark_data_source.dart';
import 'package:stoyco_shared/coach_mark/coach_marks_content/coach_marks_content.dart';
import 'package:stoyco_shared/coach_mark/models/onboarding.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';

/// A repository class responsible for interacting with the coach mark data source.
///
/// This class provides methods to fetch, update, create, and reset coach mark
/// and onboarding data. It uses the `CoachMarkDataSource` to communicate with
/// the underlying data source (likely an API).
///
/// It handles error cases and returns results wrapped in `Either` to indicate
/// success or failure.
class CoachMarkRepository {
  /// Creates a `CoachMarkRepository` instance.
  ///
  /// * `_dataSource`: The data source to use for fetching and updating data.
  /// * `userToken`: The user's authentication token.
  CoachMarkRepository(this._dataSource, this.userToken);

  /// The data source used by the repository.
  final CoachMarkDataSource _dataSource;

  /// The user's authentication token.
  late String userToken;

  /// Updates the user token and propagates it to the data source.
  set token(String token) {
    userToken = token;
    _dataSource.updateUserToken(token);
  }

  /// Fetches onboarding data for the current user.
  ///
  /// Returns a `Right` containing a list of `Onboarding` objects on success,
  /// or a `Left` containing a `Failure` on error.
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

  /// Fetches onboarding data for the current user by type.
  ///
  /// * `type`: The type of onboarding data to fetch.
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

  /// Updates onboarding data for the current user.
  ///
  /// * `type`: The type of onboarding data to update.
  /// * `step`: The step of the onboarding data to update.
  /// * `isCompleted`: Whether the onboarding data is completed.
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

  /// Creates onboarding data for the current user.
  ///
  /// * `type`: The type of onboarding data to create.
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

  /// Resets all onboarding coach mark data
  ///
  /// Returns a `Right` containing `true` on success,
  /// or a `Left` containing a `Failure` on error
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

  /// Fetches general coach mark data.
  ///
  /// Returns a `Right` containing a `CoachMarksContent` object on success
  /// or a `Left` containing a `Failure` on error
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
