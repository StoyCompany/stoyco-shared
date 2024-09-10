class EmptyUserTokenException implements Exception {
  EmptyUserTokenException([this.message = 'User token is empty']);
  final String message;

  @override
  String toString() => 'EmptyUserTokenException: $message';
}

class NoContentCoachMarkDataByTypeException implements Exception {
  NoContentCoachMarkDataByTypeException(
      [this.message = 'No content coach mark data by type']);
  final String message;

  @override
  String toString() => 'NoContentCoachMarkDataByTypeException: $message';
}

class OnboardingTypeNotProvidedException implements Exception {
  OnboardingTypeNotProvidedException(
      [this.message = 'Onboarding type not provided']);
  final String message;

  @override
  String toString() => 'OnboardingTypeNotProvidedException: $message';
}

//ERROR getCouchMarksContent
class GetCoachMarksContentException implements Exception {
  GetCoachMarksContentException(
      [this.message = 'Error getting coach marks content']);
  final String message;

  @override
  String toString() => 'GetCoachMarksContentException: $message';
}
