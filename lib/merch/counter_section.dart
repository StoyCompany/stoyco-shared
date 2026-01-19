import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/merch/counter_item.dart';
import 'package:stoyco_shared/merch/counter_value.dart';

class CounterSection extends StatefulWidget {
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

  final int minValue;
  final int maxValue;
  final Color itemTextColor;
  final Color itemBackgroundColor;
  final double itemFontSize;
  final Color valueTextColor;
  final Color valueBackgroundColor;
  final double valueFontSize;
  final void Function(int, bool) onChanged;

  @override
  State<CounterSection> createState() => _CounterSectionState();
}

class _CounterSectionState extends State<CounterSection> {
  late int currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.minValue;
  }

  void _decrement() {
    if (currentValue > widget.minValue) {
      setState(() {
        currentValue--;
      });
      widget.onChanged(currentValue, currentValue >= widget.minValue);
    }
  }

  void _increment() {
    if (currentValue < widget.maxValue) {
      setState(() {
        currentValue++;
      });
      widget.onChanged(currentValue, true);
    }
  }

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
