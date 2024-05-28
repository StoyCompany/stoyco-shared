// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:stoyco_shared/form/fields/country_icon_field.dart';
import 'package:stoyco_shared/form/models/phone_number.dart';

/// A custom reactive form field for phone number input.
///
/// This widget extends [ReactiveFormField]. It displays a text field that allows
/// the user to input a phone number. The phone number is then validated and the
/// result is stored in a [PhoneNumber] object.
class ReactiveNewPhoneNumberInput<T> extends ReactiveFormField<T, PhoneNumber> {

  /// Creates a [ReactiveNewPhoneNumberInput].
  ///
  /// The [controller], [formControlName], [onTap], [onSubmitted], [onEditingComplete],
  /// [onChanged], [formControl], [originalValidators], [decoration], [showErrors],
  /// and [labelText] arguments are optional.
  ///
  ReactiveNewPhoneNumberInput({
    Key? key,
    this.readOnly,
    this.minHeight,
    this.maxHeight,
    this.borderLabelColor,
    this.showErrorsOnInit,
    TextEditingController? controller,
    String? formControlName,
    ReactiveFormFieldCallback<T>? onTap,
    ReactiveFormFieldCallback<T>? onSubmitted,
    ReactiveFormFieldCallback<T>? onEditingComplete,
    ReactiveFormFieldCallback<T>? onChanged,
    FormControl<T>? formControl,
    List<Validator<dynamic>>? originalValidators,
    InputDecoration decoration = const InputDecoration(),
    ShowErrorsFunction<T>? showErrors,
    String? labelText,
  })  : _textController = controller,
        super(
          key: key,
          formControl: formControl,
          formControlName: formControlName,
          validationMessages: {
            ValidationMessage.required: (_) =>
                'El número de celular es requerido',
            'invalid': (_) => 'Número de celular inválido',
            'requiredCountry': (error) => 'Debe seleccionar un país',
          },
          showErrors: (value) => value.invalid,
          focusNode: FocusNode(),
          builder: (ReactiveFormFieldState<T, PhoneNumber> field) {
            final state = field as _NewPhoneNumberInputState<T>;
            final effectiveDecoration = decoration
                .applyDefaults(Theme.of(state.context).inputDecorationTheme);

            return SizedBox(
              height: !field.control.invalid
                  ? (minHeight ?? 70)
                  : (maxHeight ?? 85),
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
                        errorText: state.wasTouched || showErrorsOnInit == true
                            ? field.errorText
                            : null,
                        errorBorder:
                            !state.wasTouched && showErrorsOnInit != true
                                ? effectiveDecoration.enabledBorder
                                : null,
                        prefixIcon: StoycoCountryPrefixIcon(
                          onCountryChanged: (Country country) {
                            field.didChangeCountryValue(country);
                          },
                          selectedCountry: field.value?.selectedCountry,
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
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.phone,
                      readOnly: readOnly ?? false,
                    ),
                  ),
                  Positioned(
                      top: 0,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3,),
                        decoration: ShapeDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment(1.00, 0.00),
                            end: Alignment(-1, 0),
                            colors: [Color(0xFF030A1A), Color(0xFF0C1B24)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: borderLabelColor ?? Colors.black,
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
                      ),),
                ],
              ),
            );
          },
        );
  /// The controller for the text field.
  final TextEditingController? _textController;

  /// The current value of the phone number.
  PhoneNumber currentValue = PhoneNumber();
  late bool touched;
  final double? minHeight;
  final double? maxHeight;
  final Color? borderLabelColor;
  final bool? readOnly;
  final bool? showErrorsOnInit;

  @override
  ReactiveFormFieldState<T, PhoneNumber> createState() =>
      _NewPhoneNumberInputState<T>();
}

/// [_NewPhoneNumberInputState] is a state object for [ReactiveNewPhoneNumberInput].
/// It extends [ReactiveFocusableFormFieldState] with a generic type [T] and a [PhoneNumber].
class _NewPhoneNumberInputState<T>
    extends ReactiveFocusableFormFieldState<T, PhoneNumber> {
  /// Controller for the text field.
  late TextEditingController _textController;

  /// Current value of the phone number.
  late PhoneNumber currentValue = PhoneNumber();

  /// Original validators for the form field.
  late List<Validator<dynamic>> originalValidators;
  late bool wasTouched;

  /// Initialize the state.
  @override
  void initState() {
    super.initState();
    wasTouched = false;
    _initializeTextController();
  }

  /// Called when the control's value changes.
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

  /// Initializes the text controller.
  void _initializeTextController() {
    final initialValue = value;
    final currentWidget = widget as ReactiveNewPhoneNumberInput<T>;
    if (initialValue != null) {
      currentValue = initialValue;
    }
    _textController = (currentWidget._textController != null)
        ? currentWidget._textController!
        : TextEditingController();
    _textController.text =
        initialValue == null ? '' : initialValue.number ?? '';
  }

  /// Called when the phone value changes.
  void didChangePhoneValue(String? value) {
    wasTouched = true;
    if (value != null) {
      currentValue = currentValue.copyWith(phoneNumber: value);
      didChange(currentValue);
      analyzeErrors();
    }
  }

  /// Called when the country value changes.
  void didChangeCountryValue(Country? country) {
    wasTouched = true;
    if (country != null) {
      currentValue = currentValue.copyWith(selectedCountry: country);
      didChange(currentValue);
      analyzeErrors();
    }
  }

  /// Analyzes the errors of the form field.
  void analyzeErrors() {
    if (wasTouched) {
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
  }

  /// Sets the original validators of the form field.
  void setOriginalValidators(List<Validator<dynamic>> validators) {
    originalValidators = validators;
  }
}

/// [PhoneNumberValueAccessor] is a value accessor for [PhoneNumber].
/// It extends [ControlValueAccessor] with a [PhoneNumber] and a [String].
class PhoneNumberValueAccessor
    extends ControlValueAccessor<PhoneNumber, String> {
  /// Converts the model value to view value.
  @override
  String modelToViewValue(PhoneNumber? modelValue) => modelValue == null ? '' : modelValue.toString();

  /// Converts the view value to model value.
  @override
  PhoneNumber? viewToModelValue(String? viewValue) => (viewValue == '' || viewValue == null)
        ? null
        : PhoneNumber(number: viewValue);
}
