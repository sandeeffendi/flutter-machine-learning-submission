import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/app/my_submission_app.dart';
import 'package:image_identification_submisison_app/core/providers/image_classification_provider.dart';
import 'package:image_identification_submisison_app/core/service/image_classification_service.dart';
import 'package:image_identification_submisison_app/env/env.dart';
import 'package:image_identification_submisison_app/features/food_classification/data/datasource/gemini_remote_datasource.dart';
import 'package:image_identification_submisison_app/features/food_classification/data/repositories/meal_repository_imp.dart';
import 'package:image_identification_submisison_app/features/food_classification/data/repositories/nutrition_repository_imp.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/use_cases/meals_usecases/search_meals_by_name.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/use_cases/nutrition_usecases/get_nutrition_usecase.dart';
import 'package:image_identification_submisison_app/features/food_classification/presentation/provider/nutrition_provider.dart';
import 'package:image_identification_submisison_app/features/food_classification/presentation/provider/search_meals_by_name_provider.dart';
import 'package:provider/provider.dart';

void main() {
  // Tensor Flow Image Classification DI
  final service = ImageClassificationService();

  // TheMealDb DI
  final client = http.Client();
  final mealRepository = MealRepositoryImp(client);
  final searchMealByName = SearchMealsByName(mealRepository);

  // Gemini Remote Datasource DI
  final geminiDataSource = GeminiRemoteDatasourceImpl(apiKey: Env.geminiApiKey);
  final nutritionRepository = NutritionRepositoryImp(geminiDataSource);
  final getNutritionUsecase = GetNutritionUsecase(nutritionRepository);

  runApp(
    MultiProvider(
      providers: [
        // Nutrition Provider
        ChangeNotifierProvider(
          create: (_) => NutritionProvider(getNutritionUsecase),
        ),

        // Image Classification Provider
        ChangeNotifierProvider(
          create: (_) => ImageClassificationViewmodel(service),
        ),

        // The Meal Db Search Meal By Name Provider
        ChangeNotifierProvider(
          create: (_) => SearchMealsByNameProvider(searchMealByName),
        ),
      ],
      child: MySubmissionApp(),
    ),
  );
}
