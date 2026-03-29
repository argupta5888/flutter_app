part of 'food_bloc.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();
  @override
  List<Object?> get props => [];
}

class FoodInitialized extends FoodEvent {}

class FoodCategorySelected extends FoodEvent {
  final String category;
  const FoodCategorySelected(this.category);
  @override
  List<Object?> get props => [category];
}

class FoodSearched extends FoodEvent {
  final String query;
  const FoodSearched(this.query);
  @override
  List<Object?> get props => [query];
}
