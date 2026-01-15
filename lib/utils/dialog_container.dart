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
  const DialogContainer(
      {super.key,
      this.padding,
      this.gradient,
      this.containerWidth,
      this.backgroundColor,
      this.canClose = false,
      required this.children,
      this.maxWidth = 500,
      this.minHeight = 300,
      this.radius = 0});

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

  final double radius;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => canClose ? Navigator.of(context).pop() : null,
          child: GlassmorphicContainer(
            width: double.infinity,
            height: double.infinity,
            borderRadius: radius,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    // Prevents propagation of the tap event to the parent GestureDetector
                    // This allows the dialog to remain open when tapping inside the Center widget
                  },
                  child: Container(
                    width: containerWidth ??
                        MediaQuery.of(context).size.width * 0.9,
                    constraints: BoxConstraints(
                      maxWidth: maxWidth,
                      minHeight: minHeight,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      color: backgroundColor ??
                          (gradient == null
                              ? const Color.fromRGBO(32, 37, 50, 0.4)
                              : null),
                      gradient: gradient,
                    ),
                    child: CustomPaint(
                      painter: GradientPainter(
                        strokeWidth: 0,
                        radius: 8,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(32, 37, 50, 0.8),
                            Color.fromRGBO(32, 37, 50, 0.8),
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
        ),
      );
}
