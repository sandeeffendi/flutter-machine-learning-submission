import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/app/my_submission_app.dart';
import 'package:image_identification_submisison_app/core/providers/image_classification_provider.dart';
import 'package:image_identification_submisison_app/core/service/image_classification_service.dart';
import 'package:provider/provider.dart';

void main() {
  final service = ImageClassificationService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImageClassificationViewmodel(service),
        ),
      ],
      child: MySubmissionApp(),
    ),
  );
}
