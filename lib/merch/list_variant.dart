import 'package:flutter/material.dart';
import 'package:stoyco_shared/design/screen_size.dart';
import 'package:stoyco_shared/merch/merch_detail_variant_item.dart';
import 'package:stoyco_shared/models/label_value_model.dart';

class ListVariant extends StatefulWidget {
  const ListVariant({
    required this.items,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    required this.onSelected,
    super.key,
  });

  final List<LabelValueModel> items;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final void Function(LabelValueModel) onSelected;

  @override
  State<ListVariant> createState() => _ListVariantState();
}

class _ListVariantState extends State<ListVariant> {
  int selectedIndex = 0;

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
