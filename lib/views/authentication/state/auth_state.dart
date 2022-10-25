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
  final AddressType address;
  final TextEditingController address_input_controller;
  final AppStatus? status;
  final String verificationID;
  final String? error;
  AuthState({
    this.name,
    this.password,
    this.phone,
    required this.address,
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
      address: AddressType.initial(),
      status: AppStatus.initial,
      error: "");

  AuthState copyWith({
    String? name,
    String? password,
    String? phone,
    AddressType? address,
    TextEditingController? address_input_controller,
    String? error,
    String? verificationID,
    AppStatus? status,
  }) {
    return AuthState(
        name: name ?? this.name,
        address_input_controller:
            address_input_controller ?? this.address_input_controller,
        password: password ?? this.password,
        error: error ?? this.error,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        status: status ?? this.status,
        verificationID: verificationID ?? this.verificationID);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'phone': phone,
      'address': address,
    };
  }

  @override
  String toString() {
    return 'AuthState(name: $name, password: $password, phone: $phone, address: $address, status: $status, verificationID: $verificationID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.name == name &&
        other.password == password &&
        other.phone == phone &&
        other.address == address &&
        other.status == status &&
        other.verificationID == verificationID;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        password.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        status.hashCode;
  }
}
