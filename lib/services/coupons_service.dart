import 'package:cloud_firestore/cloud_firestore.dart';

class CouponsService {
  final firebase = FirebaseFirestore.instance;
  late String restaurantId;

  Future<QuerySnapshot<Map<String, dynamic>>> getCoupons(restaurantId) async {
    try {
      return firebase
          .collection("coupons")
          .doc(restaurantId)
          .collection("coupons")
          .get();
    } catch (e) {
      rethrow;
    }
  }
}
