import 'package:image_identification_submisison_app/features/food_classification/domain/entities/nutrition.dart';

class NutritionModel extends Nutrition {
  NutritionModel({
    required super.calories,
    required super.carbs,
    required super.protein,
    required super.fat,
    required super.fiber,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      calories: json['calories'],
      carbs: json['carbs'],
      protein: json['protein'],
      fat: json['fat'],
      fiber: json['fiber'],
    );
  }
}
