import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stoyco_shared/form/fields/phone_number_field.dart';
import 'package:stoyco_shared/form/models/phone_number.dart';

class PhoneNumberView extends StatelessWidget {
  const PhoneNumberView({super.key});

  FormGroup buildForm() => FormGroup({
        'phoneNumber': FormControl<PhoneNumber>(
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
              ReactiveNewPhoneNumberInput(
                formControl:
                    form.control('phoneNumber') as FormControl<PhoneNumber>,
                originalValidators: [
                  Validators.required,
                ],
                labelText: 'Número de celular',
              ),
              const SizedBox(height: 16.0),
            ],
          );
        });
  }
}
