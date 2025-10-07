import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_identification_submisison_app/app/app_router.dart';
import 'package:image_identification_submisison_app/app/arguments/meal_detail_argument.dart';
import 'package:image_identification_submisison_app/core/providers/image_classification_provider.dart';
import 'package:image_identification_submisison_app/utils/feature_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      appBar: AppBar(
        title: Text('Food Classification'),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),

      body: Consumer<ImageClassificationViewmodel>(
        builder: (context, value, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    try {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(
                        source: ImageSource.gallery,
                      );

                      if (picked != null) {
                        final cropped = await ImageCropper().cropImage(
                          sourcePath: picked.path,
                          uiSettings: [
                            AndroidUiSettings(
                              toolbarTitle: 'Crop Image',
                              toolbarColor: Colors.deepOrange,
                              toolbarWidgetColor: Colors.white,
                              initAspectRatio: CropAspectRatioPreset.original,
                              lockAspectRatio: false,
                            ),
                          ],
                        );

                        if (cropped != null) {
                          value.croppedImage = cropped;

                          await value.runClassificationViaGallery(cropped.path);
                        }
                      }
                    } catch (e) {
                      debugPrint('error pick image on gallery. $e');
                    }
                  },
                  child: FeatureContainer(
                    minHeight: 350,
                    maxHeigth: 350,
                    minWidth: 350,
                    maxWidth: 350,
                    boxColor: Colors.transparent,
                    child: Center(
                      child: value.imagePath.isNotEmpty
                          ? Image.file(File(value.imagePath))
                          : Lottie.asset('assets/lottie/gallery.json'),
                    ),
                  ),
                ),

                // Lottie.asset('assets/lottie/gallery.json')
                const SizedBox.square(dimension: 12),

                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 300),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (value.classificationList.isNotEmpty) {
                        final mealName = value.classificationList.first;
                        final image = value.croppedImage;

                        Navigator.pushNamed(
                          context,
                          AppRouter.mealDetail,
                          arguments: MealResultArgument(mealName, image),
                        );

                        // print(mealAnotherMeal);
                      }
                    },
                    child: Text(
                      'Analyze',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
