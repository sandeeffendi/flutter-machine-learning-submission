import 'package:image_identification_submisison_app/features/food_classification/domain/entities/nutrition.dart';

abstract class NutritionRepository {
  Future<Nutrition?> getNutrition(String mealName);
}
