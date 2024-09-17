import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stoyco_shared/form/form.dart';
import 'package:stoyco_shared/utils/modal.dart';

/// A dropdown field with a modal for selecting options.
///
/// This widget is used to display a dropdown field with a modal that allows the user to select an option from a list of options.
/// It is typically used within a form to capture user input.
///
/// The [StoycoDropDownFielWithModal] requires the following parameters:
/// - [formControlName]: The name of the form control associated with the dropdown field.
/// - [options]: A list of strings representing the available options for selection.
/// - [title]: An optional title to display in the modal.
/// - [label]: An optional label to display for the dropdown field.
/// - [validationMessages]: An optional map of validation messages for the dropdown field.
///
/// Example usage:
/// ```dart
/// StoycoDropDownFielWithModal(
///   formControlName: 'dropdownField',
///   options: ['Option 1', 'Option 2', 'Option 3'],
///   title: 'Select an option',
///   label: 'Dropdown Field',
///   validationMessages: {
///     'required': 'This field is required',
///   },
/// )
/// ```

class StoycoDropDownFielWithModal extends StatelessWidget {
  const StoycoDropDownFielWithModal({
    super.key,
    required this.options,
    required this.formControlName,
    this.title,
    this.label,
    this.hintText,
    this.validationMessages,
  });
  final String formControlName;
  final List<String> options;
  final String? title;
  final String? label;
  final String? hintText;
  final Map<String, String Function(Object)>? validationMessages;

  @override
  Widget build(BuildContext context) => StoyCoTextFormField(
        formControlName: formControlName,
        labelText: label,
        hintText: title,
        validationMessages: validationMessages,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: UnconstrainedBox(
            child: SvgPicture.asset(
              'packages/stoyco_shared/lib/assets/icons/arrow-down-icon.svg',
              height: 20,
              width: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xFFF2F2FA),
                BlendMode.srcIn,
              ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              label ?? '',
              style: const TextStyle(
                color: Color(0xFF92929D),
                fontSize: 12,
                fontFamily: 'Akkurat Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        readOnly: true,
        onTap: (_) async {
          final value = await showSelectOptionModal(
            context: context,
            title: title ?? '',
            options: options,
            selectedOption: _.value,
          );

          _.value = value;
        },
      );
}

/// Shows a modal dialog for selecting an option from a list.
///
/// The [context] parameter is the build context.
/// The [title] parameter is the title of the modal dialog.
/// The [options] parameter is the list of available options.
/// The [selectedOption] parameter is the currently selected option.
///
/// Returns a [Future] that completes with the selected option.

Future<String?> showSelectOptionModal({
  required BuildContext context,
  required String title,
  required List<String> options,
  required String? selectedOption,
}) async =>
    await showStoycoModal(
      context: context,
      title: title,
      height: 300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (context, index) => Container(
          height: 18,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 9),
          child: GestureDetector(
            onTap: () {
              selectedOption = options[index];
              Navigator.of(context).pop(selectedOption);
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    options[index],
                    style: const TextStyle(
                      fontFamily: 'Akkurat Pro',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xfff2f2fa),
                      height: 16 / 14,
                    ),
                  ),
                ),
                if (selectedOption == options[index])
                  const Icon(
                    Icons.check,
                    size: 18,
                  )
                else
                  Container(),
              ],
            ),
          ),
        ),
      ),
    );
