// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:snacks_app/models/coupom_model.dart';

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

  factory CouponLoaded.primary() {
    return CouponLoaded(
        message: "Adicionar cupom de desconto",
        icon: const Icon(Icons.local_offer),
        color: Color(0xFF28B1EC));
  }
}

class CouponLoading extends CouponState {}

class CouponError extends CouponState {
  String message;
  CouponError({
    required this.message,
  });
}
