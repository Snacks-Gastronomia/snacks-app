import 'dart:convert';

import 'package:snacks_app/models/item_model.dart';
import 'package:snacks_app/utils/enums.dart';

class OrderModel {
  final Item item;
  int amount;
  String observations;
  List<String> extras;
  String status;
  OrderModel(
      {required this.item,
      this.amount = 1,
      this.status = "",
      required this.observations,
      this.extras = const []}) {
    status = OrderStatus.waiting_payment.name;
  }

  OrderModel copyWith({
    Item? item,
    int? amount,
    String? observations,
    String? status,
    List<String>? extras,
  }) {
    return OrderModel(
      item: item ?? this.item,
      amount: amount ?? this.amount,
      observations: observations ?? this.observations,
      extras: extras ?? this.extras,
      // status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'amount': amount,
      'observations': observations,
      'extras': extras,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      item: Item.fromMap(map['item']),
      amount: map['amount']?.toInt() ?? 0,
      observations: map['observations'] ?? '',
      extras: map['extras'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));
}
