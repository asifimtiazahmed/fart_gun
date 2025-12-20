import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../firebase_options.dart';
import 'ad_serve_manager.dart';
import 'app_remote_config.dart';
import 'local_storage_service.dart';
import 'log_manager.dart';

class AppConfig {
  static Future<void> configure() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Always use bundled fonts; never hit the network for fonts.
    GoogleFonts.config.allowRuntimeFetching = false;
    // Register the OFL license for Didact Gothic
    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(['Luckiest Guy'], license);
    });

    GestureBinding.instance.resamplingEnabled = true; //Might help with Jank see flutter 1.22 release notes
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // Initialize Firebase Analytics
      final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      await analytics.setAnalyticsCollectionEnabled(true);

      //This overrides Flutters error framework to be posted into crashalytics
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      final localStorageService = LocalStorageService();

      //Registering instance of DataManager to store data
      await localStorageService.init();
      GetIt.I.registerSingleton<LocalStorageService>(localStorageService);
      final appRemoteConfig = AppRemoteConfig();
      await appRemoteConfig.init();
      GetIt.I.registerSingleton<AppRemoteConfig>(appRemoteConfig);
      await AdServeManager.instance.init();
    } else {
      AppLogger().logger.e('Platform not found, check app_config.dart');
    }
  }
}
