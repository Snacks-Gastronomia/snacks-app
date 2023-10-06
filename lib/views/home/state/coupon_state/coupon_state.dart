// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class CouponState {}

class CouponLoaded extends CouponState {
  String message;
  Icon icon;
  Color color;
  CouponLoaded({
    required this.message,
    required this.icon,
    required this.color,
  });

  factory CouponLoaded.style() {
    return CouponLoaded(
        message: "Adicionar cupom de desconto",
        icon: const Icon(Icons.local_offer),
        color: const Color(0xFF28B1EC));
  }
}

class CouponSucess extends CouponState {
  String message;
  Icon icon;
  Color color;
  CouponSucess({
    required this.message,
    required this.icon,
    required this.color,
  });

  factory CouponSucess.style(code) {
    return CouponSucess(
        message: "$code Adicionado",
        icon: const Icon(
          Icons.check,
          color: Color(0xFF09B44D),
        ),
        color: const Color(0xFF09B44D));
  }
}

class CouponLoading extends CouponState {}

class CouponError extends CouponState {
  String message;
  CouponError({
    required this.message,
  });
}
