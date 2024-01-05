// ignore_for_file: avoid_annotating_with_dynamic, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

export 'package:stoyco_shared/form/fields/text_field.dart';
export 'package:stoyco_shared/form/fields/date_picker.dart';
export 'package:stoyco_shared/form/fields/drop_down_field.dart';
export 'package:stoyco_shared/form/fields/country_icon_field.dart';
export 'package:stoyco_shared/form/fields/phone_number_field.dart';
export 'package:stoyco_shared/form/fields/text_field_with_check.dart';

class StoycoForms {
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

  static Map<String, String Function(dynamic error)>
      validationMessagesWithParameters(
    Map<String, String Function(dynamic error)> validators,
  ) {
    return {
      ...validationMessages(),
      ...validators,
    };
  }

  static TextInputType keyBoarTypeByFormControl(String? formControlName) {
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

  static String Function(dynamic error) requiredMessage() {
    return (error) => 'Requerido';
  }

  static String Function(dynamic error) numberMessage() {
    return (error) => 'Debe ser un número';
  }

  static String Function(dynamic error) numberMax() {
    return (error) => '$error';
  }

  static String Function(dynamic error) numberMin() {
    return (error) => '$error';
  }

  static String Function(dynamic error) maxLength() {
    return (error) => '${error['actualLength']}/${error['requiredLength']}';
  }

  static String Function(dynamic error) minLength() {
    return (error) => '${error['actualLength']}/${error['requiredLength']}';
  }

  static String Function(dynamic error) pattern() {
    return (error) {
      Map<String, String> patternMessages = {
        r'^[a-zA-Z0-9 ]+$': 'Solo se permiten letras y números.',
        r'^[a-zA-Z]+$': 'Solo se permiten letras.',
        r'^[0-9]+$': 'Solo se permiten números.',
        r'^(?![_*0-9])[a-zA-Z0-9_*.,-]{3,20}$':
            'Solo se permiten letras, números y los caracteres especiales: *, _, ., -',
      };

      String pattern = error['requiredPattern'];
      return patternMessages[pattern] ??
          'Debe coincidir con el patrón: "$pattern"';
    };
  }

  static String Function(dynamic error) email() {
    return (error) => 'Correo electrónico incorrecto';
  }

  static String Function(dynamic error) typeDocumentVerify() {
    return (error) => 'Documento incorrecto';
  }

  static String Function(dynamic error) addressVerify() {
    return (error) => 'Dirección incorrecta';
  }

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
      hintText: hintText ?? 'Seleccionar',
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
    );
  }

  static void markedAsRequired(FormGroup form, String controlName) {
    form.control(controlName).value = null;
    form.control(controlName).setValidators([
      Validators.required,
    ]);
    form.control(controlName).setErrors({'required': true});
    form.control(controlName).markAllAsTouched();
    form.control(controlName).markAsDirty();
  }

  static void clearInput(FormGroup form, String controlName) {
    form.control(controlName).setValidators([]);
    form.control(controlName).markAllAsTouched();
    form.control(controlName).markAsDirty();
    form.control(controlName).value = '';
  }

  static bool atLeastOneControlHasValue(
    FormGroup form,
  ) {
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
