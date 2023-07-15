import 'package:flutter/material.dart';

enum AppStatus { initial, loading, loaded, editing, error }

enum OrderStatus {
  waiting_payment,
  waiting_delivery,
  ready_to_start,
  order_in_progress,
  done,
  canceled,
  in_delivery,
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
      case OrderStatus.waiting_delivery:
        return "Aguardando o envio";
      case OrderStatus.done:
        return "Pedido pronto";
      case OrderStatus.in_delivery:
        return "Pedido saiu para entrega";
      case OrderStatus.canceled:
        return "Pedido cancelado";

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

      case OrderStatus.waiting_delivery:
        return Colors.pink.shade400;

      case OrderStatus.done:
        return Colors.green.shade400;

      case OrderStatus.canceled:
        return const Color(0xffE20808);

      case OrderStatus.in_delivery:
        return Colors.green.shade700;

      default:
        return Colors.black;
    }
  }
}
