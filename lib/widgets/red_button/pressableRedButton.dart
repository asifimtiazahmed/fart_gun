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
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // ===== Shadow =====
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3 * (1 - press))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawOval(
      Rect.fromCenter(center: center + Offset(0, radius * 0.35), width: radius * 1.4, height: radius * 0.5),
      shadowPaint,
    );

    // ===== Metal Base =====
    final basePaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF444444), const Color(0xFFBBBBBB), const Color(0xFF333333)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius * 0.95, basePaint);

    // ===== Button Side =====
    final sidePaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF8B0000), const Color(0xFFCC0000)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.8));

    canvas.drawCircle(center.translate(0, radius * 0.08), radius * 0.78, sidePaint);

    // ===== Button Top =====
    final topPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topLeft,
        radius: 1.1,
        colors: [const Color(0xFFFF5A5A), const Color(0xFFE00000)],
      ).createShader(Rect.fromCircle(center: center.translate(0, -radius * 0.15 * (1 - press)), radius: radius * 0.7));

    canvas.drawCircle(center.translate(0, -radius * 0.18 * (1 - press)), radius * 0.7, topPaint);

    // ===== Gloss Highlight =====
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.25 * (1 - press));

    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(-radius * 0.15, -radius * 0.35),
        width: radius * 0.9,
        height: radius * 0.45,
      ),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
