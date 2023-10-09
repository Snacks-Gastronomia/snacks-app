import 'dart:developer';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:snacks_app/models/item_model.dart';

import 'package:snacks_app/models/order_model.dart';
import 'package:snacks_app/services/firebase/notifications.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/storage.dart';
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
  //final storage = const FlutterSecureStorage();
  final storage = AppStorage.initStorage;

  CartCubit() : super(CartState.initial());

  void addToCart(OrderModel newOrder) {
    if (hasItem(newOrder.item.id!)) {
      var ord = getOrderByItemId(newOrder.item.id!);
      if (ord != null) {
        updateItemFromCart(newOrder);
      }
    } else {
      final newCart = [...state.cart, newOrder];

      emit(state.copyWith(cart: newCart));
    }
    updateTotalValue();
    emit(state.copyWith(temp_observation: ""));
  }

  updateItemFromCart(OrderModel newOrder) {
    final newCart = state.cart.map((item) {
      if (item.item.id == newOrder.item.id) {
        return item.copyWith(
            observations: newOrder.observations,
            option_selected: newOrder.option_selected,
            amount: newOrder.amount,
            extras: newOrder.extras);
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
    final newCart = state.cart.map((order) {
      var item = order.item;
      if (order.item.id == id) {
        return order.copyWith(amount: (order.amount + 1));
      }
      return order;
    }).toList();

    emit(state.copyWith(cart: newCart));
    updateTotalValue();
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
  }

  void removeToCart(OrderModel order) {
    final newCart = state.cart;
    newCart.removeWhere((element) => element.item.id == order.item.id);

    emit(state.copyWith(cart: newCart));

    updateTotalValue();
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
    emit(state.copyWith(total: total));
  }

  get getStorage async => storage.readAll(
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ));

  Future<void> makeOrder(String method,
      {String? rfid = "", String change = ""}) async {
    final notification = AppNotification();
    var data = await generateDataObject(method, change, rfid);

    await repository.createOrder(data);

    if (auth.currentUser?.isAnonymous ?? false) {
      var stor = await storage.readAll();
      notification.sendNotificationToWaiters(table: stor["table"].toString());

      // await cardRepository.doPayment(rfid, state.total);
    }

    clearCart();
  }

  void updateReceiveOrderMethod(String value) {
    // print(value);
    emit(state.copyWith(receive_order: value));
  }

  Future<List<Map<String, dynamic>>> generateDataObject(
      method, change, rfid) async {
    final dataStorage = await getStorage;
    bool isDelivery =
        (!auth.currentUser!.isAnonymous && state.receive_order != "local");

    var status = method == "Cartão snacks" || isDelivery
        ? OrderStatus.ready_to_start.name
        : OrderStatus.waiting_payment.name;

    List<String> restaurants = [];

    state.cart.map((e) {
      if (restaurants.contains(e.item.restaurant_id)) {
        restaurants.add(e.item.restaurant_id);
      }
    });
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    DataOrder dataTotal = DataOrder(done: [], orders: []);
    // ignore: iterable_contains_unrelated_type
    String order_code = generateOrderCode();

    for (var e in state.cart) {
      if (dataTotal.done.contains(e.item.restaurant_id)) {
        dataTotal.orders.map((el) {
          if (el["restaurant"] == e.item.restaurant_id) {
            el["items"] = [...el["items"], e.toMap()];
            el["value"] += e.getTotalValue;
            return el;
          }
          return el;
        }).toList();
      } else {
        dataTotal.done = [...dataTotal.done, e.item.restaurant_id];
        dataTotal.orders.add({
          "items": [e.toMap()],
          "user_uid": auth.currentUser?.uid,
          "payment_method": method,
          "phone_number": auth.currentUser?.phoneNumber,
          "rfid": rfid,
          "value": e.getTotalValue,
          "restaurant": e.item.restaurant_id,
          "restaurant_name": e.item.restaurant_name,
          "isDelivery": isDelivery,
          "delivery_value": (isDelivery ? state.delivery_value : 0).toDouble(),
          "code": order_code,
          "customer_name": auth.currentUser?.displayName,
          "part_code": order_code.split("-")[0],
          "status": status,
          "receive_order": state.receive_order,
          "need_change": change.toString().isNotEmpty,
          "_app_version": version,
          if (change.toString().isNotEmpty) "money_change": change,
          "created_at": FieldValue.serverTimestamp(),
          if (isDelivery)
            "address": dataStorage["address"]
          else
            "table": dataStorage["table"]
        });
      }
    }
    if (isDelivery) {
      dataTotal.orders[0]["value"] += state.delivery_value;
    }

    return dataTotal.orders;
  }

  generateOrderCode() {
    var str = generateRandomString(3);
    var str_code = generateRandomStringWNumbers(6);
    var numb = generateRandomNumber(100, 999);

    return '$str$numb-$str_code';
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  String generateRandomStringWNumbers(int len) {
    var r = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890@#&';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  int generateRandomNumber(int min, int max) {
    var random = Random();
    var randomNumber = min + random.nextInt(max - min);
    return randomNumber;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchOrders() {
    if (auth.currentUser != null) {
      return repository.fetchOrdersByUserId(auth.currentUser!.uid);
      // return repository.fetchOrdersByUserId("jaTjsvdG0Wg1LKM8UZm92apOppH3");
    }

    return const Stream.empty();
  }

  void clearCart() {
    emit(state.copyWith(
      cart: [],
    ));
  }

  bool emptyCart() {
    return state.cart.isEmpty;
  }

  void changeStatus(AppStatus status) {
    emit(state.copyWith(status: status));
  }

  Future<void> fetchDeliveryConfig() async {
    final value = await repository.fetchDeliveryConfig();

    final address = await storage.read(key: "address");
    final receive = value.docs[0].data()["active"] &&
            !(auth.currentUser?.isAnonymous ?? true) &&
            (address != null && address.isNotEmpty)
        ? "address"
        : "local";
    emit(state.copyWith(
        receive_order: receive,
        address: address ?? "",
        delivery_disable: !value.docs[0].data()["active"],
        delivery_value:
            double.tryParse(value.docs[0].data()["value"].toString())));
  }

  Future<void> cancelOrder(List<String?> docs) async {
    print(docs);
    return await repository.updateStatus(docs, OrderStatus.canceled);
  }
}
