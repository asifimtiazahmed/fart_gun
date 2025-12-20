import 'package:flutter/material.dart';

final Color themeYellow = const Color(0xFFF5E050);
final Color denimBlue = const Color(0xFF2B4F81);
//These two determine the denim gradient color
final Color denimFabricColor = const Color(0xFF1B336B);
final Color denimFabricShadeColor = const Color(0xFF244A9A);
//

final Color stitchColor = const Color(0xFFE8A631);
final Color brownColor = const Color(0xFF7C4700);
final Color unSelectedButtonColor = const Color(0xFF91BAD0);
final Color selectedButtonColor = const Color(0xFF5081AC);
final Color greenFartColor = const Color(0XFFB9D54A);

final String burpImagePath = 'assets/burp.png';
final String fartImagePath = 'assets/fart.png';
final String fartGunImagePath = 'assets/fart_gun.png';
final String greenLightImagePath = 'assets/greenLightOn.png';
final String redLightImagePath = 'assets/redLight.png';

final String tapSoundPath = 'tap3.wav';

final String fartKnobValueKey = 'FartKnobValue';
final String burpKnobValueKey = 'BurpKnobValue';

final BoxShadow shadow = BoxShadow(
  color: stitchColor.withValues(alpha: 0.9),
  offset: const Offset(4.0, 4.0),
  // blurRadius: 5.0,
  // spreadRadius: 1.0,
);
final BoxShadow shadow2 = BoxShadow(
  color: themeYellow.withValues(alpha: 0.5),
  offset: const Offset(5.0, 0.0),
  //blurRadius: 5.0,
  //spreadRadius: 1.0,
);

final String androidBannerAdId = 'ca-app-pub-9426901076429008/8743153501';
final String androidInterstitialAdId = 'ca-app-pub-9426901076429008/5718369060';
final String iosBannerAdId = 'ca-app-pub-9426901076429008/2692750479';
final String iosInterstitialAdId = 'ca-app-pub-9426901076429008/7046928451';
