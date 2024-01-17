import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stoyco_shared/form/fields/drop_down_field.dart';

class SelectView extends StatelessWidget {
  const SelectView({super.key});

  FormGroup buildForm() => FormGroup({
        'select': FormControl<String>(
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
              StoycoDropdown(
                formControl: form.control('select') as FormControl<String>,
                formControlName: 'select',
                options: const ['1', '2', '3'],
                labelText: 'Número de celular',
              ),
              const SizedBox(height: 16.0),
            ],
          );
        });
  }
}
