import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:stoyco_shared/utils/colors.dart';

/// A widget that represents a collapsible menu item.
///
/// The [Colapse] widget displays a menu item with an expandable content section.
/// It consists of a header section that shows the name and an icon, and a content section
/// that can be expanded or collapsed.
///
/// Example usage:
///
/// ```dart
/// Colapse(
///   name: 'Menu Item',
///   icon: Icon(Icons.menu),
///   child: Container(
///     child: Text('Content'),
///   ),
/// )
/// ```
class Colapse extends StatefulWidget {
  const Colapse({
    super.key,
    required this.name,
    required this.icon,
    required this.child,
  });

  /// The name of the menu item.
  final String name;

  /// The icon to display next to the menu item.
  final Widget icon;

  /// The content to display when the menu item is expanded.
  final Widget child;

  @override
  State<Colapse> createState() => _ColapseState();
}

class _ColapseState extends State<Colapse> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() {
              isExpanded = !isExpanded;
            }),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 11, top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  widget.icon,
                  const Gap(10),
                  Expanded(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        color: StoycoColors.grayText,
                        fontSize: 16,
                        fontFamily: 'Akkurat Pro',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SvgPicture.asset(isExpanded
                      ? 'packages/stoyco_shared/lib/assets/icons/arrowUp.svg'
                      : 'packages/stoyco_shared/lib/assets/icons/arrowDown.svg'),
                ],
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: isExpanded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(left: 33),
                    child: widget.child,
                  )
                : const SizedBox.shrink(),
          ),
          Divider(
            thickness: 1,
            height: 30,
            color: StoycoColors.grayText.withOpacity(0.26),
          ),
        ],
      );
}
