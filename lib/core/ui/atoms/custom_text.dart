import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/colors.dart';
import 'package:stoyco_shared/design/screen_size.dart';

class CustomText extends StatelessWidget {
  const CustomText(
    this.data, {
    super.key,
    this.style,
    this.termsFontSize,
  });

  final String data;
  final TextStyle? style;
  final double? termsFontSize;

  @override
  Widget build(BuildContext context) => Text(
        data,
        style: style ??
            TextStyle(
              fontSize: termsFontSize ??
                  StoycoScreenSize.width(
                    context,
                    14,
                    phone: 14,
                  ),
              color: StoycoColors.iconDefault,
            ),
      );
}
