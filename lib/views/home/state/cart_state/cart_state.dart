part of 'cart_cubit.dart';

class CartState {
  final List<Order> cart;
  final String payment_method;
  final int table_code;

  final double total;
  final AppStatus status;
  final String? error;
  final String temp_observation;
  CartState({
    required this.cart,
    required this.payment_method,
    required this.table_code,
    required this.total,
    required this.status,
    this.error,
    required this.temp_observation,
  });

  // CartState({
  //   required this.cart,
  //   required this.status,
  //   required this.total,
  //   required this.error,
  //   required this.temp_observation,
  // });

  factory CartState.initial() => CartState(
        payment_method: "",
        table_code: 0,
        cart: [],
        status: AppStatus.initial,
        total: 0,
        error: "",
        temp_observation: "",
      );
  // CartState copyWith({
  //   List<Order>? cart,
  //   AppStatus? status,
  //   double? total,
  //   String? error,
  //   String? temp_observation,
  //   List<String>? itens_added,
  // }) {
  //   return CartState(
  //     cart: cart ?? this.cart,
  //     status: status ?? this.status,
  //     total: total ?? this.total,
  //     error: error ?? this.error,
  //     temp_observation: temp_observation ?? this.temp_observation,
  //   );
  // }

  CartState copyWith({
    List<Order>? cart,
    String? payment_method,
    int? table_code,
    double? total,
    AppStatus? status,
    String? error,
    String? temp_observation,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      payment_method: payment_method ?? this.payment_method,
      table_code: table_code ?? this.table_code,
      total: total ?? this.total,
      status: status ?? this.status,
      error: error ?? this.error,
      temp_observation: temp_observation ?? this.temp_observation,
    );
  }
}
