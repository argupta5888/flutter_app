import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/food_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemDecremented>(_onItemDecremented);
    on<CartItemDeleted>(_onItemDeleted);
    on<CartCleared>(_onCleared);
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((i) => i.food.id == event.food.id);
    if (index >= 0) {
      items[index] = CartItem(food: items[index].food, quantity: items[index].quantity + 1);
    } else {
      items.add(CartItem(food: event.food));
    }
    emit(state.copyWith(items: items));
  }

  void _onItemDecremented(CartItemDecremented event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((i) => i.food.id == event.foodId);
    if (index >= 0) {
      if (items[index].quantity > 1) {
        items[index] = CartItem(food: items[index].food, quantity: items[index].quantity - 1);
      } else {
        items.removeAt(index);
      }
    }
    emit(state.copyWith(items: items));
  }

  void _onItemDeleted(CartItemDeleted event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items)
      ..removeWhere((i) => i.food.id == event.foodId);
    emit(state.copyWith(items: items));
  }

  void _onCleared(CartCleared event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
