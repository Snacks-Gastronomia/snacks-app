import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_app/models/coupom_model.dart';
import 'package:snacks_app/services/coupons_service.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/home/state/coupon_state/coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  final service = CouponsService();
  final toast = AppToast();
  List<CoupomModel> couponsList = [];

  CouponCubit() : super(CouponLoaded.primary());

  Future<void> addCoupom(
      String value, String restaurantId, BuildContext context) async {
    emit(CouponLoading());
    couponsList = await service.getCoupons(restaurantId);
    for (var coupon in couponsList) {
      if (coupon.code == value) {
        emit(CouponLoaded(
            message: "Cupom Adicionado",
            icon: const Icon(Icons.check),
            color: const Color(0xFF09B44D)));
        // ignore: use_build_context_synchronously
        toast.showToast(
            context: context,
            content: "Cupom adicionado",
            type: ToastType.success);
      } else {
        emit(CouponLoaded.primary());
        // ignore: use_build_context_synchronously
        toast.showToast(
          context: context,
          content: "Cupom inválido",
          type: ToastType.error,
        );
      }
    }
  }
}
