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
  delivered,
  invalid
}

extension ParseToString on OrderStatus {
  String get displayEnum {
    switch (this) {
      case OrderStatus.waiting_payment:
        return "Aguardando pagamento";
      case OrderStatus.ready_to_start:
        return "Pedido pronto para começar";
      case OrderStatus.order_in_progress:
        return "Pedido em andamento";
      case OrderStatus.done:
        return "Pedido pronto";
      case OrderStatus.waiting_delivery:
        return "Aguardando motoboy";
      case OrderStatus.in_delivery:
        return "Pedido à caminho";
      case OrderStatus.delivered:
        return "Pedido entregue";
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
      case OrderStatus.done:
        return Colors.green.shade400;
      case OrderStatus.in_delivery:
        return Colors.green.shade700;
      case OrderStatus.canceled:
        return const Color(0xffE20808);

      default:
        return Colors.black;
    }
  }
}
