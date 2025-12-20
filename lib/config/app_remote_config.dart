// lib/app_remote_config.dart

import 'dart:io';

import 'package:fart_gun/app_strings.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'log_manager.dart';

class AppUpdateStatus {
  final bool updateAvailable;
  final bool forceUpdate;
  final String localVersion;
  final String remoteVersion;
  final String message;
  final String storeUrl;

  const AppUpdateStatus({
    required this.updateAvailable,
    required this.forceUpdate,
    required this.localVersion,
    required this.remoteVersion,
    required this.message,
    required this.storeUrl,
  });
}

class AppRemoteConfig {
  // Remote Config keys (unified across iOS/Android)
  static const String keyLatestAppVersion = 'fart_app_latest_app_version';
  static const String keyUpdateMessage = 'update_message';
  static const String keyAppStoreUrl = 'fart_app_store_url';
  static const String keyPlayStoreUrl = 'fart_play_store_url';

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  PackageInfo _packageInfo = PackageInfo(
    appName: AppStrings.appName,
    packageName: '',
    version: '0.0.0',
    buildNumber: '0',
  );

  /// IMPORTANT: Do not auto-init in constructor (your AppConfig.configure should await init()).
  AppRemoteConfig();

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        // In debug, allow frequent refresh; in release keep it conservative.
        minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
      ),
    );

    await _initPackageInfo();

    // Defaults ensure the app behaves even if Remote Config is empty/offline.
    await _remoteConfig.setDefaults(<String, dynamic>{
      keyLatestAppVersion: _packageInfo.version, // default = current version
      keyUpdateMessage: '',
      keyAppStoreUrl: '',
      keyPlayStoreUrl: '',
    });

    // Fetch remote values
    await _remoteConfig.fetchAndActivate();

    AppLogger().i(
      '[RemoteConfig] Activated. local=${_packageInfo.version} remote=${_remoteConfig.getString(keyLatestAppVersion)} ',
    );
  }

  Future<void> _initPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  /// Compare semantic versions like "1.2.10" vs "1.3.0".
  bool _isVersionLower(String current, String remote) {
    final currentParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final remoteParts = remote.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLen = currentParts.length > remoteParts.length ? currentParts.length : remoteParts.length;

    for (int i = 0; i < maxLen; i++) {
      final c = i < currentParts.length ? currentParts[i] : 0;
      final r = i < remoteParts.length ? remoteParts[i] : 0;

      if (c < r) return true;
      if (c > r) return false;
    }
    return false;
  }

  String get localAppVersion => _packageInfo.version;
  String get remoteAppVersion => _remoteConfig.getString(keyLatestAppVersion);

  String get updateMessage => _remoteConfig.getString(keyUpdateMessage);

  String get storeUrl {
    final ios = _remoteConfig.getString(keyAppStoreUrl);
    final android = _remoteConfig.getString(keyPlayStoreUrl);
    return Platform.isIOS ? ios : android;
  }

  /// Main method your UI will call.
  Future<AppUpdateStatus> getUpdateStatus() async {
    // Ensure local package info is current (safe even after init).
    await _initPackageInfo();

    final local = localAppVersion.trim();
    final remote = remoteAppVersion.trim();

    final needsUpdate = _isVersionLower(local, remote);

    return AppUpdateStatus(
      updateAvailable: needsUpdate,
      forceUpdate: true,
      localVersion: local,
      remoteVersion: remote,
      message: updateMessage.trim(),
      storeUrl: storeUrl.trim(),
    );
  }
}
