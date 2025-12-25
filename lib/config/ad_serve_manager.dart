import 'dart:io';

import 'package:fart_gun/config/log_manager.dart';
import 'package:fart_gun/const.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdServeManager {
  AdServeManager._();
  static final AdServeManager instance = AdServeManager._();
  bool isDebug = false;

  InterstitialAd? _interstitial;
  bool _interstitialReady = false;

  DateTime? _lastShown;

  bool get canShow {
    if (_lastShown == null) return true;
    return DateTime.now().difference(_lastShown!).inSeconds > 10;
  }

  /// ------------------------------------
  /// TEST IDS (SAFE FOR DEVELOPMENT)
  /// ------------------------------------
  static const _androidBannerTest = 'ca-app-pub-3940256099942544/6300978111';
  static const _iosBannerTest = 'ca-app-pub-3940256099942544/2934735716';

  static const _androidInterstitialTest = 'ca-app-pub-3940256099942544/1033173712';
  static const _iosInterstitialTest = 'ca-app-pub-3940256099942544/4411468910';

  /// ------------------------------------
  /// PROD IDS (REPLACE LATER)
  /// ------------------------------------
  static final _androidBannerProd = androidBannerAdId;
  static final _iosBannerProd = iosBannerAdId;

  static final _androidInterstitialProd = androidInterstitialAdId;
  static final _iosInterstitialProd = iosInterstitialAdId;

  /// Toggle here OR later via RemoteConfig
  bool get _useTestAds => isDebug;

  String get bannerId {
    if (_useTestAds) {
      AppLogger().i('fetching banner test ad');
      return Platform.isAndroid ? _androidBannerTest : _iosBannerTest;
    }
    AppLogger().i('fetching banner prod ad');
    return Platform.isAndroid ? _androidBannerProd : _iosBannerProd;
  }

  String get interstitialId {
    if (_useTestAds) {
      AppLogger().i('fetching interstitial test ad');
      return Platform.isAndroid ? _androidInterstitialTest : _iosInterstitialTest;
    }
    AppLogger().i('fetching interstitial prod ad');
    return Platform.isAndroid ? _androidInterstitialProd : _iosInterstitialProd;
  }

  /// ------------------------------------
  /// INIT
  /// ------------------------------------
  Future<void> init() async {
    await MobileAds.instance.initialize();
    AppLogger().i('AdMob initialized');
    _loadInterstitial();
  }

  /// ------------------------------------
  /// BANNER
  /// ------------------------------------
  BannerAd createBanner({required void Function() onLoaded}) {
    return BannerAd(
      size: AdSize.banner,
      adUnitId: bannerId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          AppLogger().i('Banner loaded');
          onLoaded();
        },
        onAdFailedToLoad: (ad, err) {
          AppLogger().e('Banner failed: $err');
          ad.dispose();
        },
      ),
    );
  }

  /// ------------------------------------
  /// INTERSTITIAL
  /// ------------------------------------
  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          AppLogger().i('Interstitial loaded');
          _interstitial = ad;
          _interstitialReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) => _reload(),
            onAdFailedToShowFullScreenContent: (_, __) => _reload(),
          );
        },
        onAdFailedToLoad: (err) {
          AppLogger().e('Interstitial load failed: $err');
          _interstitialReady = false;
        },
      ),
    );
  }

  void showInterstitialIfReady() {
    if (_interstitialReady && _interstitial != null && canShow) {
      _lastShown = DateTime.now();
      _interstitial!.show();
      _interstitialReady = false;
    }
  }

  void _reload() {
    _interstitial?.dispose();
    _interstitial = null;
    _loadInterstitial();
  }
}
