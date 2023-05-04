import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

    try {
      final userCredential = await auth.signInAnonymously();
      // var time =
      //     TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 7)));
      var dateTime = DateTime.now().add(const Duration(hours: 7));

      print(dateTime);
      await storage.write(key: "table", value: table);
      await storage.write(key: "endAt", value: dateTime.toString());

      print("Sign-in successful.");
      return userCredential;
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
  }

  String createToken() {
    final fbToken = FirebaseCustomTokenAuth();
    return fbToken.createToken();
  }
}
