import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  final auth = FirebaseAuth.instance;
  final appStorage = AppStorage.initStorage;

  HomeCubit() : super(HomeState.initial()) {
    fetchItems();
  }

  Future<void>? setCustomerName(String name) {
    return auth.currentUser?.updateDisplayName(name);
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
    emit(state.copyWith(status: AppStatus.loading));
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
      var stream = itemsRepository.fetchItemsByRestaurant(
          restaurant, !state.listIsLastPage ? null : state.lastDocument);

      emit(state.copyWith(menu: stream));
      emit(state.copyWith(status: AppStatus.loaded));
    }
  }

  void fetchItems({int limit = 20}) async {
    var stream = itemsRepository.fetchItems(state.lastDocument, limit: limit);

    emit(state.copyWith(menu: stream));
    emit(state.copyWith(status: AppStatus.loaded));
  }

  Future<void> fetchQuery(String query) async {
    if (query.isEmpty) {
      fetchItems();
    } else {
      emit(state.copyWith(status: AppStatus.loading));
      var stream = itemsRepository.searchQuery(query, state.category);

      emit(state.copyWith(menu: stream));
      emit(state.copyWith(status: AppStatus.loaded));
    }
  }
}
