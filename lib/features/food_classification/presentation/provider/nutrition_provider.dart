import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/entities/nutrition.dart';
import 'package:image_identification_submisison_app/features/food_classification/domain/use_cases/nutrition_usecases/get_nutrition_usecase.dart';

enum NutritionState { initial, loading, loaded, error }

class NutritionProvider extends ChangeNotifier {
  final GetNutritionUsecase getNutritionUsecase;

  NutritionProvider(this.getNutritionUsecase);

  Nutrition? _nutrition;
  Nutrition? get nutrition => _nutrition;

  NutritionState _state = NutritionState.initial;
  NutritionState get state => _state;

  String? _message;
  String? get message => _message;

  Future<void> getNutrition(String mealName) async {
    _state = NutritionState.loading;
    notifyListeners();

    try {
      _nutrition = await getNutritionUsecase.execute(mealName);

      if (_nutrition != null) {
        _state = NutritionState.loaded;
        _message = 'Nutrition data loaded.';
      } else {
        _nutrition = null;
        _message = 'Cannot analze nutrition for $mealName';
        _state = NutritionState.error;
      }
    } catch (e) {
      _nutrition = null;
      _state = NutritionState.error;
      _message = 'Failed to load nutrition data: $e';
    }

    notifyListeners();
  }
}
