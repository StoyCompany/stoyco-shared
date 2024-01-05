import 'package:flutter/material.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:stoyco_shared/form/fields/text_field.dart';
import 'package:stoyco_shared/form/forms.dart';

class StoycoDatePicker extends StatelessWidget {
  final String labelText;
  final String formControlName;
  final String hintText;

  final DateTime firstDate;
  final DateTime? lastDate;
  final Map<String, String Function(Object)>? validationMessages;

  const StoycoDatePicker({
    super.key,
    required this.labelText,
    required this.firstDate,
    this.lastDate,
    required this.hintText,
    this.validationMessages,
    required this.formControlName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ReactiveDatePicker(
        formControlName: formControlName,
        firstDate: firstDate,
        lastDate: lastDate ?? DateTime.now(),
        locale: const Locale('es'),
        builder: (BuildContext context, picker, child) {
          return StoyCoTextFormField(
              labelText: labelText,
              hintText: hintText,
              formControlName: 'birthDate',
              validationMessages:
                  validationMessages ?? StoycoForms.validationMessages(),
              onTap: (value) {
                picker.showPicker();
              });
        },
      ),
    );
  }
}
