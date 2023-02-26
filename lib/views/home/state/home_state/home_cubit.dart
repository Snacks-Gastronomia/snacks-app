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

  Future<void> fetchMoreItems() async {
    // try {
    //   emit(state.copyWith(status: AppStatus.loading));
    //   final List<Item>? data = await itemsRepository.fetchItems(state.category);
    //   final items = [...state.items, ...data!.toList()];

    //   var last_page = data.length < state.numberOfPostsPerRequest;
    //   emit(state.copyWith(
    //       status: AppStatus.loaded,
    //       items: items,
    //       listIsLastPage: last_page,
    //       listPageNumber: state.listPageNumber + 1));
    // } catch (e) {
    //   debugPrint("error");
    //   emit(state.copyWith(status: AppStatus.error));
    // }
  }

  Future<String?> readStorage(String item) async {
    var storage = await appStorage.readAll();

    return storage[item];
  }

  void fetchItems() async {
    print("has category");
    print(state.category);
    if (!state.listIsLastPage) {
      emit(state.copyWith(status: AppStatus.loading));
      var last = state.menu.isEmpty ? null : state.lastDocument;
      itemsRepository.fetchItems(last).distinct().listen((event) {
        if (event.docs.isNotEmpty) {
          var data = event.docs.map<Map<String, dynamic>>((e) {
            var el = e.data();
            el.addAll({"id": e.id});
            return el;
          }).toList();
          // print(data);
          emit(state.copyWith(
              lastDocument: event.docs.last, menu: [...state.menu, ...data]));
        } else {
          emit(state.copyWith(listIsLastPage: true));
        }
      });
      emit(state.copyWith(status: AppStatus.loaded));
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchRestaurants() async {
    return await itemsRepository.fetchRestaurants();
  }

  void fetchItemsByRestaurants(String restaurant, bool onSelect) {
    print(restaurant);
    if (!state.listIsLastPage) {
      if (state.category == restaurant) {
        emit(state.copyWith(
          category: null,
          status: AppStatus.loading,
          menu: [],
        ));
        fetchItems();
      } else {
        if (onSelect) {
          emit(state.copyWith(
            status: AppStatus.loading,
            menu: [],
            lastDocument: null,
          ));
        }
        itemsRepository
            .fetchItemsByRestaurant(
                restaurant, !state.listIsLastPage ? null : state.lastDocument)
            .distinct()
            .listen((event) {
          if (event.docs.isNotEmpty || onSelect) {
            var data = event.docs.map<Map<String, dynamic>>((e) {
              var el = e.data();
              el.addAll({"id": e.id});
              return el;
            }).toList();
            emit(state.copyWith(
                lastDocument: event.docs.isNotEmpty ? event.docs.last : null,
                menu: data,
                category: restaurant,
                listIsLastPage: false));
          } else {
            emit(state.copyWith(listIsLastPage: true));
          }
        });
        emit(state.copyWith(status: AppStatus.loaded));
        // print(state.status);
      }
    }
  }

  Future<void> fetchQuery(String query) async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      itemsRepository.searchQuery(query, state.category).listen((event) {
        if (event.docs.isNotEmpty) {
          emit(state.copyWith(
              menu: event.docs.map<Map<String, dynamic>>((e) {
            var el = e.data();
            el.addAll({"id": e.id});
            return el;
          }).toList()));
        }
        emit(state.copyWith(
          status: AppStatus.loaded,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        status: AppStatus.error,
        error: e.toString(),
      ));
      print('state: $e');
    }
  }
}
