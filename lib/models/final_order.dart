import 'package:snacks_app/models/order_model.dart';

class FinalOrder {
  final List<OrderModel> orders;
  final double total;
  final String payment_method;
  final int table_code;
  FinalOrder({
    required this.orders,
    required this.total,
    required this.payment_method,
    required this.table_code,
  });

  FinalOrder copyWith({
    List<OrderModel>? orders,
    double? total,
    String? payment_method,
    int? table_code,
  }) {
    return FinalOrder(
      orders: orders ?? this.orders,
      total: total ?? this.total,
      payment_method: payment_method ?? this.payment_method,
      table_code: table_code ?? this.table_code,
    );
  }
}
