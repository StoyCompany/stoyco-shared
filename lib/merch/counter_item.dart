import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';

/// A circular button displaying text.
///
/// Used as increment/decrement buttons in [CounterSection].
class CounterItem extends StatelessWidget {
  /// Creates a [CounterItem].
  const CounterItem({
    required this.text,
    required this.width,
    required this.height,
    required this.textColor,
    required this.backgroundColor,
    required this.fontSize,
    super.key,
  });

  /// The text displayed in the center (e.g., '+' or '-').
  final String text;

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

  @override
  Widget build(BuildContext context) => Container(
        width: StoycoScreenSize.width(context, width),
        height: StoycoScreenSize.height(context, height),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: StoycoScreenSize.fontSize(context, fontSize),
            ),
          ),
        ),
      );
}
