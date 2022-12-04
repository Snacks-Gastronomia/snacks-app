import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_app/models/item_model.dart';
import 'package:snacks_app/services/items_service.dart';

class ItemsRepository {
  final ItemsApiServices services;
  ItemsRepository({
    required this.services,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchItems(last) {
    try {
      return services.getItems(last);
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchItemsByRestaurant(
      String id, last) {
    try {
      return services.getMenuByRestaurant(id, last);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchRestaurants() {
    try {
      return services.getRestaurants();
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> searchQuery(
      String query, String? category) {
    try {
      return services.searchQuery(query);

      // return items;
    } catch (e) {
      throw e.toString();
    }
  }
}
