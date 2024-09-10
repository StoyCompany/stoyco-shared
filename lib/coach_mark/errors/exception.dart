/// Exception thrown when the user token is empty or invalid.
class EmptyUserTokenException implements Exception {
  /// Creates an `EmptyUserTokenException` with an optional message.
  ///
  /// * `message`: The error message (defaults to "User token is empty")
  EmptyUserTokenException([this.message = 'User token is empty']);

  /// The error message associated with the exception
  final String message;

  /// Returns a string representation of the exception
  @override
  String toString() => 'EmptyUserTokenException: $message';
}

/// Exception thrown when no coach mark data is found for a specific type
class NoContentCoachMarkDataByTypeException implements Exception {
  /// Creates a `NoContentCoachMarkDataByTypeException` with an optional message
  ///
  /// * `message`: The error message (defaults to "No content coach mark data by type")
  NoContentCoachMarkDataByTypeException([
    this.message = 'No content coach mark data by type',
  ]);

  /// The error message associated with the exception
  final String message;

  /// Returns a string representation of the exception
  @override
  String toString() => 'NoContentCoachMarkDataByTypeException: $message';
}

/// Exception thrown when the onboarding type is not provided
class OnboardingTypeNotProvidedException implements Exception {
  /// Creates an `OnboardingTypeNotProvidedException` with an optional message
  ///
  /// * `message`: The error message (defaults to "Onboarding type not provided")
  OnboardingTypeNotProvidedException([
    this.message = 'Onboarding type not provided',
  ]);

  /// The error message associated with the exception
  final String message;

  /// Returns a string representation of the exception
  @override
  String toString() => 'OnboardingTypeNotProvidedException: $message';
}

/// Exception thrown when there's an error getting coach marks content
class GetCoachMarksContentException implements Exception {
  /// Creates a `GetCoachMarksContentException` with an optional message
  ///
  /// * `message`: The error message (defaults to "Error getting coach marks content")
  GetCoachMarksContentException([
    this.message = 'Error getting coach marks content',
  ]);

  /// The error message associated with the exception
  final String message;

  /// Returns a string representation of the exception
  @override
  String toString() => 'GetCoachMarksContentException: $message';
}
