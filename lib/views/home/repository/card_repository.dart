import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_app/services/beerpass_service.dart';
import 'package:snacks_app/services/orders_service.dart';

class CardRepository {
  final services = BeerPassService();
  final ordersServices = OrdersApiServices();

  Future doPayment(String rfid, double value) async {
    return await services.payWithSnacksCard(rfid, value);
  }

  Future<dynamic> fetchCard(String rfid) async {
    return await services.getCard(rfid);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchCardFromFirebase(
      String rfid) async {
    return await ordersServices.fetchOrderFromCard(rfid);
  }
}
