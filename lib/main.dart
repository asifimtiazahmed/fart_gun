import 'package:fart_gun/app_strings.dart';
import 'package:flutter/material.dart';

import 'fart_gun_app.dart'; // Ensure you added this dependency
// import 'package:audioplayers/audioplayers.dart'; // Uncomment for real audio

void main() {
  runApp(const FartGunApp());
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
        scaffoldBackgroundColor: const Color(0xFFF5E050), // Minion Yellow
      ),
      home: const FartGunHome(),
    );
  }
}
