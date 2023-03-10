import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
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
    print(user);
    if (user != null) {
      emit(state.copyWith(status: AppStatus.loaded));
    }
    emit(state.copyWith(status: AppStatus.error));

    print(state);
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

      var data = await repository.getLocationAddress(
          position.latitude, position.longitude);

      address = formatAddress(data["address"], data["address_type"]);
    } catch (e) {
      print("cubit error");
    }
    emit(state.copyWith(status: AppStatus.loaded));
    print(address);
    return address;
  }

  formatAddress(dynamic address, dynamic address_type) {
    var street = address["road"] ?? "";

    String number = address["house_number"] ?? "";
    var district = address["city_district"] ?? "";
    var state = address["state"] ?? "";
    var city = address["city"] ?? "";
    var postcode = address["postcode"] ?? "";

    String number_district = number;
    number_district += number.isNotEmpty ? " - " : "";
    number_district += district;
    number_district += number_district.isEmpty ? "" : ", ";
    var ads = AddressType(
      address: ' $number_district'
          '$state - $city, $postcode',
      street: street,
      complete: '$street, $number_district'
          '$state - $city, $postcode',
    );
    return ads;
  }

  void saveUser() async {
    changeStatus(AppStatus.loading);
    await repository.createUser(
        uid: auth.currentUser!.uid, address: state.address.complete);
    await auth.currentUser!.updateDisplayName(state.name);
    repository.storageAddress(state.address.complete);
    changeStatus(AppStatus.loaded);
  }

  Future<bool> checkUser() async {
    changeStatus(AppStatus.loading);
    Map<String, dynamic>? response =
        await repository.checkUser(uid: auth.currentUser!.uid);

    changeStatus(AppStatus.loaded);
    if (response != null) {
      repository.storageAddress(response["address"]);
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

  void changeAddress(AddressType value) {
    state.address_input_controller.clear();
    emit(state.copyWith(address: value));
    print(state);
  }

  void changePassword(String value) {
    emit(state.copyWith(password: value));
    print(state);
  }

  void updateAddressFromScreen() {
    state.address_input_controller.text = state.address.complete;

    emit(state.copyWith(status: AppStatus.editing));
  }

  void updateAddressFromDatabase() {
    var address = state.address.complete;
    repository.updateAddress(auth.currentUser!.uid, address);
    _localStorage.updateStorage("address", address);
  }

  Future<Iterable<dynamic>> fecthAddress(String query) async {
    return await repository.getAddressesFromQuery(query);
  }

  void throwError(String message) {
    emit(state.copyWith(status: AppStatus.error, error: message));
    print(state);
  }

  void changeStatus(AppStatus status) {
    emit(state.copyWith(status: status));
  }
}
