import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/models/label_value_model.dart';

/// A selectable variant item for merch details.
///
/// Displays a rounded container with text that changes opacity
/// based on selection state. When selected, opacity is 1.0;
/// when not selected, opacity is 0.35.
class MerchDetailVariantItem extends StatelessWidget {
  /// Creates a [MerchDetailVariantItem].
  const MerchDetailVariantItem({
    required this.item,
    required this.isSelected,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    super.key,
  });

  /// The data model containing label and value.
  final LabelValueModel item;

  /// Whether this item is currently selected.
  final bool isSelected;

  /// The background color of the container.
  final Color backgroundColor;

  /// The text color.
  final Color textColor;

  /// The font size of the text.
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
          child: Center(
            child: Text(
              item.label,
              style: TextStyle(
                color: textColor,
                fontSize: StoycoScreenSize.fontSize(context, fontSize),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
}
