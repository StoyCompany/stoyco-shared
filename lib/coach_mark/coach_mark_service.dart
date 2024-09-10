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

class CoachMarkService {
  factory CoachMarkService({
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?>? functionToUpdateToken,
  }) {
    instance.environment = environment;
    instance.userToken = userToken;
    instance._coachMarkRepository!.token = userToken;
    instance.functionToUpdateToken = functionToUpdateToken;

    instance.onInit();

    return instance;
  }
  CoachMarkService._({
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    functionToUpdateToken = null,
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

  static final CoachMarkService instance = CoachMarkService._();

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

  void onInit() {
    getOnboardingsByUserCoachMarkData();
  }

  set token(String token) {
    userToken = token;
    _coachMarkRepository!.token = token;
  }

  set onboardingListData(List<Onboarding> onboardingListData) {
    onboardingList = onboardingListData;
  }

  void openCoachMark() {
    _isCoachMarkController.add(true);
  }

  void closeCoachMark() {
    _isCoachMarkController.add(false);
  }

  Future<CoachMarksContent> getCouchMarksContent() async {
    final result = await _coachMarkRepository?.getCoachMarkData();
    if (result != null && result.isRight) {
      return result.right;
    }
    throw GetCoachMarksContentException();
  }

  Future<void> getOnboardingsByUserCoachMarkData() async {
    await verifyToken();
    final result =
        await _coachMarkRepository!.getOnboardingsByUserCoachMarkData();

    onboardingListData = result.isRight ? result.right : [];
  }

  void dispose() {
    _isCoachMarkController.close();
  }

  Future<void> verifyToken() async {
    if (userToken.isEmpty) {
      if (functionToUpdateToken == null) {
        throw Exception('functionToUpdateToken is not set');
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

  Future<bool> resetOnboardingCoachMarkData() async {
    await verifyToken();
    final result = await _coachMarkRepository!
        .resetOnboardingCoachMarkData()
        .then((value) => true)
        .catchError((error) => false);

    if (result) {
      onboardingList = [];
    }

    return result;
  }

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

  void skipOnboardingByType(OnboardingType type) {
    ignoredTutorials.add(type);
  }

  bool isOnboardingIgnored(OnboardingType type) =>
      ignoredTutorials.contains(type);
}
