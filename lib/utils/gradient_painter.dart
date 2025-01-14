import 'package:flutter/material.dart';

/// A custom painter that paints a gradient border with rounded corners.
class GradientPainter extends CustomPainter {
  /// Creates a [GradientPainter] with the given stroke width, radius, and gradient.
  GradientPainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradient,
  });

  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    final Rect outerRect = Offset.zero & size;
    final outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    final Rect innerRect = Rect.fromLTWH(
      strokeWidth,
      strokeWidth,
      size.width - strokeWidth * 2,
      size.height - strokeWidth * 2,
    );
    final innerRRect = RRect.fromRectAndRadius(
      innerRect,
      Radius.circular(radius - strokeWidth),
    );

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    final Path path1 = Path()..addRRect(outerRRect);
    final Path path2 = Path()..addRRect(innerRRect);
    // var path = Path.combine(PathOperation.difference, path1, path2);
    final combinedPath = combinePaths(path1, path2);

    canvas.drawPath(combinedPath, _paint);
  }

  /// Combines two paths using the even-odd fill type.
  Path combinePaths(Path path1, Path path2) {
    final Path combinedPath = Path();
    combinedPath.fillType = PathFillType.evenOdd;
    combinedPath.addPath(path1, Offset.zero);
    combinedPath.addPath(path2, Offset.zero);
    return combinedPath;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
