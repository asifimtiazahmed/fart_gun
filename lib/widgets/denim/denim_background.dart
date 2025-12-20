import 'package:flutter/material.dart';

import '../../const.dart';
import 'denim_weave.dart';

///This is a sticked widget so you must position each child in the tree
class DenimBackground extends StatelessWidget {
  final Widget child;
  final double intensity;

  const DenimBackground({super.key, required this.child, this.intensity = 1.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base denim color + weave
        Container(
          decoration: BoxDecoration(
            color: denimFabricColor, // deep denim blue
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [denimFabricShadeColor, denimFabricColor],
            ),
          ),
        ),

        // Diagonal weave overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.04 * intensity),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.05 * intensity),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Fabric noise
        CustomPaint(size: Size.infinite, painter: DenimWeavePainter()),

        // Optional vignette for depth
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.1,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.25 * intensity),
              ],
            ),
          ),
        ),

        child,
      ],
    );
  }
}
