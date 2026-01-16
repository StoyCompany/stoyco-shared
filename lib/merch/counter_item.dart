import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';

class CounterItem extends StatelessWidget {
  const CounterItem({
    required this.text,
    required this.width,
    required this.height,
    required this.textColor,
    required this.backgroundColor,
    required this.fontSize,
    super.key,
  });

  final String text;
  final double width;
  final double height;
  final Color textColor;
  final Color backgroundColor;
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
