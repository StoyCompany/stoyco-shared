import 'package:reactive_forms/reactive_forms.dart';

/// A collection of custom validators for form fields.
class StoycoValidators {
  /// Validator that checks if the input contains at least one letter.
  static Validator<String> requiredAtLeastOneLetter() =>
      RequiredAtLeastOneLetter();

  /// Validator that checks if the input contains at least one digit.
  static Validator<String> requiredAtLeastOneDigit() =>
      RequiredAtLeastOneDigit();

  /// Validator that checks if the input contains at least one special character.
  static Validator<String> requiredAtLeastOneSpecialCharacter() =>
      RequiredAtLeastOneSpecialCharacter();

  /// Validator that checks if the input contains at least one lowercase letter.
  static Validator<String> requiredAtLeastOneLowercaseLetter() =>
      RequiredAtLeastOneLowercaseLetter();

  /// Validator that checks if the input contains at least one uppercase letter.
  static Validator<String> requiredAtLeastOneUppercaseLetter() =>
      RequiredAtLeastOneUppercaseLetter();

  /// Validator that checks if the input does not contain any white spaces.
  static Validator<String> requiredNoWhiteSpaces() => RequiredNoWhiteSpaces();
}

/// Validator that checks if the input contains at least one letter.
class RequiredAtLeastOneLetter extends Validator<String> {
  @override
  Map<String, dynamic>? validate(AbstractControl<String> control) {
    final value = control.value;
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return {'requiredAtLeastOneLetter': true};
    }
    return null;
  }
}

/// Validator that checks if the input contains at least one digit.
class RequiredAtLeastOneDigit extends Validator<String> {
  @override
  Map<String, dynamic>? validate(AbstractControl<String> control) {
    final value = control.value;
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return {'requiredAtLeastOneDigit': true};
    }
    return null;
  }
}

/// Validator that checks if the input contains at least one special character.
class RequiredAtLeastOneSpecialCharacter extends Validator<String> {
  @override
  Map<String, dynamic>? validate(AbstractControl<String> control) {
    final value = control.value;
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return {'requiredAtLeastOneSpecialCharacter': true};
    }
    return null;
  }
}

/// Validator that checks if the input contains at least one lowercase letter.
class RequiredAtLeastOneLowercaseLetter extends Validator<String> {
  @override
  Map<String, dynamic>? validate(AbstractControl<String> control) {
    final value = control.value;
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return {'requiredAtLeastOneLowercaseLetter': true};
    }
    return null;
  }
}

/// Validator that checks if the input contains at least one uppercase letter.
class RequiredAtLeastOneUppercaseLetter extends Validator<String> {
  @override
  Map<String, dynamic>? validate(AbstractControl<String> control) {
    final value = control.value;
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return {'requiredAtLeastOneUppercaseLetter': true};
    }
    return null;
  }
}

/// Validator that checks if the input does not contain any white spaces.
class RequiredNoWhiteSpaces extends Validator<String> {
  @override
  Map<String, dynamic>? validate(AbstractControl<String> control) {
    final value = control.value;
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.contains(' ')) {
      return {'requiredNoWhiteSpaces': true};
    }
    return null;
  }
}
