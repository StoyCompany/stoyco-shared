import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A custom checkbox field widget with a label for Flutter applications using reactive forms.
class StoycoCheckBoxField extends StatefulWidget {
  /// The text to be displayed as the label for the checkbox.
  final String labelText;

  /// The form control associated with the checkbox.
  final FormControl<bool> formControl;

  /// A callback function that will be triggered when the label text is tapped.
  final void Function()? textAction;

  /// Creates a [StoycoCheckBoxField].
  ///
  /// The [labelText] parameter is required to set the label text for the checkbox.
  ///
  /// The [formControl] parameter is required to bind the checkbox to a reactive form control.
  ///
  /// The optional [textAction] parameter is a callback function that will be triggered when the label text is tapped.
  const StoycoCheckBoxField({
    Key? key,
    required this.labelText,
    required this.formControl,
    this.textAction,
  }) : super(key: key);

  @override
  State<StoycoCheckBoxField> createState() => _StoycoCheckBoxFieldState();
}

class _StoycoCheckBoxFieldState extends State<StoycoCheckBoxField> {
  bool value = false;

  @override
  void initState() {
    super.initState();
    value = widget.formControl.value ?? false;
  }

  /// Sets the state and updates the value of the checkbox.
  void setValue(bool newValue) {
    setState(() {
      value = newValue;
    });
    widget.formControl.value = newValue;
  }

  /// Builds the checkbox UI.
  Widget buildCheckBox() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: value ? const Color(0xFF4639E7) : Colors.transparent,
        border: Border.all(
          color: value ? const Color(0xFF4639E7) : const Color(0xFFFAFAFA),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: value
          ? SvgPicture.asset(
              'packages/stoyco_shared/lib/assets/icons/done_white_18dp.svg',
              color: const Color(0xFFFAFAFA),
              width: 16,
              height: 16,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setValue(!value);
            },
            child: buildCheckBox(),
          ),
        ),
        const Gap(8),
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.textAction,
              child: Text(
                widget.labelText,
                style: const TextStyle(
                  color: Color(0xFFF2F2FA),
                  fontSize: 14,
                  fontFamily: 'Akkurat Pro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
