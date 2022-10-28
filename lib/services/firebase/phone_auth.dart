import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snacks_app/services/firebase/database.dart';

class FirebasePhoneAuthentication {
  final auth = FirebaseAuth.instance;
  final db = FirebaseDataBase();

  Future<User?> verifyCode(String verificationCode, String code) async {
    User? user;
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationCode, smsCode: code);
      await auth.signInWithCredential(credential).then((value) async {
        user = value.user;
      });
      if (user != null) {}
    } catch (e) {
      debugPrint(e.toString());
    }

    return user;
  }

  Future<String> sendCode(String phone) async {
    String _verficationID = "";

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // await FirebaseAuth.instance
          //     .signInWithCredential(credential)
          //     .then((value) async {
          //   if (value.user != null) {
          //     // Navigator.pushAndRemoveUntil(
          //     //     context,
          //     //     MaterialPageRoute(builder: (context) => Home()),
          //     //     (route) => false);
          //   }
          // });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          _verficationID = verificationID;
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          _verficationID = verificationID;
          // setState(() {
          //   _verificationCode = verificationID;
          // });
        },
        timeout: const Duration(seconds: 120));

    print(_verficationID);
    return _verficationID;
  }
}
