import 'package:image_identification_submisison_app/features/food_classification/domain/entities/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> searchMealsByName(String query);
}
