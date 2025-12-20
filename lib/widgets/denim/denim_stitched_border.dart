import 'package:flutter/material.dart';

class DenimStitchedBorder extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final double leftPadding;
  final double topPadding;
  final double rightPadding;
  final double bottomPadding;

  // Constructor

  const DenimStitchedBorder({
    super.key,
    required this.child,
    this.radius = 14,
    this.padding = const EdgeInsets.all(14),
    this.leftPadding = 5,
    this.topPadding = 5,
    this.rightPadding = 5,
    this.bottomPadding = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, bottomPadding),
      child: CustomPaint(
        painter: _DoubleStitchPainter(radius: radius),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class _DoubleStitchPainter extends CustomPainter {
  final double radius;

  _DoubleStitchPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final stitchColor = const Color(0xFFFFD54F); // denim yellow
    final shadowColor = const Color(0xFFB38F2A); // darker thread depth

    final stitchPaint = Paint()
      ..color = stitchColor
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = shadowColor.withValues(alpha: 0.6)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const dashLength = 6.0;
    const gapLength = 4.0;
    const rowSpacing = 4.0;

    // Outer & inner stitch paths
    final outer = _roundedRectPath(size, 0);
    final inner = _roundedRectPath(size, rowSpacing);

    // _drawDashedPath(canvas, outer, shadowPaint, dashLength, gapLength); //REMOVED TO TAKE OUTER LAYER OFF
    _drawDashedPath(canvas, inner, stitchPaint, dashLength, gapLength);
  }

  Path _roundedRectPath(Size size, double inset) {
    return Path()..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2),
        Radius.circular(radius),
      ),
    );
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dash, double gap) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + dash);
        canvas.drawPath(segment, paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
