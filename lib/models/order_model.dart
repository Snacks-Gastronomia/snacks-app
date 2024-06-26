import 'dart:convert';

import 'package:snacks_app/models/item_model.dart';
import 'package:snacks_app/utils/enums.dart';

class OrderModel {
  final Item item;
  int amount;
  String observations;
  List<dynamic> extras;
  String status;
  dynamic option_selected;
  double value;
  OrderModel(
      {required this.item,
      this.amount = 1,
      this.status = "",
      required this.observations,
      required this.option_selected,
      this.value = 0.0,
      this.extras = const []}) {
    status = OrderStatus.waiting_payment.name;
  }

  OrderModel copyWith({
    Item? item,
    int? amount,
    String? observations,
    String? status,
    dynamic option_selected,
    List<dynamic>? extras,
  }) {
    return OrderModel(
      item: item ?? this.item,
      amount: amount ?? this.amount,
      observations: observations ?? this.observations,
      extras: extras ?? this.extras,
      option_selected: option_selected ?? this.option_selected,
      // status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'amount': amount,
      'observations': observations,
      'extras': extras,
      'option_selected': option_selected,
    };
  }

  double get getTotalValue {
    double extra = extras.isNotEmpty
        ? extras
            .map((e) => double.parse(e["value"].toString()))
            .reduce((value, element) => value + element)
        : 0;
    return ((double.parse(option_selected["value"].toString()) + extra) *
        amount *
        (1 - (item.discount! / 100)));
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      item: Item.fromMap(map['item']),
      amount: map['amount']?.toInt() ?? 0,
      observations: map['observations'] ?? '',
      option_selected: map['option_selected'] ?? {},
      extras: map['extras'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));
}
