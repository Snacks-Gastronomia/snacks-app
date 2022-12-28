import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/views/home/repository/card_repository.dart';

part 'card_state.dart';

class CardCubit extends Cubit<CardState> {
  final repository = CardRepository();
  CardCubit() : super(CardState.initial());

  void readCard(rfid) async {
    emit(state.copyWith(status: AppStatus.loading));
    var res = await repository.fetchCard(rfid);
    if (res != null) {
      emit(state.copyWith(
        status: AppStatus.loaded,
        hasData: true,
        nome: res["nome"],
        value: double.parse(res["saldo"].toString()),
      ));
    }
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
