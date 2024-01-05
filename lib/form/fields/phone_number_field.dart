// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:stoyco_shared/form/fields/country_icon_field.dart';
import 'package:stoyco_shared/form/models/phone_number.dart';

class ReactiveNewPhoneNumberInput<T> extends ReactiveFormField<T, PhoneNumber> {
  final TextEditingController? _textController;

  PhoneNumber currentValue = PhoneNumber();
  ReactiveNewPhoneNumberInput({
    super.key,
    TextEditingController? controller,
    String? formControlName,
    ReactiveFormFieldCallback<T>? onTap,
    ReactiveFormFieldCallback<T>? onSubmitted,
    ReactiveFormFieldCallback<T>? onEditingComplete,
    ReactiveFormFieldCallback<T>? onChanged,
    super.formControl,
    List<Validator<dynamic>>? originalValidators,
    InputDecoration decoration = const InputDecoration(),
    ShowErrorsFunction<T>? showErrors,
    String? labelText,
  })  : _textController = controller,
        super(
          showErrors: (value) {
            return value.value != null && value.invalid;
          },
          validationMessages: {
            ValidationMessage.required: (_) => 'Requerido',
            'invalid': (_) => 'Número de celular inválido',
            'requiredCountry': (error) => 'Debe seleccionar un país',
          },
          builder: (ReactiveFormFieldState<T, PhoneNumber> field) {
            final state = field as _NewPhoneNumberInputState<T>;
            final effectiveDecoration = decoration
                .applyDefaults(Theme.of(state.context).inputDecorationTheme);

            return Container(
              height: 80,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: TextField(
                      controller: field._textController,
                      onTap: onTap != null ? () => onTap(field.control) : null,
                      decoration: effectiveDecoration.copyWith(
                        errorText: state.errorText,
                        prefixIcon: StoycoCountryPrefixIcon(
                          onCountryChanged: (Country country) {
                            field.didChangeCountryValue(country);
                          },
                        ),
                      ),
                      onSubmitted: onSubmitted != null
                          ? (_) => onSubmitted(field.control)
                          : null,
                      onEditingComplete: onEditingComplete != null
                          ? () => onEditingComplete.call(field.control)
                          : null,
                      onChanged: (value) {
                        field.didChangePhoneValue(value);

                        onChanged?.call(field.control);
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  Positioned(
                      top: 0,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: ShapeDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment(1.00, 0.00),
                            end: Alignment(-1, 0),
                            colors: [Color(0xFF030A1A), Color(0xFF0C1B24)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          labelText ?? '',
                          style: const TextStyle(
                            color: Color(0xFF92929D),
                            fontSize: 8,
                            fontFamily: 'Akkurat Pro',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )),
                ],
              ),
            );
          },
        );
  @override
  ReactiveFormFieldState<T, PhoneNumber> createState() =>
      _NewPhoneNumberInputState<T>();
}

class _NewPhoneNumberInputState<T>
    extends ReactiveFocusableFormFieldState<T, PhoneNumber> {
  late TextEditingController _textController;
  late PhoneNumber currentValue = PhoneNumber();
  late List<Validator<dynamic>> originalValidators;

  @override
  void initState() {
    super.initState();
    _initializeTextController();
  }

  @override
  void onControlValueChanged(dynamic value) {
    final effectiveValue = (value == null) ? '' : value.toString();
    _textController.value = _textController.value.copyWith(
      text: effectiveValue,
      selection: TextSelection.collapsed(offset: effectiveValue.length),
      composing: TextRange.empty,
    );
    analyzeErrors();
    super.onControlValueChanged(value);
  }

  @override
  ControlValueAccessor<T, PhoneNumber> selectValueAccessor() {
    if (control is FormControl<int>) {
      return IntValueAccessor() as ControlValueAccessor<T, PhoneNumber>;
    } else if (control is FormControl<double>) {
      return DoubleValueAccessor() as ControlValueAccessor<T, PhoneNumber>;
    } else if (control is FormControl<DateTime>) {
      return DateTimeValueAccessor() as ControlValueAccessor<T, PhoneNumber>;
    } else if (control is FormControl<TimeOfDay>) {
      return TimeOfDayValueAccessor() as ControlValueAccessor<T, PhoneNumber>;
    }

    return super.selectValueAccessor();
  }

  void _initializeTextController() {
    final initialValue = value;
    final currentWidget = widget as ReactiveNewPhoneNumberInput<T>;
    _textController = (currentWidget._textController != null)
        ? currentWidget._textController!
        : TextEditingController();
    _textController.text = initialValue == null ? '' : initialValue.toString();
  }

  void didChangePhoneValue(String? value) {
    if (value != null) {
      currentValue = currentValue.copyWith(phoneNumber: value);
      didChange(currentValue);
      analyzeErrors();
    }
  }

  void didChangeCountryValue(Country? country) {
    if (country != null) {
      currentValue = currentValue.copyWith(selectedCountry: country);
      didChange(currentValue);
      analyzeErrors();
    }
  }

  void analyzeErrors() {
    if (!currentValue.isValid) {
      control.setErrors({
        'invalid': true,
      });
    }

    if (currentValue.numberIsEmpty) {
      control.setErrors({
        'required': true,
      });
    }

    if (currentValue.countryIsEmpty && !currentValue.numberIsEmpty) {
      control.setErrors({
        'requiredCountry': true,
      });
    }

    control.markAsUntouched();
  }

  void setOriginalValidators(List<Validator<dynamic>> validators) {
    originalValidators = validators;
  }
}

class PhoneNumberValueAccessor
    extends ControlValueAccessor<PhoneNumber, String> {
  @override
  String modelToViewValue(PhoneNumber? modelValue) {
    return modelValue == null ? '' : modelValue.toString();
  }

  @override
  PhoneNumber? viewToModelValue(String? viewValue) {
    return (viewValue == '' || viewValue == null)
        ? null
        : PhoneNumber(number: viewValue);
  }
}
