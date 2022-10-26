import 'package:snacks_app/services/orders_service.dart';

class OrdersRepository {
  final services = OrdersApiServices();

  Future<dynamic> createOrder(Map<String, dynamic> data) async {
    await services.createOrder(data);
  }

  Future fetchOrdersByRestaurantId(String id) async {
    return await services.getOrdersByRestaurantId(id);
  }

  Future fetchOrdersByUserId(String id) async {
    return await services.getOrdersByUserId(id);
  }
}
