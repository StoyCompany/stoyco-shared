import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stoyco_shared/form/fields/text_field.dart';

const _spaceRegExp = r'[ ]';

/// A custom password field widget for Stoyco app.
///
/// This widget provides a password input field with customizable decoration,
/// form control name, label text, hint text, validation messages, and password visibility toggle.
///
/// Example usage:
/// ```dart
/// StoycoSimplePasswordField(
///   decoration: InputDecoration(
///     // custom decoration properties
///   ),
///   formControlName: 'password',
///   labelText: 'Password',
///   hintText: 'Enter your password',
///   validationMessages: {
///     // custom validation messages
///   },
/// )
/// ```
class StoycoSimplePasswordField extends StatefulWidget {
  const StoycoSimplePasswordField({
    super.key,
    this.decoration,
    required this.formControlName,
    required this.labelText,
    required this.hintText,
    this.validationMessages,
  });

  /// The decoration to be applied to the input field.
  final InputDecoration? decoration;

  /// The name of the form control associated with this password field.
  final String formControlName;

  /// The text to be displayed as the label for the input field.
  final String labelText;

  /// The text to be displayed as the hint for the input field.
  final String hintText;

  /// The validation messages to be displayed for this field.
  final Map<String, String Function(Object)>? validationMessages;

  @override
  State<StoycoSimplePasswordField> createState() =>
      _StoycoSimplePasswordFieldState();
}

class _StoycoSimplePasswordFieldState extends State<StoycoSimplePasswordField> {
  late bool obscurePassword = true;

  /// Toggles the visibility of the password.
  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) => StoyCoTextFormField(
        formControlName: widget.formControlName,
        labelText: widget.labelText,
        hintText: widget.hintText,
        validationMessages: widget.validationMessages,
        obscureText: obscurePassword,
        obscuringCharacter: '*',
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(
            RegExp(_spaceRegExp),
          ),
        ],
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          hintText: widget.hintText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorStyle: const TextStyle(height: 0),
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(1.00, 0.00),
                end: Alignment(-1, 0),
                colors: [Color(0xFF030A1A), Color(0xFF0C1B24)],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              widget.labelText,
              style: const TextStyle(
                color: Color(0xFF92929D),
                fontSize: 12,
                fontFamily: 'Akkurat Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              togglePasswordVisibility();
            },
            child: Icon(
              obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF92929D),
            ),
          ),
        ),
      );
}
