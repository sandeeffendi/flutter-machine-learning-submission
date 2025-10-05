import 'package:image_identification_submisison_app/features/food_classification/domain/entities/nutrition.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/repositories/nutrition_repository.dart';

class GetNutritionUsecase {
  final NutritionRepository repository;

  const GetNutritionUsecase(this.repository);

  Future<Nutrition?> execute(String mealName) {
    return repository.getNutrition(mealName);
  }
}
