import 'dart:developer';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:stoyco_shared/utils/modal.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stoyco_shared/form/fields/cupertino_date_picker.dart';

/// A modal widget that displays a date picker.
///
/// This widget is used to select a date from a range of dates.
/// It provides options for setting the label text, the first date,
/// the last date, the hint text, the validation messages, and the
/// form control name.
class StoycoDatePickerModal extends StatefulWidget {
  /// Creates a [StoycoDatePickerModal].
  ///
  /// The [labelText], [firstDate], [hintText], and [formControlName] arguments are required.
  const StoycoDatePickerModal({
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
  State<StoycoDatePickerModal> createState() => _StoycoDatePickerModalState();
}

/// This is the state class for the StoycoDatePickerModal widget.
/// It manages the state and behavior of the date picker modal.
class _StoycoDatePickerModalState extends State<StoycoDatePickerModal> {
  final TextEditingController controller = TextEditingController();
  bool touched = false;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            ReactiveDatePicker(
              formControlName: widget.formControlName,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate ?? DateTime.now(),
              locale: const Locale('es'),
              builder: (BuildContext context, picker, child) => TextFormField(
                controller: controller,
                onChanged: (value) => picker.control.value = value,
                style: const TextStyle(
                  color: Color(0xFFF2F2FA),
                  fontSize: 16,
                  fontFamily: 'Akkurat Pro',
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: UnconstrainedBox(
                    child: SvgPicture.asset(
                      'packages/stoyco_shared/lib/assets/icons/calendar.svg',
                      height: 20,
                      width: 20,
                      color: controller.text.isNotEmpty
                          ? Colors.white
                          : touched && controller.text.isEmpty
                              ? const Color(0xFFE02020)
                              : const Color(0xFF92929D),
                    ),
                  ),
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
                      widget.labelText,
                      style: const TextStyle(
                        color: Color(0xFF92929D),
                        fontSize: 12,
                        fontFamily: 'Akkurat Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  errorText:
                      touched && controller.text.isEmpty ? 'Requerido' : null,
                  errorStyle: const TextStyle(
                    color: Color(0xFFE02020),
                    fontSize: 12,
                    fontFamily: 'Akkurat Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  try {
                    final result = await showDatePickerStoyco(
                      context,
                      minDate: widget.firstDate,
                      maxDate: widget.lastDate ?? DateTime.now(),
                      selectedDate: picker.control.value as DateTime?,
                    );
                    picker.control.value = result;

                    setState(() {
                      controller.text = DateFormat('dd/MM/yyyy')
                          .format(picker.control.value as DateTime);
                    });
                  } catch (e) {
                    log(e.toString());
                  } finally {
                    setState(() {
                      touched = true;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      );
}

/// Displays a custom date picker in a Stoyco modal.
///
/// Returns the selected date as a [DateTime] object.
///
/// The [context] parameter specifies the application context.
/// The [maxDate] parameter specifies the maximum selectable date.
/// The [selectedDate] parameter specifies the initially selected date.
/// The [minDate] parameter specifies the minimum selectable date.
///
/// Example usage:
/// ```dart
/// DateTime? selectedDate = await showDatePickerStoyco(context);
/// ```
Future<DateTime> showDatePickerStoyco(
  BuildContext context, {
  DateTime? maxDate,
  DateTime? selectedDate,
  DateTime? minDate,
}) async =>
    await showStoycoModal(
      context: context,
      child: Column(
        children: [
          Container(
            height: 2,
            width: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xff92929d),
            ),
          ),
          const Gap(36),
          StoycoCupertinoDatePicker(
            backgroundColor: Colors.transparent,
            itemExtent: 29,
            onSelectedItemChanged: (_) {},
            minDate: minDate ?? DateTime(1900),
            maxDate: maxDate ?? DateTime.now(),
            selectedDate: selectedDate ?? maxDate ?? DateTime.now(),
          ),
        ],
      ),
    );
