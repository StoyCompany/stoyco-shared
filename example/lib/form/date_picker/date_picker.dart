import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stoyco_shared/form/fields/date_picker.dart';

class DatePickerView extends StatelessWidget {
  const DatePickerView({super.key});

  FormGroup buildForm() => FormGroup({
        'birthDate': FormControl<DateTime>(
          validators: [
            Validators.required,
          ],
        ),
      });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return Column(
            children: <Widget>[
              const SizedBox(height: 50.0),
              StoycoDatePicker(
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                hintText: 'Fecha de nacimiento',
                labelText: 'Fecha de nacimiento',
                formControlName: 'birthDate',
              ),
              const SizedBox(height: 16.0),
            ],
          );
        });
  }
}
