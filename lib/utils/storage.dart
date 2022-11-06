import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppStorage {
  static FlutterSecureStorage get initStorage => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ));
}
