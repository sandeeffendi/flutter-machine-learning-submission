import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/app/app_router.dart';
import 'package:image_identification_submisison_app/app/arguments/food_detail_argument.dart';
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
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                    );

                    if (picked != null) {
                      await value.runClassificationViaGallery(picked.path);
                      print(value.imagePath);
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
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, maxWidth: 300),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (value.classificationList.isNotEmpty) {
                        final foodName = value.classificationList.first.$1;

                        Navigator.pushNamed(
                          context,
                          AppRouter.foodDetail,
                          arguments: FoodDetailArgument(foodName),
                        );
                      // }
                      // if (value.classificationList.isNotEmpty) {
                      //   final foodName = value.classificationList.first.$1;

                      //   Navigator.pushNamed(
                      //     context,
                      //     AppRouter.foodDetail,
                      //     arguments: FoodDetailArgument(foodName),
                      //   );
                      // } else {}

                      // final foodName = value.classificationList.first.$1;
                      // Navigator.pushNamed(context, AppRouter.foodDetail);

                      // if (value.imagePath.isNotEmpty) {
                      //   await value.runClassificationViaGallery(
                      //     value.imagePath,
                      //   );
                      //   print(value.classificationList);
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
