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
import 'package:fart_gun/widgets/smoke_puff.dart';
import 'package:fart_gun/widgets/sound_type_button.dart';
import 'package:fart_gun/widgets/update_banner.dart';
import 'package:flutter/material.dart';
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
  bool triggerSmoke = false;
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
            style: const TextStyle(fontFamily: 'LuckiestGuy', fontSize: 20),
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
      triggerSmoke = true;
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
    return AppUpdateBanner(
      child: Scaffold(
        backgroundColor: themeYellow,
        body: DenimBackground(
          child: DenimStitchedBorder(
            topPadding: 10,
            bottomPadding: 10,
            leftPadding: 10,
            rightPadding: 10,
            child: Column(
              children: [
                // Custom title container
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeYellow,
                    boxShadow: [shadow],
                  ),

                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "THE ",
                        style: TextStyle(
                          fontFamily: 'LuckiestGuy',
                          fontSize: 24,
                          color: denimBlue,
                          shadows: [Shadow(offset: Offset(2, 2), color: stitchColor, blurRadius: 2)],
                        ),
                      ),
                      Text(
                        "FART",
                        style: const TextStyle(
                          fontFamily: 'LuckiestGuy',
                          fontSize: 24,
                          color: Colors.green,
                          shadows: [Shadow(offset: Offset(2, 2), color: Colors.black26, blurRadius: 2)],
                        ),
                      ),
                      Text(
                        " GUN",
                        style: TextStyle(
                          fontFamily: 'LuckiestGuy',
                          fontSize: 24,
                          color: denimBlue,
                          shadows: [Shadow(offset: Offset(2, 2), color: stitchColor, blurRadius: 2)],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //BUTTON SELECTOR FARTS/BURP
                        Flexible(
                          flex: 2,
                          child: StitchedContainer(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: themeYellow,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [shadow, shadow2],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Fart section
                                  Column(
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
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: StepKnob(
                                                    value: fartKnobValue,
                                                    onChanged: (fartSelected) {
                                                      setState(() {
                                                        fartKnobValue = fartSelected;
                                                        selectedFartSound = 'farts/fart$fartSelected.mp3';
                                                        fartDescription = getFartDescription(fartSelected);
                                                        localStorageService.setInt(fartKnobValueKey, fartSelected);
                                                        triggerSmoke = false;
                                                      });
                                                      player.play(AssetSource(tapSoundPath));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        fartDescription,
                                        style: const TextStyle(fontFamily: 'LuckiestGuy', fontSize: 12),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Burp section
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SoundTypeButton(
                                            onPressed: () {
                                              _switchMode(false);
                                            },
                                            imagePath: burpImagePath,
                                            backgroundColor: isFartMode ? unSelectedButtonColor : selectedButtonColor,
                                            buttonText: 'Burps',
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: StepKnob(
                                                    value: burpKnobValue,
                                                    onChanged: (burpSelected) {
                                                      setState(() {
                                                        burpKnobValue = burpSelected;
                                                        selectedBurpSound = 'burps/burp$burpSelected.mp3';
                                                        burpDescription = getBurpDescription(burpSelected);
                                                        localStorageService.setInt(burpKnobValueKey, burpSelected);
                                                        triggerSmoke = false;
                                                      });
                                                      player.play(AssetSource(tapSoundPath));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    burpDescription,
                                    style: const TextStyle(fontFamily: 'LuckiestGuy', fontSize: 12),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //THE FART GUN
                        Flexible(
                          flex: 3,
                          child: Row(
                            children: [
                              //RED BUTTON
                              PressableRedButton(
                                size: 200,
                                onPressed: () {
                                  _gunTriggerAction();
                                  triggerSmoke = false;
                                },
                              ),
                              //GUN WIDGET
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                  width: 180,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        right: -40, // adjust to barrel tip
                                        top: 25, // align vertically
                                        child: FartSmokePuff(isActive: triggerSmoke, size: 90),
                                      ),
                                      GunWidget(triggerValue: triggerCount),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // The Trigger Button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Container(
            color: Colors.black,
            child: const Center(child: AdBanner()),
          ),
        ),
      ),
    );
  }
}
