import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/app/arguments/meal_detail_argument.dart';
import 'package:image_identification_submisison_app/app/main_screen.dart';
import 'package:image_identification_submisison_app/app/splash_screen.dart';
import 'package:image_identification_submisison_app/features/food_classification/presentation/pages/gallery_page.dart';
import 'package:image_identification_submisison_app/features/food_classification/presentation/pages/meal_result_page.dart';
import 'package:image_identification_submisison_app/features/food_classification/presentation/pages/camera_page.dart';

class AppRouter {
  static const String main = '/main';
  static const String splash = '/splash';
  static const String camera = '/camera';
  static const String gallery = '/gallery';
  static const String mealDetail = '/mealDetail';

  static Route<dynamic> generateRouter(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case camera:
        return MaterialPageRoute(builder: (_) => CameraPage());
      case gallery:
        return MaterialPageRoute(builder: (_) => GalleryPage());
      case mealDetail:
        final args = settings.arguments as MealResultArgument;
        return MaterialPageRoute(
          builder: (_) => MealResultPage(
            mealName: args.mealName,
            croppedFile: args.croppedFile,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: const Center(child: Text('404 page not found'))),
        );
    }
  }
}
