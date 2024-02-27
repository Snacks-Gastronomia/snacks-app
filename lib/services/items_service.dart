import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ItemsApiServices {
  final http.Client httpClient = http.Client();

  final firebase = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> searchQuery(String query) {
    return firebase
        .collection("menu")
        .orderBy("title")
        .where("active", isEqualTo: true)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: '${query}z')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMenuByRestaurant(
      String id, document) {
    try {
      var ref = firebase
          .collection("menu")
          .where("restaurant_id", isEqualTo: id)
          .where("active", isEqualTo: true);

      return ref.snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRestaurants() {
    return firebase
        .collection("restaurants")
        .where('name', isNotEqualTo: "SNACKS")
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getItems(
      DocumentSnapshot? document,
      {int limit = 20}) {
    try {
      var ref = firebase
          .collection("menu")
          .limit(limit)
          .where("active", isEqualTo: true);
      // if (document != null) {
      //   return ref.startAfterDocument(document).snapshots();
      // }
      return ref.snapshots();
    } catch (e) {
      rethrow;
    }
  }
}
