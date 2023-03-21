import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:snacks_app/models/item_model.dart';

import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/services/firebase/notifications.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/views/home/repository/card_repository.dart';
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
  final cardRepository = CardRepository();
  final auth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();

  CartCubit() : super(CartState.initial());

  void addToCart(OrderModel newOrder) {
    // print(newOrder);

    // newOrder.observations = state.temp_observation;

    if (hasItem(newOrder.item.id!)) {
      var ord = getOrderByItemId(newOrder.item.id!);
      if (ord != null) {
        ord.copyWith(
            amount: newOrder.amount,
            observations: newOrder.observations,
            option_selected: newOrder.option_selected);
      }
    }

    final newCart = [...state.cart, newOrder];

    emit(state.copyWith(cart: newCart));
    updateTotalValue();
    emit(state.copyWith(temp_observation: ""));
  }

  updateItemFromCart(OrderModel order) {
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

  OrderModel? getOrderByItemId(String id) {
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

  void removeToCart(OrderModel order) {
    final newCart = state.cart;
    newCart.removeWhere((element) => element.item.id == order.item.id);

    emit(state.copyWith(cart: newCart));

    updateTotalValue();
    print(state);
  }

  void updateTotalValue() {
    double total = 0;
    for (var element in state.cart) {
      double extras_value = element.extras.isNotEmpty
          ? element.extras
              .map((e) => double.parse(e["value"].toString()))
              .reduce((value, element) => value + element)
          : 0;
      total += (double.parse(element.option_selected["value"].toString()) *
              element.amount) +
          extras_value;
    }
    // if (!(auth.currentUser?.isAnonymous ?? false)) {
    //   total += 5;
    // }
    emit(state.copyWith(total: total));
  }

  get getStorage async => storage.readAll(
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ));

  void makeOrder(String method, {String rfid = "", String change = ""}) async {
    final notification = AppNotification();
    if (method == "Cartão Snacks") {
      await cardRepository.doPayment(rfid, state.total);
    } else {
      var stor = await getStorage;
      notification.sendNotificationToWaiters(table: stor["table"].toString());
    }
    var data = await generateDataObject(method, change);
    await repository.createOrder(data);
    clearCart();
  }

  Future<List<Map<String, dynamic>>> generateDataObject(method, change) async {
    final dataStorage = await getStorage;
    bool isDelivery = !(auth.currentUser?.isAnonymous ?? true);

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
        double extra = e.extras.isNotEmpty
            ? e.extras
                .map((e) => double.parse(e["value"].toString()))
                .reduce((value, element) => value + element)
            : 0;
        dataTotal.done = [...dataTotal.done, e.item.restaurant_id];
        dataTotal.orders.add({
          "items": [e.toMap()],
          "user_uid": auth.currentUser?.uid ?? "",
          "payment_method": method,
          "value":
              double.parse(e.option_selected["value"].toString()) * e.amount +
                  extra +
                  (isDelivery ? 5 : 0),
          "restaurant": e.item.restaurant_id,
          "restaurant_name": e.item.restaurant_name,
          "isDelivery": isDelivery,
          "status": status,
          "need_change": change.toString().isNotEmpty,
          if (change.toString().isNotEmpty) "money_change": change,
          "created_at": DateTime.now(),
          if (isDelivery)
            "address": dataStorage["address"]
          else
            "table": dataStorage["table"]
        });
      }
    }
    return dataTotal.orders;
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
