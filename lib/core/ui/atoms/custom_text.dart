import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';

/// This is the first version of CustomText.
/// A custom text widget that allows for optional styling and font size adjustments.
/// If no style is provided, it defaults to a predefined style with a specific font size
/// based on the screen size.

class CustomText extends StatelessWidget {
  const CustomText(
    this.data, {
    super.key,
    this.style,
    this.fontSize,
  });

  /// The text to be displayed.
  final String data;

  /// Optional text style to override the default style.
  final TextStyle? style;

  /// Optional font size to override the default size.
  final double? fontSize;

  @override
  Widget build(BuildContext context) => Text(
        data,
        style: style ??
            TextStyle(
              fontSize: fontSize ??
                  StoycoScreenSize.width(
                    context,
                    14,
                    phone: 14,
                  ),
              color: StoycoColors.iconDefault,
            ),
      );
}
