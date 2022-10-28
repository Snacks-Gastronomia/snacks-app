import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_app/services/orders_service.dart';

class OrdersRepository {
  final services = OrdersApiServices();

  Future<dynamic> createOrder(Map<String, dynamic> data) async {
    await services.createOrder(data);
  }

  Future fetchOrdersByRestaurantId(String id) async {
    return await services.getOrdersByRestaurantId(id);
  }

  Stream<QuerySnapshot> fetchOrdersByUserId(String id) {
    return services.getOrdersByUserId(id);
  }
}
