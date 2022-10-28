import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataBase {
  final database = FirebaseFirestore;

  Future<dynamic> createDocumentToCollection(
      {required String collection, required Map<String, dynamic> data}) async {
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

  Future<DocumentSnapshot<Map<String, dynamic>>?> readDocumentToCollectionById(
      {required String collection, required String id}) async {
    try {
      return await FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .get()
          .catchError((error) => print("Failed to add user: $error"));
    } catch (e) {}
  }

  Future<void> updateDocumentToCollectionById(
      {required String collection,
      required String id,
      required Map<String, Object?> data}) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .update(data)
        .catchError((error) => print("Failed to add user: $error"));
  }

  // Future<QuerySnapshot<Map<String, dynamic>>> readDocumentsToCollectionByUid(
  //     {required String collection, required String uid}) async {
  //   return await FirebaseFirestore.instance
  //       .collection(collection)
  //       .where("uid", isEqualTo: uid)
  //       .get()
  //       .catchError((error) => print("Failed to add user: $error"));
  // }
}
