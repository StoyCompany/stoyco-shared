// ignore_for_file: unused_element

import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:stoyco_shared/coach_mark/coach_mark_data_source.dart';
import 'package:stoyco_shared/coach_mark/coach_mark_repository.dart';
import 'package:stoyco_shared/coach_mark/coach_marks_content/coach_mark.dart';
import 'package:stoyco_shared/coach_mark/coach_marks_content/coach_marks_content.dart';
import 'package:stoyco_shared/coach_mark/errors/exception.dart';
import 'package:stoyco_shared/coach_mark/models/onboarding.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';

/// A service class to handle coach marks and onboarding functionality.
///
/// This class provides methods to fetch, update, and interact with coach mark
/// data, as well as manage user onboarding progress.
///
/// It also handles user token management and provides a stream to indicate
/// whether coach marks are currently open.
class CoachMarkService {
  /// Creates a singleton instance of `CoachMarkService`.
  ///
  /// * `environment`: The current environment (development, production, etc.). Defaults to `StoycoEnvironment.development`.
  /// * `userToken`: The user's authentication token.
  /// * `functionToUpdateToken`: An optional function to update the token if it becomes invalid.
  factory CoachMarkService({
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?>? functionToUpdateToken,
  }) {
    instance = CoachMarkService._(
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
    );

    instance.onInit();

    return instance;
  }

  /// Private constructor to enforce singleton pattern.
  CoachMarkService._({
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
  }) {
    _coachMarkDataSource = CoachMarkDataSource(
      environment: environment,
    );

    _coachMarkRepository = CoachMarkRepository(
      _coachMarkDataSource!,
      userToken,
    );

    _coachMarkRepository!.token = userToken;
    _coachMarkDataSource!.updateUserToken(userToken);
  }

  static CoachMarkService instance = CoachMarkService._();

  String userToken;
  StoycoEnvironment environment;
  List<Onboarding> onboardingList = [];
  CoachMarkRepository? _coachMarkRepository;
  CoachMarkDataSource? _coachMarkDataSource;
  Future<String?>? functionToUpdateToken;

  List<OnboardingType> ignoredTutorials = [];

  final _isCoachMarkController = StreamController<bool>.broadcast();
  Stream<bool> get isCoachMarkOpenStream => _isCoachMarkController.stream;
  Future<bool> get isCoachMarkOpen => _isCoachMarkController.stream.last;

  /// Initializes the service by fetching onboarding data.
  void onInit() {
    getOnboardingsByUserCoachMarkData();
  }

  /// Updates the user token and associated repositories.

  set token(String token) {
    userToken = token;
    _coachMarkRepository!.token = token;
  }

  /// Sets the list of onboarding data.
  set onboardingListData(List<Onboarding> onboardingListData) {
    onboardingList = onboardingListData;
  }

  /// Opens the coach mark.
  void openCoachMark() {
    _isCoachMarkController.add(true);
  }

  /// Closes the coach mark.
  void closeCoachMark() {
    _isCoachMarkController.add(false);
  }

  /// Fetches the coach marks content.
  ///
  /// Throws a `GetCoachMarksContentException` if fetching fails.
  Future<CoachMarksContent> getCouchMarksContent() async {
    await verifyToken();
    final result = await _coachMarkRepository?.getCoachMarkData();
    if (result != null && result.isRight) {
      return result.right;
    }
    throw GetCoachMarksContentException();
  }

  /// Fetches onboarding data for the current user.
  Future<void> getOnboardingsByUserCoachMarkData() async {
    await verifyToken();
    final result =
        await _coachMarkRepository!.getOnboardingsByUserCoachMarkData();

    onboardingListData = result.isRight ? result.right : [];
  }

  /// Verifies the user token and updates it if necessary.
  ///
  /// Throws an exception if token update fails.
  Future<void> verifyToken() async {
    if (userToken.isEmpty) {
      if (functionToUpdateToken == null) {
        throw FunctionToUpdateTokenNotSetException();
      }

      final String? newToken = await functionToUpdateToken!;

      if (newToken != null && newToken.isNotEmpty) {
        userToken = newToken;
        _coachMarkRepository!.token = newToken;
        _coachMarkDataSource!.updateUserToken(newToken);
      } else {
        throw EmptyUserTokenException('Failed to update token');
      }
    }
  }

  /// Fetches onboarding data for a specific type.
  ///
  /// * `type`: The type of onboarding to fetch.
  Future<Either<Failure, Onboarding>> getOnboardingByTypeCoachMarkData({
    required String type,
  }) async {
    await verifyToken();
    return await _coachMarkRepository!.getOnboardingByTypeCoachMarkData(
      type: type,
    );
  }

  Future<Either<Failure, Onboarding>> getOnboardingHome() async {
    await verifyToken();
    return await _coachMarkRepository!.getOnboardingByTypeCoachMarkData(
      type: OnboardingType.home.toString(),
    );
  }

  Future<Either<Failure, Onboarding>> getOnboardingCommunity() async {
    await verifyToken();
    return await _coachMarkRepository!.getOnboardingByTypeCoachMarkData(
      type: OnboardingType.community.toString(),
    );
  }

  Future<Either<Failure, Onboarding>> getOnboardingWallet() async {
    await verifyToken();
    return await _coachMarkRepository!.getOnboardingByTypeCoachMarkData(
      type: OnboardingType.wallet.toString(),
    );
  }

  /// Marks a specific step in an onboarding as completed.
  ///
  /// * `type`: The type of onboarding.
  /// * `step`: The step to mark as completed.
  /// * `isCompleted`: Whether the step is completed or not.
  Future<Either<Failure, Onboarding>> markStepAsCompleted({
    required OnboardingType type,
    required int step,
    required bool isCompleted,
  }) async {
    await verifyToken();
    return await _coachMarkRepository!.updateOnboardingCoachMarkData(
      type: type.toString(),
      step: step + 1, // next step
      isCompleted: isCompleted,
    );
  }

  /// Resets all onboarding data.
  ///
  /// Returns `true` if reset is successful, `false` otherwise.
  Future<bool> resetOnboardingCoachMarkData() async {
    await verifyToken();
    final result = await _coachMarkRepository!
        .resetOnboardingCoachMarkData()
        .then((value) => true)
        .catchError((error) => false);

    if (result) {
      onboardingList = [];
      ignoredTutorials = [];
      closeCoachMark();
    }

    return result;
  }

  /// Fetches coach mark content for a specific type.
  ///
  /// * `type`: The type of coach mark to fetch.
  ///
  /// Throws exceptions if type is ignored, content is not found, or fetching fails.
  Future<CoachMark>? getCouchMarksContentByType(OnboardingType type) async {
    if (ignoredTutorials.contains(type)) {
      throw OnboardingTypeNotProvidedException();
    } else {
      try {
        final CoachMarksContent couchMarksContent =
            await getCouchMarksContent();

        final data = couchMarksContent.coachMarks
            ?.firstWhere((element) => element.type == type.toString());

        if (data != null) {
          final viewLog =
              await _coachMarkRepository!.getOnboardingByTypeCoachMarkData(
            type: type.toString(),
          );

          if (viewLog.isRight) {
            return data.copyWith(
              currentStep: viewLog.right.step,
              isCompleted: viewLog.right.isCompleted,
            );
          }

          throw NoContentCoachMarkDataByTypeException(
            viewLog.left.message,
          );
        } else {
          throw NoContentCoachMarkDataByTypeException();
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  /// Skips an onboarding for a specific type.
  ///
  /// * `type`: The type of onboarding to skip.
  void skipOnboardingByType(OnboardingType type) {
    ignoredTutorials.add(type);
  }

  /// Checks if an onboarding is ignored.
  ///
  /// * `type`: The type of onboarding to check
  ///
  /// Returns `true` if ignored, `false` otherwise
  bool isOnboardingIgnored(OnboardingType type) =>
      ignoredTutorials.contains(type);

  //reset instance
  void reset() {
    onboardingList = [];
    ignoredTutorials = [];
    closeCoachMark();
  }

  /// Disposes of the stream controller.
  void dispose() {
    _isCoachMarkController.close();
  }
}
