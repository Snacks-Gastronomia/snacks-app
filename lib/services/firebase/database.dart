import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataBase {
  final database = FirebaseFirestore;

  Future<void> createDocumentToCollection(
      {required String collection, required Map<String, String> data}) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .add(data)
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> readDocumentToCollectionByUid(
      {required String collection, required String uid}) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .where("uid", isEqualTo: uid)
        .limit(1)
        .get()
        .catchError((error) => print("Failed to add user: $error"));
  }
}
