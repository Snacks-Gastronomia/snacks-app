import 'package:snacks_app/services/auth_service.dart';

class AuthenticateRepository {
  final AuthApiServices services;

  AuthenticateRepository({
    required this.services,
  });

  Future<dynamic> getAddress(double lat, double long) async {
    try {
      return await services.getAddressFromCoordinates(lat, long);
    } catch (e) {
      throw e.toString();
    }
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

  Future<dynamic> checkUser({required String phone}) async {
    try {
      return await services.userAlreadyRegistred(phone);
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
}
