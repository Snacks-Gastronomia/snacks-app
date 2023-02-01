import 'package:flutter/material.dart';

enum AppStatus { initial, loading, loaded, editing, error }

enum OrderStatus {
  waiting_payment,
  ready_to_start,
  order_in_progress,
  done,
  invalid
}

extension ParseToString on OrderStatus {
  // OrderStatus isEqual(dynamic value) {
  //   if (value is String) {
  //     return OrderStatus.values.firstWhere((e) => e.displayEnum == value);
  //   } else {
  //     return false;
  //   }
  // }

  String get displayEnum {
    switch (this) {
      case OrderStatus.waiting_payment:
        return "Aguardando pagamento";
      case OrderStatus.ready_to_start:
        return "Em fila";
      case OrderStatus.order_in_progress:
        return "Pedido em andamento";
      case OrderStatus.done:
        return "Pedido pronto";

      default:
        return "Status inválido";
    }
  }

  Color get getColor {
    switch (this) {
      case OrderStatus.waiting_payment:
        return Colors.black;
      case OrderStatus.order_in_progress:
        return Colors.blue.shade400;
      case OrderStatus.done:
        return Colors.green.shade400;

      default:
        return Colors.black;
    }
  }
}
