import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_identification_submisison_app/features/food_classification/data/models/nutrition_model.dart';

abstract class GeminiRemoteDatasource {
  Future<NutritionModel?> getNutrition(String mealName);
}

class GeminiRemoteDatasourceImpl implements GeminiRemoteDatasource {
  final String apiKey;

  const GeminiRemoteDatasourceImpl({required this.apiKey});

  @override
  Future<NutritionModel?> getNutrition(String mealName) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash-lite',
        apiKey: apiKey,
      );

      final prompt = '''
Kamu adalah sistem analisis gizi makanan.
Analisislah makanan dengan nama: "$mealName".
Berikan hasil **HANYA** dalam format JSON valid seperti berikut:

{
  "nutrition": {
    "calories": <angka>,
    "carbs": <angka>,
    "protein": <angka>,
    "fat": <angka>,
    "fiber": <angka>
  }
}

Gunakan satuan gram untuk semua nilai.
Jangan tambahkan teks lain di luar JSON!
''';

      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      final text = response.text?.trim();

      if (text == null || text.isEmpty) {
        throw Exception('Gemini response is empty.');
      }

      final jsonStart = text.indexOf('{');
      final jsonEnd = text.lastIndexOf('}');
      if (jsonStart == -1 || jsonEnd == -1) {
        throw Exception('Gemini response does not contain valid JSON.');
      }

      final jsonString = text.substring(jsonStart, jsonEnd + 1);
      final jsonData = jsonDecode(jsonString);

      final nutritionJson = jsonData['nutrition'];
      if (nutritionJson == null) {
        throw Exception('Nutrition data not found in Gemini response.');
      }

      return NutritionModel.fromJson(nutritionJson);
    } catch (e) {
      throw Exception('Failed to fetch nutrition data from Gemini: $e');
    }
  }
}
