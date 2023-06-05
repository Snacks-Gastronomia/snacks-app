import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:snacks_app/utils/enums.dart';

class AddressType {
  final String street;
  final String address;
  final String complete;
  AddressType({
    required this.street,
    required this.address,
    required this.complete,
  });

  factory AddressType.initial() =>
      AddressType(address: "", street: "", complete: "");
}

class AuthState {
  final String? name;
  final String? password;
  final String? phone;
  // final AddressType address;
  final String street_address;
  final String number_address;
  final String district_address;
  final String obs_address;
  final TextEditingController address_input_controller;
  final AppStatus? status;
  final String verificationID;
  final String? error;
  AuthState({
    this.name,
    this.password,
    this.phone,
    required this.street_address,
    required this.number_address,
    required this.district_address,
    required this.obs_address,
    required this.address_input_controller,
    this.status,
    required this.verificationID,
    this.error,
  });

  factory AuthState.initial() => AuthState(
      verificationID: "",
      address_input_controller: TextEditingController(),
      name: "",
      phone: "",
      district_address: "",
      number_address: "",
      street_address: "",
      obs_address: "",
      status: AppStatus.initial,
      error: "");

  AuthState copyWith({
    String? name,
    String? password,
    String? phone,
    String? street_address,
    String? number_address,
    String? district_address,
    String? obs_address,
    TextEditingController? address_input_controller,
    AppStatus? status,
    String? verificationID,
    String? error,
  }) {
    return AuthState(
      name: name ?? this.name,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      street_address: street_address ?? this.street_address,
      number_address: number_address ?? this.number_address,
      district_address: district_address ?? this.district_address,
      obs_address: obs_address ?? this.obs_address,
      address_input_controller:
          address_input_controller ?? this.address_input_controller,
      status: status ?? this.status,
      verificationID: verificationID ?? this.verificationID,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'phone': phone,
      'street_address': street_address,
      'number_address': number_address,
      'district_address': district_address,
      'obs_address': obs_address,
      'verificationID': verificationID,
      'error': error,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'AuthState(name: $name, password: $password, phone: $phone, street_address: $street_address, number_address: $number_address, district_address: $district_address, obs_address: $obs_address, address_input_controller: $address_input_controller, status: $status, verificationID: $verificationID, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.name == name &&
        other.password == password &&
        other.phone == phone &&
        other.street_address == street_address &&
        other.number_address == number_address &&
        other.district_address == district_address &&
        other.obs_address == obs_address &&
        other.address_input_controller == address_input_controller &&
        other.status == status &&
        other.verificationID == verificationID &&
        other.error == error;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        password.hashCode ^
        phone.hashCode ^
        street_address.hashCode ^
        number_address.hashCode ^
        district_address.hashCode ^
        obs_address.hashCode ^
        address_input_controller.hashCode ^
        status.hashCode ^
        verificationID.hashCode ^
        error.hashCode;
  }
}
