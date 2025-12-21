import 'package:flutter/material.dart';

class FartSmokePuff extends StatefulWidget {
  final bool isActive;
  final double size;

  const FartSmokePuff({super.key, required this.isActive, this.size = 120});

  @override
  State<FartSmokePuff> createState() => _FartSmokePuffState();
}

class _FartSmokePuffState extends State<FartSmokePuff> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const Duration _smokeDelay = Duration(milliseconds: 250);

  late final Animation<double> _opacity;
  late final Animation<Offset> _movement;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1550));

    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 0.0), weight: 70),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _movement = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(1.0, -0.2), // right + slight upward drift
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  @override
  void didUpdateWidget(covariant FartSmokePuff oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !_controller.isAnimating) {
      Future.delayed(_smokeDelay, () {
        if (!mounted) return;
        _controller.forward(from: 0);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SlideTransition(
        position: _movement,
        child: FadeTransition(
          opacity: _opacity,
          child: RotatedBox(
            quarterTurns: 1, // vertical → horizontal
            child: Image.asset('assets/greenSmoke-min.png', width: widget.size, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
