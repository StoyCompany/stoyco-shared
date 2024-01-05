import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stoyco_shared/form/fields/text_field.dart';
import 'package:stoyco_shared/form/forms.dart';

class StoycoTextFieldWithCheck extends StatefulWidget {
  const StoycoTextFieldWithCheck({
    super.key,
    this.labelText,
    this.hintText,
    this.validationMessages,
    required this.formControlName,
    required this.validate,
    this.inputFormatters,
    this.onChanged,
  });

  final String? labelText;
  final String? hintText;
  final String? formControlName;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(FormControl<dynamic>)? onChanged;
  final Map<String, String Function(Object)>? validationMessages;
  final bool Function(String?) validate;

  @override
  State<StoycoTextFieldWithCheck> createState() =>
      _StoycoTextFieldWithCheckState();
}

class _StoycoTextFieldWithCheckState extends State<StoycoTextFieldWithCheck> {
  bool isValid = false;
  String value = '';

  set setValue(String value) {
    setState(() {
      this.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoyCoTextFormField(
      formControlName: widget.formControlName,
      labelText: widget.labelText,
      hintText: widget.hintText,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[A-zÀ-ú]")),
      ],
      onChanged: (formControl) {
        widget.onChanged?.call(formControl);
        setState(() {
          setValue = formControl.value;

          if (!formControl.invalid) {
            isValid = widget.validate(formControl.value);
          } else {
            isValid = false;
          }
        });
      },
      validationMessages:
          widget.validationMessages ?? StoycoForms.validationMessages(),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: isValid
            ? UnconstrainedBox(
                child: SvgPicture.asset(
                  'assets/icons/forms/check_outline.svg',
                  width: 20,
                  height: 20,
                ),
              )
            : value.isNotEmpty
                ? UnconstrainedBox(
                    child: SvgPicture.asset(
                      'assets/icons/forms/close.svg',
                      width: 20,
                      height: 20,
                    ),
                  )
                : null,
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: Color(0xFFDE2424),
            width: 1,
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
}
