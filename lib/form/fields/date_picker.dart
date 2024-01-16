import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stoyco_shared/form/fields/custom_date_picker.dart';
import 'package:stoyco_shared/form/forms.dart';

/// A custom date picker widget.
///
/// This widget extends [StatelessWidget]. It displays a date picker that allows
/// the user to select a date. The selected date is displayed in a text field.
class StoycoDatePicker extends StatelessWidget {
  /// Creates a [StoycoDatePicker].
  ///
  /// The [labelText], [firstDate], [hintText], and [formControlName] arguments are required.
  const StoycoDatePicker({
    super.key,
    required this.labelText,
    required this.firstDate,
    this.lastDate,
    required this.hintText,
    this.validationMessages,
    required this.formControlName,
  });

  /// The label text of the date picker.
  final String labelText;

  /// The earliest date that the user can select.
  final DateTime firstDate;

  /// The latest date that the user can select.
  final DateTime? lastDate;

  /// The hint text of the date picker.
  final String hintText;

  /// The validation messages for the date picker.
  final Map<String, String Function(Object)>? validationMessages;

  /// The name of the form control.
  final String formControlName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          // DatePicker(
          //   minDate: DateTime(2021, 1, 1),
          //   maxDate: DateTime.now(),
          // ),
          ReactiveDatePicker(
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
                  enableInteractiveSelection: false,
                  onTap: (value) async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final pickedDate = await showWebDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: firstDate,
                      lastDate: lastDate ?? DateTime.now(),
                      withoutActionButtons: true,
                    );
                    value.value = pickedDate ?? value.value;
                  },
                  suffixIcon: UnconstrainedBox(
                    child: SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/calendar.svg',
                      height: 20,
                      width: 20,
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
