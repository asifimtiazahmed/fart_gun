import 'package:flutter/material.dart';

class StitchedContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;

  const StitchedContainer({super.key, required this.child, this.radius = 16, this.padding = const EdgeInsets.all(12)});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StitchBorderPainter(radius: radius),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _StitchBorderPainter extends CustomPainter {
  final double radius;

  _StitchBorderPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final stitchPaint = Paint()
      ..color =
          const Color(0xFFFFD54F) // classic denim stitch yellow
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius)));

    const dashLength = 5.0;
    const gapLength = 4.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final extract = metric.extractPath(distance, distance + dashLength);
        canvas.drawPath(extract, stitchPaint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
