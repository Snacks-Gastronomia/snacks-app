import 'package:cloud_firestore/cloud_firestore.dart';

class FeatureService {
  final firebase = FirebaseFirestore.instance;
  Future<QuerySnapshot<Map<String, dynamic>>> getFeatureByName(
      {required String name}) {
    // try {
    return firebase
        .collection("snacks_config")
        .doc("features")
        .collection("all")
        .where("name", isEqualTo: name)
        .get();

    // return data.docs;
  }
}
