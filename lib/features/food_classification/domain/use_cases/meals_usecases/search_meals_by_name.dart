import 'package:image_identification_submisison_app/features/food_classification/domain/entities/meal.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/repositories/meal_repository.dart';

class SearchMealsByName {
  final MealRepository repository;

  SearchMealsByName(this.repository);

  Future<List<Meal>> execute(String query) {
    return repository.searchMealsByName(query);
  }
}
