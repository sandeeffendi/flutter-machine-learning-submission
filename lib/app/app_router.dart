import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/app/arguments/food_detail_argument.dart';
import 'package:image_identification_submisison_app/app/main_screen.dart';
import 'package:image_identification_submisison_app/app/splash_screen.dart';
import 'package:image_identification_submisison_app/features/food_classification/pages/camera_page.dart';
import 'package:image_identification_submisison_app/features/food_classification/pages/food_detail_page.dart';
import 'package:image_identification_submisison_app/features/food_classification/pages/gallery_page.dart';

class AppRouter {
  static const String main = '/main';
  static const String splash = '/splash';
  static const String camera = '/camera';
  static const String gallery = '/gallery';
  static const String foodDetail = '/foodDetail';

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
      case foodDetail:
        final args = settings.arguments as FoodDetailArgument;
        return MaterialPageRoute(
          builder: (_) => FoodDetailPage(foodName: args.foodName),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: const Center(child: Text('404 page not found'))),
        );
    }
  }
}
