import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/app/app_router.dart';
import 'package:image_identification_submisison_app/core/theme/app_textstyle.dart';
import 'package:image_identification_submisison_app/core/theme/app_theme.dart';

class MySubmissionApp extends StatelessWidget {
  const MySubmissionApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialise MaterialTheme and TextTheme
    TextTheme textTheme = createTextTheme(context, 'Montserrat', 'Poppins');
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Machine Learning Submission App',
      // Theme config
      theme: theme.light(),
      darkTheme: theme.light(),
      themeMode: ThemeMode.system,
      // Route config
      initialRoute: AppRouter.main,
      onGenerateRoute: AppRouter.generateRouter,
    );
  }
}
