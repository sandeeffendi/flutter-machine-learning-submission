import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/app/app_router.dart';
import 'package:image_identification_submisison_app/utils/feature_container.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Map<String, dynamic>> _features = [
    {
      "name": "Detect From Camera",
      "iconUrl": "assets/lottie/camera_scanner.json",
      "path": AppRouter.camera,
    },
    {
      "name": "Detect From Gallery",
      "iconUrl": "assets/lottie/gallery.json",
      "path": AppRouter.gallery,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 60),
        child: ListView.builder(
          itemCount: _features.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, _features[index]['path']);
                },
                child: FeatureContainer(
                  minHeight: 60,
                  maxHeigth: 250,
                  minWidth: 60,
                  maxWidth: 60,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Lottie.asset(_features[index]['iconUrl']!),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          child: Text(
                            _features[index]['name'],
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
