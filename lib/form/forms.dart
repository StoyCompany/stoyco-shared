// ignore_for_file: avoid_annotating_with_dynamic, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

export 'package:stoyco_shared/form/fields/text_field.dart';
export 'package:stoyco_shared/form/fields/date_picker.dart';
export 'package:stoyco_shared/form/fields/drop_down_field.dart';
export 'package:stoyco_shared/form/fields/country_icon_field.dart';
export 'package:stoyco_shared/form/fields/phone_number_field.dart';
export 'package:stoyco_shared/form/fields/text_field_with_check.dart';

/// A utility class for managing and validating forms using the `reactive_forms` package.
class StoycoForms {
  /// Returns a map of validation messages for common form errors.
  static Map<String, String Function(dynamic error)> validationMessages() {
    return {
      'required': requiredMessage(),
      'number': numberMessage(),
      'max': numberMax(),
      'min': numberMin(),
      'pattern': pattern(),
      'email': email(),
      'typeDocumentVerify': typeDocumentVerify(),
      'addressVerify': addressVerify(),
      'minLength': minLength(),
      'maxLength': maxLength(),
    };
  }

  /// Merges custom validators with the default validation messages.
  static Map<String, String Function(dynamic error)>
      validationMessagesWithParameters(
    Map<String, String Function(dynamic error)> validators,
  ) {
    return {
      ...validationMessages(),
      ...validators,
    };
  }

  /// Returns the keyboard type based on the [formControlName].
  static TextInputType keyBoardTypeByFormControl(String? formControlName) {
    switch (formControlName) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'number':
        return TextInputType.number;
      case 'password':
        return TextInputType.visiblePassword;
      default:
        return TextInputType.text;
    }
  }

  /// Returns a required validation error message.
  static String Function(dynamic error) requiredMessage() {
    return (error) => 'Required';
  }

  /// Returns a number validation error message.
  static String Function(dynamic error) numberMessage() {
    return (error) => 'Must be a number';
  }

  /// Returns a maximum value validation error message.
  static String Function(dynamic error) numberMax() {
    return (error) => '$error';
  }

  /// Returns a minimum value validation error message.
  static String Function(dynamic error) numberMin() {
    return (error) => '$error';
  }

  /// Returns a maximum length validation error message.
  static String Function(dynamic error) maxLength() {
    return (error) => '${error['actualLength']}/${error['requiredLength']}';
  }

  /// Returns a minimum length validation error message.
  static String Function(dynamic error) minLength() {
    return (error) => '${error['actualLength']}/${error['requiredLength']}';
  }

  /// Returns a pattern validation error message based on the regular expression patterns.
  static String Function(dynamic error) pattern() {
    return (error) {
      Map<String, String> patternMessages = {
        r'^[a-zA-Z0-9 ]+$': 'Only letters and numbers are allowed.',
        r'^[a-zA-Z]+$': 'Only letters are allowed.',
        r'^[0-9]+$': 'Only numbers are allowed.',
        r'^(?![_*0-9])[a-zA-Z0-9_*.,-]{3,20}$':
            'Only letters, numbers, and special characters: *, _, ., - are allowed',
      };

      String pattern = error['requiredPattern'];
      return patternMessages[pattern] ?? 'Must match the pattern: "$pattern"';
    };
  }

  /// Returns an email validation error message.
  static String Function(dynamic error) email() {
    return (error) => 'Incorrect email format';
  }

  /// Returns a type document verification error message.
  static String Function(dynamic error) typeDocumentVerify() {
    return (error) => 'Incorrect document';
  }

  /// Returns an address verification error message.
  static String Function(dynamic error) addressVerify() {
    return (error) => 'Incorrect address';
  }

  /// Returns the decoration for a [DropdownButton] with a down arrow icon and optional [hintText].
  static InputDecoration decorationSelect({String? hintText}) {
    return InputDecoration(
      suffixIcon: const Padding(
        padding: EdgeInsets.only(right: 10),
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 40,
          color: Colors.grey,
        ),
      ),
      hintText: hintText ?? 'Select',
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
    );
  }

  /// Marks a control in the [form] as required and sets an error to indicate its required status.
  static void markedAsRequired(FormGroup form, String controlName) {
    form.control(controlName).value = null;
    form.control(controlName).setValidators([
      Validators.required,
    ]);
    form.control(controlName).setErrors({'required': true});
    form.control(controlName).markAllAsTouched();
    form.control(controlName).markAsDirty();
  }

  /// Clears the input value and validators for the specified [controlName] in the [form].
  static void clearInput(FormGroup form, String controlName) {
    form.control(controlName).setValidators([]);
    form.control(controlName).markAllAsTouched();
    form.control(controlName).markAsDirty();
    form.control(controlName).value = '';
  }

  /// Checks if at least one control in the [form] has a non-null value.
  static bool atLeastOneControlHasValue(FormGroup form) {
    bool hasValue = false;
    form.controls.forEach(
      (key, value) {
        if (value.value != null && value.value != '') {
          hasValue = true;
        }
      },
    );
    return hasValue;
  }
}
