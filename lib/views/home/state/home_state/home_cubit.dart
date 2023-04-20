import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:snacks_app/models/item_model.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/storage.dart';
import 'package:snacks_app/views/home/repository/items_repository.dart';
import 'package:snacks_app/services/items_service.dart';

part "home_state.dart";

class HomeCubit extends Cubit<HomeState> {
  final ItemsRepository itemsRepository =
      ItemsRepository(services: ItemsApiServices());
  final storage = AppStorage();
  final appStorage = AppStorage.initStorage;

  HomeCubit() : super(HomeState.initial()) {
    fetchItems();
  }

  void changeButtonDone(bool value) {
    emit(state.copyWith(showButton: value));
  }

  Future<String?> getAddress() async {
    final dataStorage = await storage.getDataStorage("address");
    return dataStorage.toString();
  }

  Future<String?> readStorage(String item) async {
    var storage = await appStorage.readAll();

    return storage[item];
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchRestaurants() async {
    return await itemsRepository.fetchRestaurants();
  }

  void fetchItemsByRestaurants(String restaurant, bool onSelected) {
    if (restaurant.isEmpty) {
      emit(state.copyWith(
        category: null,
        lastDocument: null,
      ));
      fetchItems();
    } else if (!state.listIsLastPage) {
      if (onSelected) {
        emit(state.copyWith(
          lastDocument: null,
        ));
      }
      var _stream = itemsRepository
          .fetchItemsByRestaurant(
              restaurant, !state.listIsLastPage ? null : state.lastDocument)
          .distinct();

      emit(state.copyWith(menu: _stream));
    }
  }

  void fetchItems() {
    var _stream = itemsRepository.fetchItems(state.lastDocument).distinct();

    emit(state.copyWith(menu: _stream));
  }

  Future<void> fetchQuery(String query) async {
    var _stream = itemsRepository.searchQuery(query, state.category);

    emit(state.copyWith(menu: _stream));
  }
}
