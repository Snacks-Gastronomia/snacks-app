part of "home_cubit.dart";

class HomeState {
  final List<Item> items;
  final int numberOfPostsPerRequest;
  final bool listIsLastPage;
  final int listPageNumber;
  final List<Item> popular;
  final AppStatus status;
  final bool search;
  final String? category;
  final String? error;
  HomeState({
    required this.items,
    required this.numberOfPostsPerRequest,
    required this.listIsLastPage,
    required this.listPageNumber,
    required this.popular,
    required this.status,
    required this.search,
    required this.category,
    required this.error,
  });

  factory HomeState.initial() => HomeState(
      search: false,
      category: null,
      items: [],
      popular: [],
      status: AppStatus.initial,
      listIsLastPage: false,
      listPageNumber: 1,
      numberOfPostsPerRequest: 15,
      error: null);

  @override
  String toString() => 'HomeState(items: $items, popular: $popular)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeState &&
        listEquals(other.items, items) &&
        listEquals(other.popular, popular);
  }

  @override
  int get hashCode => items.hashCode ^ popular.hashCode;

  HomeState copyWith({
    List<Item>? items,
    int? numberOfPostsPerRequest,
    bool? listIsLastPage,
    int? listPageNumber,
    List<Item>? popular,
    AppStatus? status,
    bool? search,
    String? category,
    String? error,
  }) {
    return HomeState(
      items: items ?? this.items,
      numberOfPostsPerRequest:
          numberOfPostsPerRequest ?? this.numberOfPostsPerRequest,
      listIsLastPage: listIsLastPage ?? this.listIsLastPage,
      listPageNumber: listPageNumber ?? this.listPageNumber,
      popular: popular ?? this.popular,
      status: status ?? this.status,
      search: search ?? this.search,
      category: category ?? this.category,
      error: error ?? this.error,
    );
  }
}
