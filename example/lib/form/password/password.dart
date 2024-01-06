import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stoyco_shared/form/fields/password_field.dart';

class Password extends StatelessWidget {
  const Password({super.key});

  FormGroup buildForm() => FormGroup({
        'password': FormControl<String>(value: ''),
      });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return Column(
            children: <Widget>[
              const SizedBox(height: 50.0),
              StoycoPasswordField(
                formControlName: 'password',
                formControl: form.control('password') as FormControl<String>,
                labelText: 'Contraseña',
                hintText: 'Ingresar',
              ),
              const SizedBox(height: 16.0),
            ],
          );
        });
  }
}
