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

  void selecteExtras(String extra) {
    List<String> extras = List.from(state.order!.extras);
    if (extras.contains(extra)) {
      extras.remove(extra);
      emit(state.copyWith(order: state.order!.copyWith(extras: extras)));
    } else {
      emit(state.copyWith(
          order: state.order!.copyWith(extras: [...extras, extra])));
    }
    print(state.order!.amount);
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
    print(state);
  }

  void insertItem(OrderModel order, bool isNew) {
    emit(state.copyWith(order: order, isNew: isNew));
    print(state);
  }

  getNewValue() {
    return state.order!.item.value * state.order!.amount;
  }
}
