import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FartGunHome extends StatefulWidget {
  const FartGunHome({super.key});

  @override
  State<FartGunHome> createState() => _FartGunHomeState();
}

class _FartGunHomeState extends State<FartGunHome> with SingleTickerProviderStateMixin {
  // Logic State
  bool isFartMode = true; // true = Fart, false = Burp
  int triggerCount = 0;

  // Animation Controller for the button pop effect
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // Audio Player (Uncomment when you have assets)
  // final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 100), lowerBound: 0.0, upperBound: 0.1)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- Logic Methods ---

  void _switchMode(bool isFart) {
    setState(() {
      isFartMode = isFart;
    });
  }

  void _triggerSound() async {
    // 1. Animate Button
    await _controller.forward();
    await _controller.reverse();

    // 2. Play Sound (Simulated)
    String soundType = isFartMode ? "FART" : "BURP";
    print("Playing sound: $soundType");

    // VISUAL CUE since we don't have real audio files loaded
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

    // Real implementation would look like:
    // String asset = isFartMode ? 'fart.mp3' : 'burp.mp3';
    // await _audioPlayer.play(AssetSource(asset));

    // 3. Handle Ad Logic
    setState(() {
      triggerCount++;
    });

    if (triggerCount % 10 == 0) {
      _showInterstitialAd();
    }
  }

  void _showInterstitialAd() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("ADVERTISEMENT"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.movie, size: 50, color: Colors.grey)),
            ),
            const SizedBox(height: 10),
            const Text("This is a simulated Interstitial Ad after 10 triggers."),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("CLOSE (X)"))],
      ),
    );
  }

  // --- Widget Builders ---

  @override
  Widget build(BuildContext context) {
    // Colors
    final Color denimBlue = const Color(0xFF2B4F81);
    final Color stitchColor = const Color(0xFFE8A631); // Gold/Orange stitching

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "THE FART GUN",
                style: GoogleFonts.luckiestGuy(
                  fontSize: 40,
                  color: denimBlue,
                  shadows: [const Shadow(offset: Offset(2, 2), color: Colors.white, blurRadius: 0)],
                ),
              ),
            ),

            // --- MAIN CONTENT AREA (Jeans Background) ---
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: denimBlue,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border.all(color: stitchColor, width: 3, style: BorderStyle.solid),
                  boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 1. The "Gun" Visual (Placeholder)
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/512/942/942748.png', // Generic toy gun icon
                      height: 120,
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.toys, size: 100, color: Colors.white),
                    ),

                    // 2. Mode Switcher (Fart vs Burp)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: [
                          _buildModeButton("FARTS", Icons.air, true),
                          _buildModeButton("BURPS", Icons.bubble_chart, false),
                        ],
                      ),
                    ),

                    // 3. The Wacky Trigger Button
                    GestureDetector(
                      onTap: _triggerSound,
                      child: Transform.scale(
                        scale: 1 - _controller.value,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                            border: Border.all(color: Colors.grey.shade300, width: 8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(0, 10),
                                blurRadius: 10,
                              ),
                            ],
                            gradient: const RadialGradient(
                              colors: [Color(0xFFFF5F5F), Color(0xFFB71C1C)],
                              center: Alignment(-0.4, -0.4),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.touch_app, size: 50, color: Colors.white),
                                Text("POOT!", style: GoogleFonts.luckiestGuy(fontSize: 32, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Trigger Counter Text
                    Text(
                      "Triggers: $triggerCount",
                      style: GoogleFonts.robotoMono(color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // --- BANNER AD PLACEHOLDER ---
            Container(
              height: 60,
              width: double.infinity,
              color: Colors.black,
              child: const Center(
                child: Text(
                  "BANNER AD SPACE",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the toggle buttons
  Widget _buildModeButton(String label, IconData icon, bool isForFart) {
    bool isSelected = (isFartMode == isForFart);
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchMode(isForFart),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF5E050) : Colors.transparent, // Minion Yellow if selected
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.black : Colors.white70),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.luckiestGuy(color: isSelected ? Colors.black : Colors.white70, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
