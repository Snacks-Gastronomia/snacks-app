import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:snacks_app/models/coupom_model.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/services/coupons_service.dart';
import 'package:snacks_app/utils/toast.dart';

part 'item_screen_state.dart';

class ItemScreenCubit extends Cubit<ItemScreenState> {
  ItemScreenCubit() : super(ItemScreenState.initial());

  final service = CouponsService();
  final toast = AppToast();

  void incrementAmount() {
    var amount = state.order!.amount + 1;

    emit(state.copyWith(order: state.order!.copyWith(amount: amount)));
    print(state.order!.amount);
  }

  bool hasItemId(int id) {
    List<dynamic> extras = List.from(state.order!.extras);
    bool found = false;

    for (var element in extras) {
      if (element["id"] == id) found = true;
    }

    return found;
  }

  void selectExtras(dynamic extra) {
    List<dynamic> extras = List.from(state.order!.extras);

    if (hasItemId(extra["id"])) {
      bool isLast = extras.length == 1;
      extras.remove(extra);

      var order = state.order!.copyWith(
        extras: isLast ? [] : extras,
      );
      emit(state.copyWith(order: order));
    } else {
      bool has_limit = state.order?.item.limit_extra_options != null;
      print(state.order?.item.limit_extra_options);
      bool allow_to_add = has_limit
          ? extras.length < state.order!.item.limit_extra_options!
          : false;

      if ((has_limit && allow_to_add) || !has_limit) {
        emit(state.copyWith(
            order: state.order!.copyWith(extras: [...extras, extra])));
      }
    }
  }

  void selectOption(dynamic op) {
    var item = state.order;
    emit(state.copyWith(order: item?.copyWith(option_selected: op)));
  }

  void decrementAmount() {
    var amount = state.order!.amount;
    if (amount != 1) {
      amount--;
      emit(state.copyWith(order: state.order!.copyWith(amount: amount)));
    }
  }

  void observationChanged(String obs) {
    emit(state.copyWith(order: state.order!.copyWith(observations: obs)));
  }

  void insertItem(OrderModel order, bool isNew) {
    emit(state.copyWith(order: order, isNew: isNew));
  }

  getNewValue() {
    return double.parse(
            state.order?.option_selected["value"].toString() ?? "0") *
        state.order!.amount;
  }

  Future<List<CoupomModel>> getListCoupons(restaurantId) async {
    var couponsList = await service.getCoupons(restaurantId);
    return couponsList;
  }

  Future<void> addCoupom(
      String value, String restaurantId, BuildContext context) async {
    var couponsList = await getListCoupons(restaurantId);
    double discount = 0;
    for (var coupon in couponsList) {
      if (coupon.code == value) {
        discount = coupon.discount.toDouble();
        // ignore: use_build_context_synchronously
        toast.showToast(
            context: context,
            content: "Cupom adicionado",
            type: ToastType.success);
        addDiscount(discount);
      } else {
        // ignore: use_build_context_synchronously
        toast.showToast(
          context: context,
          content: "Cupom inválido",
          type: ToastType.error,
        );
      }
    }
  }

  addDiscount(value) {
    // double itemValue = state.order!.getTotalValue;
    // double totalWithDiscount = itemValue - (itemValue * (value / 100));

    emit(state.copyWith(order: state.order!.copyWith(discount: value)));
  }
}
