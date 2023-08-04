import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:snacks_app/services/app_session.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/storage.dart';
import 'package:snacks_app/views/authentication/repository/auth_repository.dart';
import 'package:snacks_app/services/auth_service.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthenticateRepository repository =
      AuthenticateRepository(services: AuthApiServices());
  final auth = FirebaseAuth.instance;
  final _localStorage = AppStorage();
  AuthCubit() : super(AuthState.initial());

  otpVerification(String value) async {
    emit(state.copyWith(status: AppStatus.loading));
    var user = await repository.otpVerification(state.verificationID, value);

    emit(state.copyWith(status: AppStatus.loaded));
    if (user == null) {
      emit(state.copyWith(status: AppStatus.error));
    }
    print(user);
    print(auth.currentUser);
    return user;
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<dynamic> sendOTPValidation() async {
    // changeStatus(AppStatus.loading);
    // var response = await repository.sendCode("+55 ${state.phone!}");
    // emit(state.copyWith(verificationID: response));
    // changeStatus(AppStatus.loaded);
    // print(state.verificationID);

    // return response;
  }

  Future<dynamic> getCurrentAddress() async {
    emit(state.copyWith(status: AppStatus.loading));
    var address = AddressType.initial();

    try {
      var position = await determinePosition();

      print('${position.latitude}  ${position.longitude}');

      // var data = await repository.getLocationAddress(
      //     position.latitude, position.longitude);
      var data = await repository
          .getAddressesFromQuery('${position.longitude},${position.latitude}');
      if (List.from(data).isNotEmpty) {
        GeocodingResponse addressRes = List.from(data)[0];

        var street = addressRes.place_name.split(",")[0];
        var _address = addressRes.place_name.replaceFirst("$street,", "");

        address = AddressType(
            street: street, address: _address, complete: addressRes.place_name);
        // address = formatAddress(data["address"], data["address_type"]);
      }
    } catch (e) {
      print("cubit error");
    }
    emit(state.copyWith(status: AppStatus.loaded));
    print(address);
    return address;
  }

  formatAddress(GeocodingResponse address) {
    var ads = AddressType.initial();

    var street = address.place_name.split(",")[0];
    var _address =
        address.place_name.substring(0, address.place_name.indexOf(','));
    // var street = address["road"] ?? "";

    // String number = address["house_number"] ?? "";
    // var district = address["city_district"] ?? "";
    // var state = address["state"] ?? "";
    // var city = address["city"] ?? "";
    // var postcode = address["postcode"] ?? "";

    // String number_district = number;
    // number_district += number.isNotEmpty ? " - " : "";
    // number_district += district;
    // number_district += number_district.isEmpty ? "" : ", ";
    // var ads = AddressType(
    //   address: ' $number_district'
    //       '$state - $city, $postcode',
    //   street: street,
    //   complete: '$street, $number_district'
    //       '$state - $city, $postcode',
    // );
    return ads;
  }

  void saveUser() async {
    changeStatus(AppStatus.loading);
    String address = convertAddressToString;
    await repository.createUser(uid: auth.currentUser!.uid, address: address);

    repository.storageAddress(address);
    changeStatus(AppStatus.loaded);
  }

  void saveUserName() async {
    await auth.currentUser!.updateDisplayName(state.name);
  }

  String get convertAddressToString =>
      '${state.street_address}, ${state.number_address}, ${state.district_address}${state.obs_address.isNotEmpty ? " - ${state.obs_address}" : ""}';
  void convertAddressStringToObject(String str) {
    var split = str.split(", ");
    emit(state.copyWith(
      street_address: split[0],
      number_address: split[1],
      district_address: split[2].split(" - ")[0],
      obs_address: split[2].split(" - ")[1],
    ));
  }

  Future<bool> checkUser() async {
    changeStatus(AppStatus.loading);
    Map<String, dynamic>? response =
        await repository.checkUser(uid: auth.currentUser!.uid);
    final session = AppSession();
    changeStatus(AppStatus.loaded);
    if (response != null) {
      repository.storageAddress(response["address"] ?? "");
      await session.create();
      return true;
    }
    return false;
  }

  get validateNumber => state.phone!.length == 15;

  void changeName(String value) {
    emit(state.copyWith(name: value));
    print(state);
  }

  void changeVerificationId(String value) {
    emit(state.copyWith(verificationID: value));
    print("verification id state:");
    print(state);
  }

  void changePhone(String value) {
    emit(state.copyWith(phone: value));
    // print(state);
  }

  void changeStreet(String value) {
    emit(state.copyWith(street_address: value));
    print(state);
  }

  void changeNumber(String value) {
    emit(state.copyWith(number_address: value));
    print(state);
  }

  void changeObservations(String value) {
    emit(state.copyWith(obs_address: value));
    print(state);
  }

  void changeDistrict(String value) {
    emit(state.copyWith(district_address: value));
    print(state);
  }

  void updateAddress(String address) {
    // state.address_input_controller.text = state.address.complete;
    convertAddressStringToObject(address);
    emit(state.copyWith(status: AppStatus.editing));
  }

  Future<void> updateAddressFromDatabase() async {
    var address = convertAddressToString;

    await Future.wait([
      repository.updateAddress(auth.currentUser!.uid, address),
      _localStorage.updateStorage("address", address)
    ]);

    changeStatus(AppStatus.loaded);

    return;
  }

  Future<Iterable<dynamic>> fecthAddress(String query) async {
    var position = await determinePosition();
    // position
    return await repository.getAddressesFromQuery(query, proximity: position);
  }

  void throwError(String message) {
    emit(state.copyWith(status: AppStatus.error, error: message));
    print(state);
  }

  void changeStatus(AppStatus status) {
    emit(state.copyWith(status: status));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getFeatureDelivery() {
    return repository.getDeliveryFeatureStatus();
  }
}
