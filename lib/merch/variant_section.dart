import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/merch/list_variant.dart';
import 'package:stoyco_shared/models/label_value_model.dart';

class VariantSection extends StatelessWidget {
  const VariantSection({
    required this.title,
    required this.titleFontSize,
    required this.titleColor,
    required this.spacing,
    required this.items,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    required this.onSelected,
    required this.listHeight,
    super.key,
  });

  final String title;
  final double titleFontSize;
  final Color titleColor;
  final double spacing;
  final List<LabelValueModel> items;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final void Function(LabelValueModel) onSelected;
  final double listHeight;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: StoycoScreenSize.fontSize(context, titleFontSize),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: StoycoScreenSize.height(context, spacing),
          ),
          SizedBox(
            height: listHeight,
            child: ListVariant(
              items: items,
              backgroundColor: backgroundColor,
              textColor: textColor,
              fontSize: fontSize,
              onSelected: onSelected,
            ),
          ),
        ],
      );
}
