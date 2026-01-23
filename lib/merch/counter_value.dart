import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late FocusNode _focusNode;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _scrollController = ScrollController();
  }

  /// Scrolls to the end of the text after a brief delay.
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Custom formatter that prevents empty values.
  ///
  /// If the user tries to delete all text, it replaces with "0".
  TextInputFormatter get _preventEmptyFormatter =>
      TextInputFormatter.withFunction((oldValue, newValue) {
        if (newValue.text.isEmpty) {
          return const TextEditingValue(
            text: '0',
            selection: TextSelection.collapsed(offset: 1),
          );
        }
        return newValue;
      });

  /// Updates the text field when the widget value changes externally.
  ///
  /// Only updates if the new value differs from both the old widget
  /// value and the current controller text.
  @override
  void didUpdateWidget(CounterValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
      _scrollToEnd();
    }
  }

  /// Disposes the text editing controller, focus node, and scroll controller.
  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: Container(
          width: StoycoScreenSize.width(context, widget.width),
          height: StoycoScreenSize.height(context, widget.height),
          padding: StoycoScreenSize.all(context, 5),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            shape: BoxShape.circle,
            
          ),
          child: Stack(
            children: [
              // Hidden TextField for input
              Opacity(
                opacity: 0,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _preventEmptyFormatter,
                  ],
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: StoycoScreenSize.fontSize(context, widget.fontSize),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              // Visible Text display
              Center(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    widget.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: StoycoScreenSize.fontSize(context, widget.fontSize),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
