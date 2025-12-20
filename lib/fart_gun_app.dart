import 'dart:developer' as app_logger;

import 'package:audioplayers/audioplayers.dart';
import 'package:fart_gun/config/ad_banner.dart';
import 'package:fart_gun/const.dart';
import 'package:fart_gun/widgets/denim/denim_background.dart';
import 'package:fart_gun/widgets/denim/denim_stitched_border.dart';
import 'package:fart_gun/widgets/denim/stitched_container.dart';
import 'package:fart_gun/widgets/gun_widget.dart';
import 'package:fart_gun/widgets/knob_selector.dart';
import 'package:fart_gun/widgets/red_button/pressable_red_button.dart';
import 'package:fart_gun/widgets/sound_type_button.dart';
import 'package:fart_gun/widgets/update_banner.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

import 'config/ad_serve_manager.dart';
import 'config/local_storage_service.dart';

class FartGunHome extends StatefulWidget {
  const FartGunHome({super.key});

  @override
  State<FartGunHome> createState() => _FartGunHomeState();
}

class _FartGunHomeState extends State<FartGunHome> with SingleTickerProviderStateMixin {
  // Logic State
  bool isFartMode = true; // true = Fart, false = Burp
  int triggerCount = 0;
  String selectedFartSound = '';
  String selectedBurpSound = '';
  late AudioPlayer player = AudioPlayer();
  static int fartKnobValue = 1;
  static int burpKnobValue = 1;
  String fartDescription = '- not selected -';
  String burpDescription = ' - not selected  -';
  LocalStorageService localStorageService = LocalStorageService();

  // Animation Controller for the button pop effect
  late AnimationController _controller;

  // Audio Player (Uncomment when you have assets)
  // final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    fartKnobValue = 1;
    burpKnobValue = 1;
    init();
    try {
      fartKnobValue = localStorageService.getInt(fartKnobValueKey) ?? 1;
      burpKnobValue = localStorageService.getInt(burpKnobValueKey) ?? 1;
    } catch (e) {
      app_logger.log(e.toString());
    }
    player = AudioPlayer();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 100), lowerBound: 0.0, upperBound: 0.1)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    player.dispose();
    super.dispose();
  }

  void init() {
    setState(() {
      burpDescription = getBurpDescription(burpKnobValue);
      fartDescription = getFartDescription(fartKnobValue);

      selectedFartSound = 'farts/fart$fartKnobValue.mp3';
      selectedBurpSound = 'burps/burp$burpKnobValue.mp3';
    });
  }

  // --- Logic Methods ---
  String getFartDescription(int value) {
    String desc = '';
    switch (value) {
      case 1:
        desc = 'little stink';
        break;
      case 2:
        desc = 'pressure fart';
        break;
      case 3:
        desc = 'wet stinky';
        break;
      case 4:
        desc = 'heavy stink';
        break;
      case 5:
        desc = 'toilet wet poopy';
        break;
      case 6:
        desc = 'poopy pants';
        break;
      case 7:
        desc = 'long and skinny';
        break;
      case 0:
        desc = 'let it riiiip';
        break;
      default:
        desc = '- not selected -';
    }
    return desc;
  }

  void _switchMode(bool isFart) {
    setState(() {
      isFartMode = isFart;
    });
  }

  String getBurpDescription(int value) {
    String desc = '';
    switch (value) {
      case 1:
        desc = 'Baab!';
        break;
      case 2:
        desc = 'gassy burp';
        break;
      case 3:
        desc = 'foodie burp';
        break;
      case 4:
        desc = 'gasping burp';
        break;
      case 5:
        desc = 'addictive burp';
        break;
      case 6:
        desc = 'satiated burp';
        break;
      case 7:
        desc = 'shorty';
        break;
      case 0:
        desc = 'Glug burp';
        break;
      default:
        desc = '- not selected -';
    }
    return desc;
  }

  void _gunTriggerAction() async {
    // Haptic feedback
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 50);
    }

    // 1. Animate Button
    await _controller.forward();
    await _controller.reverse();

    // 2. Play Sound
    await player.play(AssetSource(isFartMode ? selectedFartSound : selectedBurpSound));
    
    // 3. Show visual feedback (check mounted before using context)
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFartMode ? "💨 PFFFFFFT!" : "🤢 BUUUURP!",
            textAlign: TextAlign.center,
            style: GoogleFonts.luckiestGuy(fontSize: 20),
          ),
          duration: const Duration(milliseconds: 500),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    // 4. Handle Ad Logic
    setState(() {
      triggerCount++;
    });

    if (triggerCount % 10 == 0) {
      AdServeManager.instance.showInterstitialIfReady();
      setState(() {
        triggerCount = 0;
      });
    }
  }

  // --- Widget Builders ---

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return AppUpdateBanner(
      child: Scaffold(
        //TITLE
        appBar: AppBar(
          backgroundColor: themeYellow,
          surfaceTintColor: themeYellow,
          shadowColor: Colors.black,
          elevation: 4.0,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "THE ",
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 40,
                    color: denimBlue,
                    shadows: [Shadow(offset: const Offset(2, 2), color: stitchColor, blurRadius: 2)],
                  ),
                ),
                Text(
                  "FART",
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 40,
                    color: Colors.green,
                    shadows: [Shadow(offset: const Offset(2, 2), color: Colors.black26, blurRadius: 2)],
                  ),
                ),
                Text(
                  " GUN",
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 40,
                    color: denimBlue,
                    shadows: [Shadow(offset: const Offset(2, 2), color: stitchColor, blurRadius: 2)],
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: DenimBackground(
          child: DenimStitchedBorder(
            topPadding: 15,
            bottomPadding: 15,
            leftPadding: 15,
            rightPadding: 15,
            child: SizedBox(
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //             --- MAIN CONTENT AREA (Jeans Background) ---
                      //BUTTON SELECTOR FARTS/BURP
                      StitchedContainer(
                        padding: EdgeInsets.fromLTRB(0, 8, 8, 8),

                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: themeYellow,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [shadow, shadow2],
                          ),
                          height: height * 0.5,
                          width: width * 0.4, //30%
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SoundTypeButton(
                                          onPressed: () {
                                            _switchMode(true);
                                          },
                                          imagePath: fartImagePath,
                                          backgroundColor: isFartMode ? selectedButtonColor : unSelectedButtonColor,
                                          buttonText: 'Farts',
                                        ),
                                        const SizedBox(width: 30),
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: StepKnob(
                                              value: fartKnobValue,
                                              onChanged: (fartSelected) {
                                                setState(() async {
                                                  fartKnobValue = fartSelected;
                                                  selectedFartSound = 'farts/fart$fartSelected.mp3';
                                                  fartDescription = getFartDescription(fartSelected);
                                                  localStorageService.setInt(fartKnobValueKey, fartSelected);
                                                  //Button tap sound
                                                  await player.play(AssetSource(tapSoundPath));
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text('Fart Loaded: $fartDescription', style: GoogleFonts.luckiestGuy(fontSize: 15)),
                                  ],
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SoundTypeButton(
                                          onPressed: () {
                                            _switchMode(false);
                                          },
                                          imagePath: burpImagePath,
                                          backgroundColor: isFartMode ? unSelectedButtonColor : selectedButtonColor,
                                          buttonText: 'Burps',
                                        ),
                                        const SizedBox(width: 30),
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: StepKnob(
                                              value: burpKnobValue,
                                              onChanged: (burpSelected) {
                                                setState(() async {
                                                  burpKnobValue = burpSelected;
                                                  selectedBurpSound = 'burps/burp$burpSelected.mp3';
                                                  burpDescription = getBurpDescription(burpSelected);
                                                  localStorageService.setInt(burpKnobValueKey, burpSelected);
                                                  //Button tap sound
                                                  await player.play(AssetSource(tapSoundPath));
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text('Burp Loaded: $burpDescription', style: GoogleFonts.luckiestGuy(fontSize: 15)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //THE FART GUN
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.3,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // 1. The "Gun" Visual (Placeholder)
                            GunWidget(triggerValue: triggerCount),

                            // 2. Mode Switcher (Fart vs Burp)

                            // Trigger Counter Text
                            // Text(
                            //   "Triggers: ${10 - triggerCount}",
                            //   style: GoogleFonts.robotoMono(color: Colors.white70, fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                      ),
                      // 3. The Wacky Trigger Button
                      PressableRedButton(size: 120, onPressed: _gunTriggerAction),
                    ],
                  ),

                  // --- BANNER AD PLACEHOLDER ---
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: FloatingActionButton(
          onPressed: () {},
          child: Container(
            height: 60,
            //width: 150,
            color: Colors.black,
            child: const Center(child: AdBanner()),
          ),
        ),
      ),
    );
  }
}
