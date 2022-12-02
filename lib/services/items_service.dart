import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:snacks_app/models/item_model.dart';

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

  Stream<QuerySnapshot<Map<String, dynamic>>> getItems(
      DocumentSnapshot? document,
      {int limit = 8}) {
    try {
      var ref = firebase
          .collection("menu")
          .where("active", isEqualTo: true)
          .limit(limit);
      if (document != null) {
        return ref.startAfterDocument(document).snapshots();
      }
      return ref.snapshots();
    } catch (e) {
      rethrow;
    }
  }
}
