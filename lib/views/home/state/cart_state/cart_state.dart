// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_cubit.dart';

class CartState implements Equatable {
  final List<OrderModel> cart;
  final String payment_method;
  final int table_code;
  final String receive_order;
  final String address;
  final double delivery_value;
  final bool delivery_disable;
  final List<String> couponsList;

  final double total;
  final double paid;
  final AppStatus status;
  final String? error;
  final String temp_observation;

  CartState({
    required this.cart,
    required this.payment_method,
    required this.table_code,
    required this.receive_order,
    required this.address,
    required this.delivery_value,
    required this.delivery_disable,
    required this.couponsList,
    required this.total,
    required this.paid,
    required this.status,
    this.error,
    required this.temp_observation,
  });

  factory CartState.initial() => CartState(
      payment_method: "",
      table_code: 0,
      delivery_value: 0,
      delivery_disable: false,
      cart: [],
      status: AppStatus.initial,
      total: 0,
      paid: 0,
      error: "",
      address: "",
      receive_order: "address",
      temp_observation: "",
      couponsList: []);

  CartState copyWith(
      {List<OrderModel>? cart,
      String? payment_method,
      String? receive_order,
      bool? delivery_disable,
      int? table_code,
      double? total,
      double? paid,
      double? delivery_value,
      AppStatus? status,
      String? error,
      String? temp_observation,
      String? address,
      List<String>? couponsList}) {
    return CartState(
      cart: cart ?? this.cart,
      delivery_value: delivery_value ?? this.delivery_value,
      address: address ?? this.address,
      payment_method: payment_method ?? this.payment_method,
      receive_order: receive_order ?? this.receive_order,
      delivery_disable: delivery_disable ?? this.delivery_disable,
      table_code: table_code ?? this.table_code,
      total: total ?? this.total,
      paid: paid ?? this.paid,
      status: status ?? this.status,
      error: error ?? this.error,
      temp_observation: temp_observation ?? this.temp_observation,
      couponsList: couponsList ?? this.couponsList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
