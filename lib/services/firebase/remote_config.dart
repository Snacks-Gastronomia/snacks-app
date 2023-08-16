import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  const FirebaseRemoteConfigService({
    required this.firebaseRemoteConfig,
  });

  final FirebaseRemoteConfig firebaseRemoteConfig;

  Future<void> init() async {
    try {
      await firebaseRemoteConfig.ensureInitialized();
      await firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await firebaseRemoteConfig.fetchAndActivate();
    } on FirebaseException catch (e, st) {
      developer.log(
        'Unable to initialize Firebase Remote Config',
        error: e,
        stackTrace: st,
      );
    }
  }

  String getAppVersionJson() => firebaseRemoteConfig.getString(
      Platform.isAndroid ? 'app_version_android' : 'app_version_ios');
  bool getReviewInProgress() => firebaseRemoteConfig.getBool('app_in_review');
}
