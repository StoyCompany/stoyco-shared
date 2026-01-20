import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/merch/merch_detail_variant_item.dart';
import 'package:stoyco_shared/models/label_value_model.dart';

/// A horizontal scrollable list of variant items.
///
/// Only one item can be selected at a time. When an item is tapped,
/// it becomes selected and the [onSelected] callback is triggered.
///
/// Note: This widget requires a defined height from its parent.
class ListVariant extends StatefulWidget {
  /// Creates a [ListVariant].
  const ListVariant({
    required this.items,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    required this.onSelected,
    super.key,
  });

  /// The list of items to display.
  final List<LabelValueModel> items;

  /// The background color for each item.
  final Color backgroundColor;

  /// The text color for each item.
  final Color textColor;

  /// The font size for each item.
  final double fontSize;

  /// Callback triggered when an item is selected.
  final void Function(LabelValueModel) onSelected;

  @override
  State<ListVariant> createState() => _ListVariantState();
}

class _ListVariantState extends State<ListVariant> {
  /// The index of the currently selected item.
  int selectedIndex = 0;

  /// Handles tap on an item at the given [index].
  ///
  /// Updates the selection state and triggers [onSelected] callback.
  void _onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onSelected(widget.items[index]);
  }

  @override
  Widget build(BuildContext context) => ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: StoycoScreenSize.width(context, 20)),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _onItemTap(index),
          child: MerchDetailVariantItem(
            item: widget.items[index],
            isSelected: selectedIndex == index,
            backgroundColor: widget.backgroundColor,
            textColor: widget.textColor,
            fontSize: widget.fontSize,
          ),
        ),
      );
}
