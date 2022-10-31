import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/services/firebase/database.dart';

class OrdersApiServices {
  final db = FirebaseDataBase();
  final auth = FirebaseAuth.instance;

  Future<dynamic> createOrder(Map<String, dynamic> data) async {
    return await db.createDocumentToCollection(
        collection: "orders", data: data);
  }

  Future<dynamic> createItemstoOrder(
      List<Map<String, dynamic>> data, String doc_id) async {
    return await db.addOrderDocumentToCollection(
        collection: "orders", subcolletion: "items", data: data, docID: doc_id);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersByUserId(String id) {
    return FirebaseFirestore.instance
        .collection("orders")
        .where("user_uid", isEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  Future<dynamic> getOrdersByRestaurantId(String id) async {}
}
