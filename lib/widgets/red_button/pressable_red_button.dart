import 'package:flutter/material.dart';

class PressableRedButton extends StatefulWidget {
  final double size;
  final VoidCallback onPressed;

  const PressableRedButton({super.key, this.size = 120, required this.onPressed});

  @override
  State<PressableRedButton> createState() => _PressableRedButtonState();
}

class _PressableRedButtonState extends State<PressableRedButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  void _pressDown() => _controller.forward();
  void _release() {
    _controller.reverse();
    widget.onPressed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressDown(),
      onTapUp: (_) => _release(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final press = _controller.value;

          return Transform.translate(
            offset: Offset(0, 6 * press),
            child: CustomPaint(size: Size.square(widget.size), painter: _RedButtonPainter(press)),
          );
        },
      ),
    );
  }
}

class _RedButtonPainter extends CustomPainter {
  final double press;

  _RedButtonPainter(this.press);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;

    // =====================
    // Ground shadow (harder)
    // =====================
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.28 * (1 - press))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawOval(Rect.fromCenter(center: c + Offset(0, r * 0.55), width: r * 1.35, height: r * 0.42), shadowPaint);

    // =====================
    // METAL BEZEL (outer ring)
    // =====================
    final bezelPaint = Paint()
      ..shader = LinearGradient(
        colors: const [Color(0xFF2E2E2E), Color(0xFFBEBEBE), Color(0xFF1F1F1F)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: c, radius: r));

    canvas.drawCircle(c, r * 0.98, bezelPaint);

    // Bezel edge line
    canvas.drawCircle(
      c,
      r * 0.98,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.02
        ..color = Colors.black.withValues(alpha: 0.4),
    );

    // =====================
    // RED SIDE WALL (rigid)
    // =====================
    final sidePaint = Paint()
      ..shader = LinearGradient(
        colors: const [Color(0xFF6E0000), Color(0xFFB00000), Color(0xFF520000)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: c, radius: r * 0.82));

    canvas.drawCircle(c.translate(0, r * 0.10), r * 0.80, sidePaint);

    // =====================
    // TOP CAP (hard plastic)
    // =====================
    final capCenter = c.translate(0, -r * 0.12 * (1 - press));

    final capPaint = Paint()
      ..shader = LinearGradient(
        colors: const [Color(0xFFFF3A3A), Color(0xFFC60000)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: capCenter, radius: r * 0.68));

    canvas.drawCircle(capCenter, r * 0.68, capPaint);

    // =====================
    // INNER LIP (depth cue)
    // =====================
    canvas.drawCircle(
      capCenter,
      r * 0.68,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.03
        ..color = Colors.black.withValues(alpha: 0.35),
    );

    // =====================
    // SPECULAR EDGE (thin!)
    // =====================
    final specularPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.55 * (1 - press)),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.center,
      ).createShader(Rect.fromCircle(center: capCenter, radius: r * 0.7));

    canvas.drawArc(
      Rect.fromCircle(center: capCenter, radius: r * 0.67),
      -3.14,
      3.14,
      false,
      specularPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.025,
    );

    // =====================
    // INNER SHADOW (press depth)
    // =====================
    final innerShadowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.black.withValues(alpha: 0.45 * press),
          Colors.transparent,
        ],
        radius: 0.9,
      ).createShader(Rect.fromCircle(center: capCenter, radius: r * 0.7));

    canvas.drawCircle(capCenter, r * 0.7, innerShadowPaint);
  }

  @override
  bool shouldRepaint(covariant _RedButtonPainter old) => old.press != press;
}
