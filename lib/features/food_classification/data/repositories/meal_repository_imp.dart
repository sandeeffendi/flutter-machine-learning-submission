import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/entities/meal.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/use_cases/search_meals_by_name.dart';

enum SearchMealsState { initial, loading, loaded, error }

class SearchMealsByNameProvider extends ChangeNotifier {
  final SearchMealsByName searchMealsByName;

  SearchMealsByNameProvider(this.searchMealsByName);

  List<Meal> _meals = [];
  List<Meal> get meals => _meals;

  SearchMealsState _state = SearchMealsState.initial;
  SearchMealsState get state => _state;

  String? _message;
  String? get message => _message;

  Future<void> fetchMeals(String query) async {
    _state = SearchMealsState.loading;
    notifyListeners();

    try {
      _meals = await searchMealsByName.execute(query);

      if (_meals.isEmpty) {
        _message = 'No meals found for "$query"';
        _state = SearchMealsState.error;
      } else {
        _message = 'Meals Data loaded';
        _state = SearchMealsState.loaded;
      }
    } catch (e) {
      _meals = [];
      _message = 'Failed to load data: $e';
      _state = SearchMealsState.error;
    }

    notifyListeners();
  }
}
