part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class CartItemAdded extends CartEvent {
  final FoodItem food;
  const CartItemAdded(this.food);
  @override
  List<Object?> get props => [food];
}

class CartItemDecremented extends CartEvent {
  final String foodId;
  const CartItemDecremented(this.foodId);
  @override
  List<Object?> get props => [foodId];
}

class CartItemDeleted extends CartEvent {
  final String foodId;
  const CartItemDeleted(this.foodId);
  @override
  List<Object?> get props => [foodId];
}

class CartCleared extends CartEvent {}
