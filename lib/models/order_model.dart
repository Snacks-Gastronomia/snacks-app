import 'dart:convert';

import 'package:snacks_app/models/item_model.dart';
import 'package:snacks_app/utils/enums.dart';

class Order {
  final Item item;
  int amount;
  String observations;
  String status;
  Order({
    required this.item,
    this.amount = 1,
    this.status = "",
    required this.observations,
  }) {
    status = OrderStatus.waiting_payment.name;
  }
  // final String restaurant_id;
  // Order({
  //   required this.item,
  //   this.amount = 1,
  //   this.status,
  //   required this.observations,
  //   // required this.restaurant_id,
  // });

  Order copyWith({
    Item? item,
    int? amount,
    String? observations,
    String? status,
  }) {
    return Order(
      item: item ?? this.item,
      amount: amount ?? this.amount,
      observations: observations ?? this.observations,
      // status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'amount': amount,
      'observations': observations,
      // 'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      item: Item.fromMap(map['item']),
      amount: map['amount']?.toInt() ?? 0,
      observations: map['observations'] ?? '',
      // status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}
