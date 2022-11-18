import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  Future<QuerySnapshot<Map<String, dynamic>>> searchQuery(
      {required String collection, required String query}) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .where('menu', isGreaterThanOrEqualTo: query)
        .where('menu', isLessThanOrEqualTo: '$query\uf8ff')
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

  Future<DocumentSnapshot<Map<String, dynamic>>?> readSnacksCard(
      {required String code}) async {
    try {
      var now = DateTime.now();

      var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";
      var day_id = "day-${now.day}";

      var data = await FirebaseFirestore.instance
          .collection("snacks_cards")
          .doc(month_id)
          .collection("days")
          .doc(day_id)
          .collection("recharges")
          .where("active", isEqualTo: true)
          .where("card", isEqualTo: code)
          .get();

      return data.docs.isNotEmpty ? data.docs[0] : null;
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateSnacksCard(
      {required String doc_id, required Map<String, dynamic> data}) async {
    try {
      var now = DateTime.now();

      var month_id = "${DateFormat.MMMM().format(now)}-${now.year}";
      var day_id = "day-${now.day}";

      return await FirebaseFirestore.instance
          .collection("snacks_cards")
          .doc(month_id)
          .collection("days")
          .doc(day_id)
          .collection("recharges")
          .doc(doc_id)
          .update(data);
    } catch (e) {
      print(e);
    }
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
