part of 'item_screen_cubit.dart';

class ItemScreenState {
  final OrderModel? order;
  final bool isNew;
  final List<String> couponsList;
  ItemScreenState({
    required this.order,
    required this.isNew,
    required this.couponsList,
  });
  factory ItemScreenState.initial() =>
      ItemScreenState(order: null, isNew: false, couponsList: []);

  ItemScreenState copyWith({
    OrderModel? order,
    bool? isNew,
    List<String>? couponsList,
  }) {
    return ItemScreenState(
      order: order ?? this.order,
      isNew: isNew ?? this.isNew,
      couponsList: couponsList ?? this.couponsList,
    );
  }
}
