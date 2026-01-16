import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';

class CounterValue extends StatefulWidget {
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

  final String value;
  final double width;
  final double height;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;
  final void Function(String) onChanged;

  @override
  State<CounterValue> createState() => _CounterValueState();
}

class _CounterValueState extends State<CounterValue> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(CounterValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

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
