// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snacks_app/models/coupom_model.dart';

abstract class CouponState {}

class CouponLoaded extends CouponState {
  List<CoupomModel> couponsList;
  String message;
  CouponLoaded({
    required this.couponsList,
    required this.message,
  });
}

class CouponLoading extends CouponState {}

class CouponError extends CouponState {
  String message;
  CouponError({
    required this.message,
  });
}
