import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/merch/list_variant.dart';
import 'package:stoyco_shared/models/label_value_model.dart';

/// A section displaying a title and a horizontal list of variants.
///
/// Combines a title text with a [ListVariant] widget below it,
/// separated by configurable spacing.
class VariantSection extends StatelessWidget {
  /// Creates a [VariantSection].
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

  /// The title text displayed above the list.
  final String title;

  /// The font size of the title.
  final double titleFontSize;

  /// The color of the title text.
  final Color titleColor;

  /// The vertical spacing between title and list.
  final double spacing;

  /// The list of variant items to display.
  final List<LabelValueModel> items;

  /// The background color for each variant item.
  final Color backgroundColor;

  /// The text color for each variant item.
  final Color textColor;

  /// The font size for each variant item.
  final double fontSize;

  /// Callback triggered when a variant is selected.
  final void Function(LabelValueModel) onSelected;

  /// The height of the list container.
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
