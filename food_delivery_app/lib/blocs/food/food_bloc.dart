import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/food_model.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(const FoodState()) {
    on<FoodInitialized>(_onInitialized);
    on<FoodCategorySelected>(_onCategorySelected);
    on<FoodSearched>(_onSearched);
  }

  void _onInitialized(FoodInitialized event, Emitter<FoodState> emit) {
    emit(state.copyWith(allFoods: FoodData.getSampleFoods()));
  }

  void _onCategorySelected(FoodCategorySelected event, Emitter<FoodState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onSearched(FoodSearched event, Emitter<FoodState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
