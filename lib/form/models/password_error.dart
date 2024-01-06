/// Represents an error related to password validation.
class PasswordError {
  /// The error message associated with the password error.
  final String message;

  /// The validator function used to validate the password.
  final bool Function()? validator;

  /// Creates a new instance of the [PasswordError] class.
  ///
  /// The [message] parameter is the error message associated with the password error.
  /// The [validator] parameter is the validator function used to validate the password.
  const PasswordError({
    required this.message,
    required this.validator,
  });
}
