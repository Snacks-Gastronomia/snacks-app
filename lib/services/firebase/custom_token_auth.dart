import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snacks_app/services/app_session.dart';

class FirebaseCustomTokenAuth {
  final auth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ));

  Future<UserCredential?> signIn({required String table}) async {
    print("try to generate token");
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInAnonymously();

      await storage.write(key: "table", value: table);

      final session = AppSession();
      await session.create();

      print("Sign-in successful.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-custom-token":
          print("The supplied token is not a Firebase custom auth token.");
          break;
        case "custom-token-mismatch":
          print("The supplied token is for a different Firebase project.");
          break;
        default:
          print("Unkown error.");
      }
    } catch (e) {
      print(e);
    }

    return userCredential;
  }

  String createToken() {
    final fbToken = FirebaseCustomTokenAuth();
    return fbToken.createToken();
  }
}
