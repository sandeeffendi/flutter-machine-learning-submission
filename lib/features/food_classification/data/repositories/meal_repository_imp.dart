import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_identification_submisison_app/features/food_classification/data/models/meal_model.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/entities/meal.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/repositories/meal_repository.dart';

class MealRepositoryImp implements MealRepository {
  final http.Client client;

  MealRepositoryImp(this.client);

  @override
  Future<List<Meal>> searchMealsByName(String query) async {
    try {
      final response = await client.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['meals'] == null) {
          return [];
        }

        final meals = (data['meals'] as List)
            .map((json) => MealModel.fromJson(json).toEntity())
            .toList();

        return meals;
      } else {
        throw Exception('Failed to load meal. StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
