import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/home/repository/card_repository.dart';

part 'card_state.dart';

class CardCubit extends Cubit<CardState> {
  final repository = CardRepository();
  final toast = AppToast();
  CardCubit() : super(CardState.initial());

  Future<bool> readCard(rfid, context) async {
    emit(state.copyWith(status: AppStatus.loading));
    toast.init(context: context);
    if (rfid == null || rfid == "") {
      emit(state.copyWith(status: AppStatus.loaded));

      toast.showToast(
          context: context,
          content: "Cartão Snacks inválido",
          type: ToastType.error);
    } else {
      var res = await repository.fetchCard(rfid);
      if (res != null) {
        emit(state.copyWith(
          status: AppStatus.loaded,
          hasData: true,
          nome: res["nome"],
          value: double.parse(res["saldo"].toString()),
        ));
        return true;
      } else {
        emit(state.copyWith(status: AppStatus.loaded, hasData: false));

        toast.showToast(
            context: context,
            content: "Cartão Snacks sem saldo",
            type: ToastType.info);
      }
    }
    return false;
  }

  changeStatus(AppStatus status) {
    emit(state.copyWith(status: status));
  }

  clear() {
    emit(state.copyWith(
      hasData: false,
      nome: "",
      value: 0,
    ));
  }

  payment(rfid, value) {}
}
