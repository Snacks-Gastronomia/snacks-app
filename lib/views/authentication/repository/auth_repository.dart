import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snacks_app/services/auth_service.dart';

class AuthenticateRepository {
  final AuthApiServices services;
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ));

  AuthenticateRepository({
    required this.services,
  });

  Future<dynamic> getLocationAddress(double lat, double long) async {
    try {
      return await services.getAddressFromCoordinates(lat, long);
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDeliveryFeatureStatus() {
    try {
      return services.getDeliveryFeatureStatus();
    } catch (e) {
      throw e.toString();
    }
  }

  void storageAddress(String address) async {
    await storage.write(key: "address", value: address);
  }

  Future<dynamic> otpVerification(String verificationID, String pin) async {
    try {
      return await services.otpValidation(verificationID, pin);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String?> sendCode(String number) async {
    try {
      return await services.sendOtpCode(number);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> createUser(
      {required String uid, required String address}) async {
    try {
      // await services.postUser(name: name, phone: phone, address: address);
      await services.creatUser(address: address, uid: uid);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>?> checkUser({required String uid}) async {
    try {
      return await services.userAlreadyRegistred(uid);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Iterable<dynamic>> getAddressesFromQuery(String query) async {
    try {
      return await services.fetchAddresses(query);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateAddress(String uid, String address) async {
    try {
      return await services.updateAddress(address, uid);
    } catch (e) {
      throw e.toString();
    }
  }
}
