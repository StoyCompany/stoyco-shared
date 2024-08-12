import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BorderGradientStoyco extends StatelessWidget {
  BorderGradientStoyco({
    super.key,
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
    required Widget child,
    double minHeight = 50,
  })  : _painter = _GradientPainter(
          strokeWidth: strokeWidth,
          radius: radius,
          gradient: gradient,
        ),
        _child = child,
        _minHeight = minHeight;

  final _GradientPainter _painter;
  final Widget _child;
  final double _minHeight;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: kIsWeb ? null : _painter,
        child: Container(
          constraints: BoxConstraints(minWidth: 100, minHeight: _minHeight),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _child,
            ],
          ),
        ),
      );
}

class _GradientPainter extends CustomPainter {
  _GradientPainter({
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
    final Rect outerRect = Offset.zero & size;
    final outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));
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

    _paint.shader = gradient.createShader(outerRect);
    final Path path1 = Path()..addRRect(outerRRect);
    final Path path2 = Path()..addRRect(innerRRect);
    final path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
