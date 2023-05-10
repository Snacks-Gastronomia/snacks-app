import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snacks_app/models/order_model.dart';

part 'item_screen_state.dart';

class ItemScreenCubit extends Cubit<ItemScreenState> {
  ItemScreenCubit() : super(ItemScreenState.initial());

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
      emit(state.copyWith(
          order: state.order!.copyWith(extras: [...extras, extra])));
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
}
