import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/models/label_value_model.dart';

class MerchDetailVariantItem extends StatelessWidget {
  const MerchDetailVariantItem({
    required this.item,
    required this.isSelected,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    super.key,
  });

  final LabelValueModel item;
  final bool isSelected;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: isSelected ? 1.0 : 0.35,
        child: Container(
          padding: StoycoScreenSize.symmetric(
            context,
            vertical: 5,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
                BorderRadius.circular(StoycoScreenSize.radius(context, 100)),
          ),
          child: Text(
            item.label,
            style: TextStyle(
              color: textColor,
              fontSize: StoycoScreenSize.fontSize(context, fontSize),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
