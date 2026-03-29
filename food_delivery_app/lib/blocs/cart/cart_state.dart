part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => subtotal > 0 ? 40.0 : 0.0;
  double get tax => subtotal * 0.05;
  double get total => subtotal + deliveryFee + tax;

  bool isInCart(String foodId) => items.any((i) => i.food.id == foodId);

  int quantityOf(String foodId) {
    try {
      return items.firstWhere((i) => i.food.id == foodId).quantity;
    } catch (_) {
      return 0;
    }
  }

  CartState copyWith({List<CartItem>? items}) =>
      CartState(items: items ?? this.items);

  @override
  List<Object?> get props => [items];
}
