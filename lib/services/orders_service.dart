import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/services/firebase/database.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:http/http.dart' as http;

class OrdersApiServices {
  final db = FirebaseDataBase();
  final auth = FirebaseAuth.instance;
  final firebase = FirebaseFirestore.instance;
  final http.Client httpClient = http.Client();

  Future<void> createOrder(List<Map<String, dynamic>> data) async {
    // return await db.createDocumentToCollection(
    //     collection: "orders", data: data);
    var ref = firebase.collection("orders");

    var batch = firebase.batch();
    for (var element in data) {
      var docRef = ref.doc(); //automatically generate unique id
      batch.set(docRef, element);
    } // await FirebaseFirestore.instance

    await batch.commit();
  }

  Future<void> createItemstoOrder(
      List<Map<String, dynamic>> data, String doc_id) async {
    return await db.addOrderDocumentToCollection(
        collection: "orders", subcolletion: "items", data: data, docID: doc_id);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchOrderFromCard(
      String rfid) async {
    return await firebase
        .collection("orders")
        .where("rfid", isEqualTo: rfid)
        .get();
  }

  Future<dynamic> updateStatus(List<String?> ids, OrderStatus status) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a new write batch
    WriteBatch batch = firestore.batch();

    // Loop through the orderIds and update the documents in the batch
    for (String? orderId in ids) {
      DocumentReference orderRef = firestore.collection('orders').doc(orderId);
      batch.update(orderRef, {'status': status.name});
    }

    // Commit the batch
    batch.commit().then((_) {
      print('Batch update successful!');
    }).catchError((error) {
      print('Error updating documents: $error');
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersByUserId(String uid) {
    return firebase
        .collection("orders")
        .where("user_uid", isEqualTo: uid)
        .snapshots();
  }

  Future<dynamic> getOrdersByRestaurantId(String id) async {}

  Future<bool> isValidImage(String? image_url) async {
    if (image_url != null) {
      var response = await httpClient.get((Uri.parse(image_url)));

      return response.statusCode == 200;
    }
    return true;
  }
}
