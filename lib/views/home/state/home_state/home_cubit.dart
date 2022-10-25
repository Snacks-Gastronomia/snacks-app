import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:snacks_app/models/item_model.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/views/home/repository/items_repository.dart';
import 'package:snacks_app/services/items_service.dart';

part "home_state.dart";

class HomeCubit extends Cubit<HomeState> {
  final ItemsRepository itemsRepository =
      ItemsRepository(services: ItemsApiServices());

  HomeCubit() : super(HomeState.initial()) {
    fetchItems();
  }

  Future<void> fetchMoreItems() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      final List<Item>? data = await itemsRepository.fetchItems(state.category);
      final items = [...state.items, ...data!.toList()];

      var last_page = data.length < state.numberOfPostsPerRequest;
      emit(state.copyWith(
          status: AppStatus.loaded,
          items: items,
          listIsLastPage: last_page,
          listPageNumber: state.listPageNumber + 1));
    } catch (e) {
      debugPrint("error");
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> fetchItems() async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      final List<Item>? items =
          await itemsRepository.fetchItems(state.category);

      final List<Item>? popular = await itemsRepository.fetchPopularItems();
      var last_page = items!.length < state.numberOfPostsPerRequest;
      emit(state.copyWith(
          status: AppStatus.loaded,
          items: items,
          popular: popular,
          listIsLastPage: last_page,
          listPageNumber: state.listPageNumber + 1));

      print('state: $state');
    } catch (e) {
      emit(state.copyWith(
        status: AppStatus.error,
        error: e.toString(),
      ));
      print('state: $state');
    }
  }

  Future<void> fetchQuery(String query) async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      final List<Item>? items =
          await itemsRepository.searchItems(query, state.category);

      emit(
          state.copyWith(search: true, status: AppStatus.loaded, items: items));

      print('state: $state');
    } catch (e) {
      emit(state.copyWith(
        status: AppStatus.error,
        error: e.toString(),
      ));
      print('state: $state');
    }
  }

  void updateCategory(String category) {
    emit(state.copyWith(category: category));
    fetchItems();
  }
}
