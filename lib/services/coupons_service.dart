import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_app/models/coupom_model.dart';

class CouponsService {
  final firebase = FirebaseFirestore.instance;
  late String restaurantId;

  Future<List<CoupomModel>> getCoupons(restaurantId) async {
    try {
      final data = await firebase
          .collection("coupons")
          .doc(restaurantId)
          .collection("coupons")
          .get();
      final couponsList = CoupomModel.fromData(data.docs);
      return couponsList;
    } catch (e) {
      rethrow;
    }
  }
}
