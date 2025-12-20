import 'package:flutter/material.dart';
import 'package:wave_progress_indicator/wave_progress_indicator.dart';

import '../const.dart';

class GunWidget extends StatefulWidget {
  final int triggerValue;
  const GunWidget({super.key, required this.triggerValue});

  @override
  State<GunWidget> createState() => _GunWidgetState();
}

class _GunWidgetState extends State<GunWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Stack(
        children: [
          //Starts off full then empties
          Image.asset(
            fartGunImagePath, // Generic toy gun icon
            height: 120,
            // color: Colors.white,
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
                gradientColors: [brownColor.withValues(alpha: 0.6), stitchColor.withValues(alpha: 0.6)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
