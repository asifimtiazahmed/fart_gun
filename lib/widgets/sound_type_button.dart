import 'package:fart_gun/const.dart';
import 'package:flutter/material.dart';

class SoundTypeButton extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;
  final String buttonText;
  final VoidCallback onPressed;

  const SoundTypeButton({
    super.key,
    required this.imagePath,
    required this.backgroundColor,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 3,
        shadowColor: stitchColor,
        shape: StadiumBorder(side: BorderSide(color: Colors.black.withValues(alpha: 0.8), width: 2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 50, fit: BoxFit.contain, colorBlendMode: BlendMode.lighten),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontFamily: 'LuckiestGuy',
                fontSize: 40,
                color: Colors.white,
                shadows: [Shadow(offset: Offset(2, 2), color: Colors.black26, blurRadius: 2)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
