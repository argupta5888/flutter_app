part of 'food_bloc.dart';

class FoodState extends Equatable {
  final List<FoodItem> allFoods;
  final String selectedCategory;
  final String searchQuery;

  const FoodState({
    this.allFoods = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
  });

  List<FoodItem> get filteredFoods => allFoods.where((food) {
    final matchesCat = selectedCategory == 'All' || food.category == selectedCategory;
    final matchesSearch = searchQuery.isEmpty ||
        food.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        food.restaurantName.toLowerCase().contains(searchQuery.toLowerCase());
    return matchesCat && matchesSearch;
  }).toList();

  FoodState copyWith({
    List<FoodItem>? allFoods,
    String? selectedCategory,
    String? searchQuery,
  }) => FoodState(
    allFoods: allFoods ?? this.allFoods,
    selectedCategory: selectedCategory ?? this.selectedCategory,
    searchQuery: searchQuery ?? this.searchQuery,
  );

  @override
  List<Object?> get props => [allFoods, selectedCategory, searchQuery];
}
