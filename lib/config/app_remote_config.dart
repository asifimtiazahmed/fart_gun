// Package imports:
// Project imports:
import 'package:fart_gun/app_strings.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppRemoteConfig {
  static const String keyAppVersion = 'published_build_number';
  static String remoteVersion = '';
  static String localVersion = '';

  final _remoteConfig = FirebaseRemoteConfig.instance;
  late PackageInfo _packageManager = PackageInfo(
    appName: AppStrings.appName,
    packageName: '',
    version: '',
    buildNumber: '',
  );

  AppRemoteConfig() {
    _initRemoteConfig();
  }

  String get remoteBuildVersion => remoteVersion;
  String get localBuildVersion => localVersion;

  /// Load configs from the Firebase
  Future<void> _initRemoteConfig() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(fetchTimeout: const Duration(minutes: 1), minimumFetchInterval: const Duration(hours: 1)),
    );

    await _setDefaultConfig();

    RemoteConfigValue(null, ValueSource.valueStatic);
    // Any values that you set in the backend are fetched and stored in the Remote Config object.
    await _initPackageInfo();
    await _remoteConfig.fetchAndActivate();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    await _setDefaultConfig();
    _packageManager = info;
    localVersion = info.buildNumber;
    remoteVersion = _remoteConfig.getString(keyAppVersion);
  }

  /// Set default configs
  Future<void> _setDefaultConfig() async {
    String appBuildNumber = _packageManager.buildNumber.toString();
    await _remoteConfig.setDefaults(<String, dynamic>{keyAppVersion: appBuildNumber});
  }

  Future<Map<String, String>> fetchAppVersion() async {
    await _initPackageInfo();
    final String localBuildVersion = _packageManager.buildNumber;
    final String remoteBuildVersion = _remoteConfig.getString(keyAppVersion);
    return {'localVersion': localBuildVersion, 'remoteVersion': remoteBuildVersion};
  }
}
