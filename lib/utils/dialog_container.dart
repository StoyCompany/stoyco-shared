import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:stoyco_shared/utils/gradient_painter.dart';

/// A customizable dialog container widget with glassmorphism effect.
///
/// This widget creates a modal dialog with a translucent background and gradient borders.
/// It can be configured to close when tapping outside the dialog area.
class DialogContainer extends StatelessWidget {
  /// Creates a [DialogContainer].
  ///
  /// * [children] - The list of widgets to display in the dialog content.
  /// * [padding] - The padding around the dialog content. Defaults to EdgeInsets.all(15.0).
  /// * [canClose] - Whether the dialog can be closed by tapping outside. Defaults to false.
  /// * [backgroundColor] - The background color of the dialog container.
  /// * [gradient] - The gradient to apply to the dialog container background.
  /// * [containerWidth] - The width of the dialog container. Defaults to 90% of screen width.
  /// * [maxWidth] - The maximum width of the dialog container. Defaults to 500.
  /// * [minHeight] - The minimum height of the dialog container. Defaults to 300.
  const DialogContainer({
    super.key,
    this.padding,
    this.gradient,
    this.containerWidth,
    this.backgroundColor,
    this.canClose = false,
    required this.children,
    this.maxWidth = 500,
    this.minHeight = 300,
  });

  /// The widgets to display in the dialog content.
  final List<Widget> children;

  /// The padding around the dialog content.
  final EdgeInsetsGeometry? padding;

  /// Whether the dialog can be closed by tapping outside.
  final bool canClose;

  /// The background color of the dialog container.
  final Color? backgroundColor;

  /// The gradient to apply to the dialog container background.
  final Gradient? gradient;

  /// The width of the dialog container.
  final double? containerWidth;

  /// The maximum width of the dialog container.
  final double maxWidth;

  /// The minimum height of the dialog container.
  final double minHeight;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => canClose ? Navigator.of(context).pop() : null,
          child: GlassmorphicContainer(
            width: double.infinity,
            height: double.infinity,
            borderRadius: 0,
            blur: 10,
            border: 0,
            linearGradient: LinearGradient(
              colors: [
                const Color(0xFF030A1A).withAlpha(25),
                const Color(0xFF0C1B24).withAlpha(1),
              ],
              stops: const [
                0.1,
                1,
              ],
            ),
            borderGradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF030A1A),
                Color(0xFF0C1B24),
              ],
              stops: [
                10,
                0,
              ],
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Prevents propagation of the tap event to the parent GestureDetector
                  // This allows the dialog to remain open when tapping inside the Center widget
                },
                child: Container(
                  width:
                      containerWidth ?? MediaQuery.of(context).size.width * 0.9,
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    minHeight: minHeight,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: backgroundColor ??
                        (gradient == null
                            ? const Color.fromARGB(7, 238, 232, 232)
                            : null),
                    gradient: gradient,
                  ),
                  child: CustomPaint(
                    painter: GradientPainter(
                      strokeWidth: 2.5,
                      radius: 25,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(42, 99, 97, 153),
                          Color.fromARGB(106, 99, 97, 153),
                          Color(0xFF636199),
                          Color.fromARGB(196, 88, 80, 200),
                          Color(0xFF483ce4),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: padding ?? const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
