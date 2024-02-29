import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// A button that can be expanded or collapsed.
///
/// This button can be used to show additional content or perform an action when clicked.
/// It can be customized with different colors, sizes, and decorations.
///
/// Example:
/// ```dart
/// ExpandableButton(
///   color: Colors.blue,
///   height: 50.0,
///   minWidth: 50.0,
///   maxWidth: 200.0,
///   decoration: BoxDecoration(
///     borderRadius: BorderRadius.circular(8),
///     boxShadow: [
///       BoxShadow(
///         color: Colors.black.withOpacity(0.2),
///         blurRadius: 8,
///         offset: const Offset(0, 4),
///       ),
///     ],
///   ),
///   textStyle: TextStyle(
///     color: Colors.white,
///     overflow: TextOverflow.ellipsis,
///   ),
///   icon: Icon(Icons.add, color: Colors.white),
///   onPressed: () {
///     // Perform action here
///   },
///   text: 'Click Me',
/// )
/// ```
class ExpandableButton extends StatefulWidget {
  /// Creates a new instance of [ExpandableButton].
  ///
  /// The [color] parameter sets the background color of the button.
  /// The [height] parameter sets the height of the button.
  /// The [minWidth] parameter sets the minimum width of the button.
  /// The [maxWidth] parameter sets the maximum width of the button.
  /// The [decoration] parameter sets the decoration of the button.
  /// The [textStyle] parameter sets the style of the text inside the button.
  /// The [icon] parameter sets the icon displayed before the text.
  /// The [onPressed] parameter is a callback function that is called when the button is pressed.
  /// The [text] parameter sets the text displayed inside the button.
  const ExpandableButton({
    Key? key,
    this.color,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.decoration,
    this.textStyle,
    this.icon,
    this.onPressed,
    this.text,
  });

  final Color? color;
  final double? height;
  final double? minWidth;
  final double? maxWidth;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final Widget? icon;
  final VoidCallback? onPressed;
  final String? text;

  @override
  _ExpandableButtonState createState() => _ExpandableButtonState();
}

class _ExpandableButtonState extends State<ExpandableButton> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _performAction() {
    widget.onPressed?.call();
    _toggleExpand();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topRight,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            _isExpanded ? _performAction : _toggleExpand;
          },
          child: GestureDetector(
            onTap: _isExpanded ? _performAction : _toggleExpand,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: _isExpanded
                  ? const EdgeInsets.symmetric(horizontal: 16)
                  : null,
              decoration: widget.decoration ??
                  BoxDecoration(
                    color: widget.color ?? Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
              width: _isExpanded
                  ? widget.maxWidth ?? screenWidth
                  : widget.minWidth ?? 50.0,
              height: widget.height ?? 50.0,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (_isExpanded)
                    Flexible(
                      child: Text(widget.text ?? 'Click Me',
                          style: widget.textStyle ??
                              const TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              )),
                    ),
                  if (_isExpanded) const Gap(8),
                  widget.icon ?? const Icon(Icons.add, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
