import 'package:fart_gun/const.dart';
import 'package:flutter/material.dart';
import 'package:wave_progress_indicator/wave_progress_indicator.dart';

class GunWidget extends StatefulWidget {
  final int triggerValue;
  const GunWidget({super.key, required this.triggerValue});

  @override
  State<GunWidget> createState() => _GunWidgetState();
}

class _GunWidgetState extends State<GunWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant GunWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger shake ONLY when triggerValue changes
    if (oldWidget.triggerValue != widget.triggerValue) {
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(offset: Offset(_shakeAnimation.value, 0), child: child);
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.3,
        child: Stack(
          children: [
            Image.asset(
              fartGunImagePath,
              height: 120,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.toys, size: 100, color: Colors.white),
            ),
            Positioned(
              top: 20,
              left: 80,
              right: 130,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 19,
                width: 30,
                child: WaveProgressIndicator(
                  value: 1 - (widget.triggerValue / 10),
                  waveHeight: 1,
                  gradientColors: [
                    brownColor.withValues(alpha: 0.6),
                    greenFartColor.withValues(alpha: 0.7),
                    stitchColor.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
