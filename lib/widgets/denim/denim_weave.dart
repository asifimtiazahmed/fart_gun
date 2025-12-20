import 'package:flutter/material.dart';

class DenimWeavePainter extends CustomPainter {
  final double spacing;
  final double opacity;

  DenimWeavePainter({
    this.spacing = 6.0, // thread density
    this.opacity = 1, // subtlety
  });

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..strokeWidth = 1;

    final darkPaint = Paint()
      ..color = Colors.black.withValues(alpha: opacity * 0.9)
      ..strokeWidth = 1;

    // ↘ Diagonal threads
    for (double x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), lightPaint);
    }

    // ↗ Cross diagonal threads
    for (double x = 0; x < size.width + size.height; x += spacing) {
      canvas.drawLine(Offset(x, size.height), Offset(x - size.height, 0), darkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
