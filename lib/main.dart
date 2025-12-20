import 'package:fart_gun/app_strings.dart';
import 'package:fart_gun/config/appconfig.dart';
import 'package:flutter/material.dart';

import 'const.dart';
import 'fart_gun_app.dart'; // Ensure you added this dependency
// import 'package:audioplayers/audioplayers.dart'; // Uncomment for real audio

void main() async {
  await AppConfig.configure();
  runApp(const FartGunApp(key: Key(AppStrings.appName)));
}

class FartGunApp extends StatelessWidget {
  const FartGunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        scaffoldBackgroundColor: themeYellow, // Minion Yellow
      ),
      home: const FartGunHome(),
    );
  }
}
