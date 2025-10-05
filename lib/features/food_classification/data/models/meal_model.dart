import '../../domain/entities/meal.dart';

class MealModel {
  final String idMeal;
  final String strMeal;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final List<String> ingredients;
  final List<String> measures;

  MealModel({
    required this.idMeal,
    required this.strMeal,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    required this.ingredients,
    required this.measures,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    final List<String> ingredients = [];
    final List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'];
      final mea = json['strMeasure$i'];
      if (ing != null && ing.toString().isNotEmpty) {
        ingredients.add(ing);
        measures.add(mea ?? "");
      }
    }

    return MealModel(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strCategory: json['strCategory'] ?? "",
      strArea: json['strArea'] ?? "",
      strInstructions: json['strInstructions'] ?? "",
      strMealThumb: json['strMealThumb'] ?? "",
      ingredients: ingredients,
      measures: measures,
    );
  }

  Meal toEntity() {
    return Meal(
      id: idMeal,
      name: strMeal,
      category: strCategory,
      area: strArea,
      instructions: strInstructions,
      thumbnail: strMealThumb,
      ingredients: ingredients,
      measures: measures,
    );
  }
}
