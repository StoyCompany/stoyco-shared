import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/merch/counter_item.dart';
import 'package:stoyco_shared/merch/counter_value.dart';

/// A counter widget with increment/decrement buttons and manual input.
///
/// Displays a row with:
/// - A decrement button (-)
/// - A text field showing the current value
/// - An increment button (+)
///
/// The [onChanged] callback provides both the current value and
/// a boolean indicating if the value is valid (within min/max range).
/// Button actions always produce valid values, while manual input
/// may produce invalid values if outside the range.
class CounterSection extends StatefulWidget {
  /// Creates a [CounterSection].
  const CounterSection({
    required this.minValue,
    required this.maxValue,
    required this.itemTextColor,
    required this.itemBackgroundColor,
    required this.itemFontSize,
    required this.valueTextColor,
    required this.valueBackgroundColor,
    required this.valueFontSize,
    required this.onChanged,
    super.key,
  });

  /// The minimum allowed value.
  final int minValue;

  /// The maximum allowed value.
  final int maxValue;

  /// The text color for increment/decrement buttons.
  final Color itemTextColor;

  /// The background color for increment/decrement buttons.
  final Color itemBackgroundColor;

  /// The font size for increment/decrement buttons.
  final double itemFontSize;

  /// The text color for the value display.
  final Color valueTextColor;

  /// The background color for the value display.
  final Color valueBackgroundColor;

  /// The font size for the value display.
  final double valueFontSize;

  /// Callback triggered when the value changes.
  ///
  /// Parameters:
  /// - `int`: The current value
  /// - `bool`: Whether the value is valid (within min/max range)
  final void Function(int, bool) onChanged;

  @override
  State<CounterSection> createState() => _CounterSectionState();
}

class _CounterSectionState extends State<CounterSection> {
  /// The current counter value.
  late int currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.minValue;
  }

  /// Decreases the counter value by 1 if above [minValue].
  ///
  /// Triggers [onChanged] with the new value and validity status.
  void _decrement() {
    if (currentValue > widget.minValue) {
      setState(() {
        currentValue--;
      });
      widget.onChanged(currentValue, currentValue >= widget.minValue);
    }
  }

  /// Increases the counter value by 1 if below [maxValue].
  ///
  /// Triggers [onChanged] with the new value and `true` for validity.
  void _increment() {
    if (currentValue < widget.maxValue) {
      setState(() {
        currentValue++;
      });
      widget.onChanged(currentValue, true);
    }
  }

  /// Handles manual text input from the [CounterValue] widget.
  ///
  /// Parses the input and validates against [minValue] and [maxValue].
  /// Allows values outside the range but reports them as invalid.
  void _onTextChanged(String value) {
    final parsed = int.tryParse(value) ?? 0;
    final isValid = parsed >= widget.minValue && parsed <= widget.maxValue;
    setState(() {
      currentValue = parsed;
    });
    widget.onChanged(parsed, isValid);
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        spacing: StoycoScreenSize.width(context, 8),
        children: [
          GestureDetector(
            onTap: _decrement,
            child: CounterItem(
              text: '-',
              width: 24,
              height: 24,
              textColor: widget.itemTextColor,
              backgroundColor: widget.itemBackgroundColor,
              fontSize: widget.itemFontSize,
            ),
          ),
          CounterValue(
            value: currentValue.toString(),
            width: 40,
            height: 40,
            textColor: widget.valueTextColor,
            backgroundColor: widget.valueBackgroundColor,
            fontSize: widget.valueFontSize,
            onChanged: _onTextChanged,
          ),
          GestureDetector(
            onTap: _increment,
            child: CounterItem(
              text: '+',
              width: 24,
              height: 24,
              textColor: widget.itemTextColor,
              backgroundColor: widget.itemBackgroundColor,
              fontSize: widget.itemFontSize,
            ),
          ),
        ],
      );
}
