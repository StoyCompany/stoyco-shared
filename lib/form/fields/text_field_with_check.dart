import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stoyco_shared/form/forms.dart';

/// A custom text field widget with a check mark.
///
/// This widget extends [StatefulWidget]. It displays a text field with a check mark
/// when the input is valid according to the provided validation function.
class StoycoTextFieldWithCheck extends StatefulWidget {
  /// Creates a [StoycoTextFieldWithCheck].
  ///
  /// The [formControlName] and [validate] arguments are required.
  const StoycoTextFieldWithCheck({
    super.key,
    this.labelText,
    this.hintText,
    this.validationMessages,
    required this.formControlName,
    required this.asyncValidate,
    this.inputFormatters,
    this.onChanged,
    this.readOnly,
    this.showErrorsOnInit,
  });

  /// The label text of the text field.
  final String? labelText;

  /// The hint text of the text field.
  final String? hintText;

  /// The name of the form control.
  final String? formControlName;

  /// The input formatters for the text field.
  final List<TextInputFormatter>? inputFormatters;

  /// The callback function that is called when the text field value changes.
  final void Function(FormControl<dynamic>)? onChanged;

  /// The validation messages for the text field.
  final Map<String, String Function(Object)>? validationMessages;

  /// The validation function for the text field.
  final Future<bool> Function(String?) asyncValidate;
  final bool? readOnly;
  final bool? showErrorsOnInit;

  @override
  State<StoycoTextFieldWithCheck> createState() =>
      _StoycoTextFieldWithCheckState();
}

class _StoycoTextFieldWithCheckState extends State<StoycoTextFieldWithCheck> {
  /// The validity of the text field value.
  bool isValid = false;

  /// The value of the text field.
  String value = '';

  /// Sets the value of the text field.
  set setValue(String value) {
    setState(() {
      this.value = value;
    });
  }

  @override
  Widget build(BuildContext context) => StoyCoTextFormField(
      formControlName: widget.formControlName,
      labelText: widget.labelText,
      hintText: widget.hintText,
      readOnly: widget.readOnly ?? false,
      inputFormatters: widget.inputFormatters ??
          <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[A-zÀ-ú]')),
          ],
      onChanged: (formControl) async {
        widget.onChanged?.call(formControl);
        final valueIsValid = await widget.asyncValidate(formControl.value);
        setState(() {
          setValue = formControl.value;

          if (!formControl.invalid) {
            isValid = valueIsValid;
          } else {
            isValid = false;
          }
        });
      },
      validationMessages:
          widget.validationMessages ?? StoycoForms.validationMessages(),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: isValid || widget.readOnly == true
            ? UnconstrainedBox(
                child: SvgPicture.asset(
                  'packages/stoyco_shared/lib/assets/icons/check_icon.svg',
                  width: 20,
                  height: 20,
                ),
              )
            : value.isNotEmpty || widget.showErrorsOnInit == true
                ? UnconstrainedBox(
                    child: SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/close_icon.svg',
                      width: 20,
                      height: 20,
                    ),
                  )
                : null,
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide(
            color: Color(0xFFDE2424),
          ),
        ),
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment(1.00, 0.00),
              end: Alignment(-1, 0),
              colors: [Color(0xFF030A1A), Color(0xFF0C1B24)],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            widget.labelText ?? '',
            style: const TextStyle(
              color: Color(0xFF92929D),
              fontSize: 12,
              fontFamily: 'Akkurat Pro',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF92929D),
          fontSize: 14,
          fontFamily: 'Akkurat Pro',
          fontWeight: FontWeight.w400,
          height: 0.08,
        ),
      ),
    );
}
