part of 'item_screen_cubit.dart';

class ItemScreenState {
  final Order? order;
  final bool isNew;
  ItemScreenState({
    required this.order,
    required this.isNew,
  });
  factory ItemScreenState.initial() =>
      ItemScreenState(order: null, isNew: false);

  ItemScreenState copyWith({
    Order? order,
    bool? isNew,
  }) {
    return ItemScreenState(
      order: order ?? this.order,
      isNew: isNew ?? this.isNew,
    );
  }
}
