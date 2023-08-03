import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderResponse {
  String? id;
  String code;
  bool needChange;
  String restaurant;
  DateTime createdAt;
  String restaurantName;
  bool isDelivery;
  String waiterPayment;
  String? rfid;
  String? address;
  String? receiveOrder;
  String? phoneNumber;
  String moneyChange;
  String waiterDelivery;
  String partCode;
  List<ItemResponse> items;
  double value;
  String paymentMethod;
  String? table;
  String status;
  String userUid;
  String? customerName;
  double deliveryValue;

  OrderResponse({
    required this.code,
    required this.needChange,
    required this.restaurant,
    required this.createdAt,
    required this.restaurantName,
    required this.isDelivery,
    required this.waiterPayment,
    this.moneyChange = "",
    this.rfid,
    this.address,
    this.id,
    this.receiveOrder,
    this.deliveryValue = 0.0,
    this.phoneNumber,
    required this.waiterDelivery,
    required this.partCode,
    required this.items,
    required this.value,
    required this.paymentMethod,
    this.table,
    required this.status,
    required this.userUid,
    this.customerName,
  });

  static List<Map<String, dynamic>> groupOrdersByCode(
      List<OrderResponse> orders) {
    final Map<String, List<OrderResponse>> groupedOrders = {};

    for (var order in orders) {
      if (groupedOrders.containsKey(order.partCode)) {
        groupedOrders[order.partCode]!.add(order);
      } else {
        groupedOrders[order.partCode] = [order];
      }
    }

    List<Map<String, dynamic>> data = [];

    groupedOrders.forEach((key, value) {
      data.add({"part_code": key, "orders": value});
    });

    return data;
  }

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> rawItems = json['items'];
    List<ItemResponse> items =
        rawItems.map((item) => ItemResponse.fromJson(item)).toList();

    return OrderResponse(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      needChange: json['need_change'] ?? false,
      restaurant: json['restaurant'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          json['created_at']['seconds'] * 1000),
      restaurantName: json['restaurant_name'] ?? '',
      isDelivery: json['isDelivery'] ?? false,
      waiterPayment: json['waiter_payment'] ?? '',
      rfid: json['rfid'],
      phoneNumber: json['phone_number'],
      waiterDelivery: json['waiter_delivery'] ?? '',
      partCode: json['part_code'] ?? '',
      items: items,
      value: json['value'] ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      table: json['table'] ?? 0,
      status: json['status'] ?? '',
      address: json['address'] ?? '',
      receiveOrder: json['receive_order'] ?? '',
      userUid: json['user_uid'] ?? '',
      customerName: json['customer_name'] ?? "",
      moneyChange: json['money_change'] ?? "",
      deliveryValue: json['delivery_value'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'needChange': needChange,
      'restaurant': restaurant,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'restaurantName': restaurantName,
      'isDelivery': isDelivery,
      'waiterPayment': waiterPayment,
      'rfid': rfid,
      'phoneNumber': phoneNumber,
      'waiterDelivery': waiterDelivery,
      'partCode': partCode,
      'items': items.map((x) => x.toMap()).toList(),
      'value': value,
      'paymentMethod': paymentMethod,
      'table': table,
      'receive_order': receiveOrder,
      'address': address,
      'status': status,
      'userUid': userUid,
      'customerName': customerName,
    };
  }

  factory OrderResponse.fromMap(Map<String, dynamic> map) {
    return OrderResponse(
      id: map['id'] ?? '',
      code: map['code'] ?? '',
      needChange: map['needChange'] ?? false,
      restaurant: map['restaurant'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      restaurantName: map['restaurantName'] ?? '',
      isDelivery: map['isDelivery'] ?? false,
      waiterPayment: map['waiterPayment'] ?? '',
      rfid: map['rfid'],
      phoneNumber: map['phoneNumber'],
      waiterDelivery: map['waiterDelivery'] ?? '',
      partCode: map['partCode'] ?? '',
      items: List<ItemResponse>.from(
          map['items']?.map((x) => ItemResponse.fromMap(x))),
      value: map['value']?.toDouble() ?? 0.0,
      paymentMethod: map['paymentMethod'] ?? '',
      table: map['table']?.toInt() ?? 0,
      status: map['status'] ?? '',
      userUid: map['userUid'] ?? '',
      customerName: map['customerName'],
      receiveOrder: map['receiveOrder'],
      address: map['address'] ?? "",
      moneyChange: map['money_change'] ?? "",
      deliveryValue: map['delivery_value'] ?? "",
    );
  }
  factory OrderResponse.fromFirebase(
      QueryDocumentSnapshot<Map<String, dynamic>> data) {
    Map<String, dynamic> map = data.data();
    Timestamp timestamp = map['created_at'];
    DateTime createdAtDateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds * 1000 + (timestamp.nanoseconds ~/ 1000000),
    );
    return OrderResponse(
      id: data.id,
      code: map['code'] ?? '',
      needChange: map['need_change'] ?? false,
      restaurant: map['restaurant'] ?? '',
      createdAt: createdAtDateTime,
      restaurantName: map['restaurant_name'] ?? '',
      isDelivery: map['isDelivery'] ?? false,
      waiterPayment: map['waiter_payment'] ?? '',
      rfid: map['rfid'],
      phoneNumber: map['phone_number'],
      waiterDelivery: map['waiter_nelivery'] ?? '',
      partCode: map['part_code'] ?? '',
      items: List<ItemResponse>.from(
          map['items']?.map((x) => ItemResponse.fromMap(x))),
      value: map['value']?.toDouble() ?? 0.0,
      paymentMethod: map['payment_method'] ?? '',
      table: map['table'] ?? "",
      status: map['status'] ?? '',
      userUid: map['user_uid'] ?? '',
      customerName: map['customer_name'],
      receiveOrder: map['receive_order'],
      address: map['address'],
      moneyChange: map['money_change'] ?? "",
      deliveryValue: map['delivery_value'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());
}

class ItemResponse {
  int amount;
  ItemDetails item;
  String? observations;
  List<dynamic>? extras;
  OptionSelected optionSelected;

  ItemResponse({
    required this.amount,
    required this.item,
    this.observations,
    this.extras,
    required this.optionSelected,
  });

  factory ItemResponse.fromJson(Map<String, dynamic> json) {
    return ItemResponse(
      amount: json['amount'] ?? 0,
      item: ItemDetails.fromJson(json['item']),
      observations: json['observations'],
      extras: json['extras'],
      optionSelected: OptionSelected.fromJson(json['option_selected']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'observations': observations,
      'extras': extras,
      'optionSelected': optionSelected.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory ItemResponse.fromMap(Map<String, dynamic> map) {
    return ItemResponse(
      item: ItemDetails.fromMap(map['item']),
      amount: map['amount']?.toInt() ?? 0,
      observations: map['observations'],
      extras: List<dynamic>.from(map['extras']),
      optionSelected: OptionSelected.fromMap(map['option_selected']),
    );
  }
}

class ItemDetails {
  String? measure;
  String imageUrl;
  String restaurantId;
  List<dynamic>? ingredients;
  bool active;
  String? description;
  String id;
  int time;
  String? category;
  String title;
  double value;
  String restaurantName;

  ItemDetails({
    this.measure,
    required this.imageUrl,
    required this.restaurantId,
    this.ingredients,
    required this.active,
    this.description,
    required this.id,
    required this.time,
    this.category,
    required this.title,
    required this.value,
    required this.restaurantName,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      measure: json['measure'],
      imageUrl: json['image_url'] ?? '',
      restaurantId: json['restaurant_id'] ?? '',
      ingredients: json['ingredients'],
      active: json['active'] ?? false,
      description: json['description'],
      id: json['id'] ?? '',
      time: json['time'] ?? 0,
      category: json['category'],
      title: json['title'] ?? '',
      value: json['value'] ?? 0.0,
      restaurantName: json['restaurant_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'measure': measure,
      'imageUrl': imageUrl,
      'restaurant_id': restaurantId,
      'ingredients': ingredients,
      'active': active,
      'description': description,
      'id': id,
      'time': time,
      'category': category,
      'title': title,
      'value': value,
      'restaurant_name': restaurantName,
    };
  }

  factory ItemDetails.fromMap(Map<String, dynamic> map) {
    return ItemDetails(
      measure: map['measure'],
      imageUrl: map['image_url'] ?? '',
      restaurantId: map['restaurant_id'] ?? '',
      ingredients: List<dynamic>.from(map['ingredients']),
      active: map['active'] ?? false,
      description: map['description'],
      id: map['id'] ?? '',
      time: map['time']?.toInt() ?? 0,
      category: map['category'],
      title: map['title'] ?? '',
      value: map['value']?.toDouble() ?? 0.0,
      restaurantName: map['restaurant_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
}

class OptionSelected {
  int id;
  String title;
  double value;

  OptionSelected({
    required this.id,
    required this.title,
    required this.value,
  });

  factory OptionSelected.fromJson(Map<String, dynamic> json) {
    return OptionSelected(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      value: json['value'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
    };
  }

  factory OptionSelected.fromMap(Map<String, dynamic> map) {
    return OptionSelected(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      value: double.tryParse(map['value']) ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());
}
