import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/app/main_screen.dart';
import 'package:image_identification_submisison_app/app/splash_screen.dart';

class AppRouter {
  static const String main = '/main';
  static const String splash = '/splash';

  static Route<dynamic> generateRouter(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: const Center(child: Text('404 page not found'))),
        );
    }
  }
}
