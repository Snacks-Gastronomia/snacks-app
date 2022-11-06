import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataBase {
  final database = FirebaseFirestore.instance;

  Future<String> createDocumentToCollection(
      {required String collection, required Map<String, dynamic> data}) async {
    var res = await database
        .collection(collection)
        .add(data)
        .catchError((error) => print("Failed to add user: $error"));

    return res.id;
  }

  Future<void> addOrderDocumentToCollection(
      {required String collection,
      required String docID,
      required String subcolletion,
      required List<Map<String, dynamic>> data}) async {
    var batch = database.batch();
    for (var element in data) {
      var docRef = database
          .collection(collection)
          .doc(docID)
          .collection(subcolletion)
          .doc(); //automatically generate unique id
      batch.set(docRef, element);
    } // await FirebaseFirestore.instance
    batch.commit();
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
