import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class StoyCoTextFormField extends ReactiveTextField {
  final String? labelText;
  final String? hintText;
  final InputDecoration? decoration;
  StoyCoTextFormField({
    super.key,
    super.onChanged,
    super.formControlName,
    super.inputFormatters,
    super.validationMessages,
    super.onTap,
    this.labelText,
    this.hintText,
    this.decoration,
    super.readOnly,
    super.mouseCursor,
    super.showCursor,
    super.enableInteractiveSelection,
    super.showErrors,
    super.formControl,
    super.keyboardType,
  }) : super(
          style: const TextStyle(
            color: Color(0xFFF2F2FA),
            fontSize: 16,
            fontFamily: 'Akkurat Pro',
            fontWeight: FontWeight.w700,
          ),
          decoration: decoration ??
              InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                label: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                    labelText ?? '',
                    style: const TextStyle(
                      color: Color(0xFF92929D),
                      fontSize: 12,
                      fontFamily: 'Akkurat Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                hintText: hintText,
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
