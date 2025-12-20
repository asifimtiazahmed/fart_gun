import 'dart:math';

import 'package:fart_gun/const.dart';
import 'package:flutter/material.dart';

class StepKnob extends StatelessWidget {
  final int steps;
  final int value;
  final ValueChanged<int> onChanged;
  final double size;

  const StepKnob({super.key, this.steps = 8, required this.value, required this.onChanged, this.size = 120});

  @override
  Widget build(BuildContext context) {
    final double angleStep = 2 * pi / steps;
    final double rotation = -pi / 2 + (value * angleStep);

    return GestureDetector(
      onTap: () {
        onChanged((value + 1) % steps);
      },
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Radial ticks
            for (int i = 0; i < steps; i++) _Tick(angle: -pi / 2 + i * angleStep, size: size),

            // Knob base
            Container(
              width: size * 0.65,
              height: size * 0.65,
              decoration: BoxDecoration(
                color: const Color(0xFFCDD3D6),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF9DA8AB), width: 6),
                boxShadow: [shadow],
              ),
            ),

            // Indicator
            Transform.rotate(
              angle: rotation,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 6,
                  height: size * 0.18,
                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tick extends StatelessWidget {
  final double angle;
  final double size;

  const _Tick({required this.angle, required this.size});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 10,
          height: size * 0.1,
          decoration: BoxDecoration(color: const Color(0xFF5C7882), borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
