import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_app/models/coupom_model.dart';
import 'package:snacks_app/services/coupons_service.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/home/state/coupon_state/coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  final service = CouponsService();
  final toast = AppToast();

  CouponCubit() : super(CouponLoaded.style());

  Future<List<CoupomModel>> getListCoupons(restaurantId) async {
    var couponsList = await service.getCoupons(restaurantId);
    return couponsList;
  }

  Future<double> addCoupom(
      String value, String restaurantId, BuildContext context) async {
    emit(CouponLoading());

    var couponsList = await getListCoupons(restaurantId);
    double discount = 0;
    for (var coupon in couponsList) {
      if (coupon.code == value) {
        emit(CouponSucess.style(coupon.code));
        discount = coupon.discount.toDouble();
        // ignore: use_build_context_synchronously
        toast.showToast(
            context: context,
            content: "Cupom adicionado",
            type: ToastType.success);
        return discount;
      } else {
        emit(CouponLoaded.style());
        // ignore: use_build_context_synchronously
        toast.showToast(
          context: context,
          content: "Cupom inválido",
          type: ToastType.error,
        );
      }
    }
    return discount;
  }
}
