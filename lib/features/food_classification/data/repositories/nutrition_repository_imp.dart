import 'package:image_identification_submisison_app/features/food_classification/data/datasource/gemini_remote_datasource.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/entities/nutrition.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/repositories/nutrition_repository.dart';

class NutritionRepositoryImp implements NutritionRepository {
  final GeminiRemoteDatasource remoteDatasource;

  NutritionRepositoryImp(this.remoteDatasource);

  @override
  Future<Nutrition?> getNutrition(String mealName) async {
    return await remoteDatasource.getNutrition(mealName);
  }
}
