import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class DenimNoisePainter extends CustomPainter {
  late final double opacity;
  final Random _rand = Random(42);

  DenimNoisePainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..strokeWidth = 1;

    for (int i = 0; i < size.width * size.height / 1200; i++) {
      final dx = _rand.nextDouble() * size.width;
      final dy = _rand.nextDouble() * size.height;
      canvas.drawPoints(PointMode.points, [Offset(dx, dy)], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
