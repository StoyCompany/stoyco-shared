import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';

/// A circular text field for displaying and editing counter values.
///
/// Used as the central value display in [CounterSection].
/// Allows manual text input and maintains focus state properly.
class CounterValue extends StatefulWidget {
  /// Creates a [CounterValue].
  const CounterValue({
    required this.value,
    required this.width,
    required this.height,
    required this.textColor,
    required this.backgroundColor,
    required this.fontSize,
    required this.onChanged,
    super.key,
  });

  /// The current value displayed in the text field.
  final String value;

  /// The width of the circular container.
  final double width;

  /// The height of the circular container.
  final double height;

  /// The color of the text.
  final Color textColor;

  /// The background color of the circle.
  final Color backgroundColor;

  /// The font size of the text.
  final double fontSize;

  /// Callback triggered when the text value changes.
  final void Function(String) onChanged;

  @override
  State<CounterValue> createState() => _CounterValueState();
}

class _CounterValueState extends State<CounterValue> {
  /// Controller for the text field to maintain focus and value.
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  /// Updates the text field when the widget value changes externally.
  ///
  /// Only updates if the new value differs from both the old widget
  /// value and the current controller text.
  @override
  void didUpdateWidget(CounterValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  /// Disposes the text editing controller.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        width: StoycoScreenSize.width(context, widget.width),
        height: StoycoScreenSize.height(context, widget.height),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.textColor,
            fontSize: StoycoScreenSize.fontSize(context, widget.fontSize),
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
}
