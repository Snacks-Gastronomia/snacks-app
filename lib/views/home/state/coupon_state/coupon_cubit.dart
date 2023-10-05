import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_app/models/coupom_model.dart';
import 'package:snacks_app/services/coupons_service.dart';
import 'package:snacks_app/views/home/state/coupon_state/coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  final service = CouponsService();
  List<CoupomModel> couponsList = [];

  CouponCubit() : super(CouponLoading());

  Future<void> initCubit(restaurantId) async {
    service.getCoupons(restaurantId).then((data) {
      couponsList = CoupomModel.fromData(data.docs);
      emit(CouponLoaded(
          couponsList: couponsList, message: "Adicionar cupom de desconto"));
    });
  }

  Future<void> addCoupom(String value, String restaurantId) async {
    await service.getCoupons(restaurantId);
    for (var coupon in couponsList) {
      if (coupon.code == value) {
        print(true);
      }
    }
    print(false);
  }
}
