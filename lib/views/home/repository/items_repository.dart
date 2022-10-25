import 'package:snacks_app/models/item_model.dart';
import 'package:snacks_app/services/items_service.dart';

class ItemsRepository {
  final ItemsApiServices services;
  ItemsRepository({
    required this.services,
  });

  Future<void> postItem(Item item) async {
    try {
      await services.postItem(item);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Item>?> fetchItems(String? category) async {
    try {
      final List<Item> items = await services.getItems(category);

      return items;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Item> fecthSingleItem(String id) async {
    try {
      return await services.getSingleItem(id);

      // return item;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Item>?> searchItems(String query, String? category) async {
    try {
      final List<Item> items = await services.queryItems(query, category);

      return items;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Item>?> fetchPopularItems() async {
    try {
      final List<Item> items = await services.getPopularItems();

      return items;
    } catch (e) {
      throw e.toString();
    }
  }
}
