import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/views/home/repository/orders_repository.dart';

part 'cart_state.dart';

class DataOrder {
  List<String> done;
  List<Map<String, dynamic>> orders;
  DataOrder({
    required this.done,
    required this.orders,
  });
}

class CartCubit extends Cubit<CartState> {
  final repository = OrdersRepository();
  final auth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();

  CartCubit() : super(CartState.initial());

  void addToCart(Order newOrder) {
    // print(newOrder);

    // newOrder.observations = state.temp_observation;

    if (hasItem(newOrder.item.id!)) {
      var ord = getOrderByItemId(newOrder.item.id!);
      if (ord != null) {
        ord.copyWith(
            amount: newOrder.amount, observations: newOrder.observations);
      }
    }

    final newCart = [...state.cart, newOrder];

    emit(state.copyWith(cart: newCart));
    updateTotalValue();
    emit(state.copyWith(temp_observation: ""));
    print(state);
  }

  updateItemFromCart(Order order) {
    final newCart = state.cart.map((item) {
      if (item.item.id == order.item.id) {
        return item.copyWith(
            amount: order.amount,
            item: order.item,
            observations: order.observations);
      }
      return item;
    }).toList();

    emit(state.copyWith(cart: newCart));
    updateTotalValue();
  }

  bool hasItem(String id) {
    var item = state.cart.where((element) => element.item.id == id);
    return item.isNotEmpty;
  }

  Order? getOrderByItemId(String id) {
    return hasItem(id)
        ? state.cart.singleWhere((el) => el.item.id == id)
        : null;
  }

  void incrementItem(String id) {
    final newCart = state.cart.map((item) {
      if (item.item.id == id) {
        return item.copyWith(amount: (item.amount + 1));
      }
      return item;
    }).toList();

    emit(state.copyWith(cart: newCart));
    updateTotalValue();
    print(state);
  }

  void decrementItem(String id) {
    final newCart = state.cart.map((item) {
      if (item.item.id == id) {
        if (item.amount > 1) return item.copyWith(amount: (item.amount - 1));
      }
      return item;
    }).toList();

    emit(state.copyWith(cart: newCart));
    updateTotalValue();
    print(state);
    print(state.total);
  }

  void removeToCart(Order order) {
    final newCart = state.cart;
    newCart.removeWhere((element) => element.item.id == order.item.id);

    emit(state.copyWith(cart: newCart));

    updateTotalValue();
    print(state);
  }

  void updateTotalValue() {
    double total = 0;
    for (var element in state.cart) {
      total += element.item.value * element.amount;
    }
    print(total);
    emit(state.copyWith(total: total));
  }

  get getStorage async => storage.readAll(
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ));

  void makeOrder(String method) async {
    final dataStorage = await getStorage;

    bool isDelivery = !auth.currentUser!.isAnonymous;
    var status = method == "Cartão Snacks" || isDelivery
        ? OrderStatus.ready_to_start.name
        : OrderStatus.waiting_payment.name;

    final now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    List<String> restaurants = [];
    state.cart.map((e) {
      if (!restaurants.contains(e.item.restaurant_id)) {
        restaurants.add(e.item.restaurant_id);
      }
    });

    Map<String, dynamic> data = {
      // "items": FieldValue.arrayUnion(state.cart.map((e) => e.toMap()).toList()),
      "user_uid": auth.currentUser!.uid,
      "payment_method": method,
      "value": state.total,
      // "restaurants": restaurants,
      "isDelivery": isDelivery,
      "status": status,
      "created_at": DateTime.now(),
    };

    data.addAll(isDelivery
        ? {"address": dataStorage["address"]}
        : {"table": dataStorage["table"]});

    DataOrder dataTotal = DataOrder(done: [], orders: []);
    // ignore: iterable_contains_unrelated_type
    for (var e in state.cart) {
      if (dataTotal.done.contains(e.item.restaurant_id)) {
        dataTotal.orders.map((el) {
          if (el["restaurant"] == e.item.restaurant_id) {
            el["items"] = [...el["items"], e.toMap()];
            el["value"] += e.item.value;
            return el;
          }
          return el;
        }).toList();
      } else {
        dataTotal.done = [...dataTotal.done, e.item.restaurant_id];
        dataTotal.orders.add({
          "items": [e.toMap()],
          "user_uid": auth.currentUser!.uid,
          "payment_method": method,
          "value": e.item.value,
          "restaurant": e.item.restaurant_id,
          "isDelivery": isDelivery,
          "status": status,
          "created_at": DateTime.now(),
          if (isDelivery)
            "address": dataStorage["address"]
          else
            "table": dataStorage["table"]
        });
      }
    }
    // List<dynamic> listRestaurantOrders = [];
    // List<dynamic> added = [];
    await repository.createOrder(dataTotal.orders);
    // state.cart.map((e) {
    //   e.item.restaurant_id;

    //   if (added.contains(e.item.restaurant_id)) {
    //     var data = listRestaurantOrders.singleWhere(
    //         (element) => element.restaurant_id == e.item.restaurant_id);
    //     data.items = [...data.items, e.item];

    //   } else {
    //   var data =

    //     added.add(e.item.restaurant_id);

    //   }
    //   // listRestaurantOrders.singleWhere((element) => element.restaurant_id == e.item.restaurant_id);
    // });

    // var items = state.cart.map((e) => e.toMap()).toList();
    // await repository.createItemstoOrder(items, response);
    clearCart();
  }

  Stream<QuerySnapshot> fetchOrders() {
    return repository.fetchOrdersByUserId(auth.currentUser!.uid);
  }

  void clearCart() {
    emit(state.copyWith(cart: []));
  }

  void changeStatus(AppStatus status) {
    emit(state.copyWith(status: status));
  }
}
