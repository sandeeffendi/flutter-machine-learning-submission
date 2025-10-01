import 'dart:io';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/widgets.dart';
import 'package:image_identification_submisison_app/core/service/image_classification_service.dart';

// create a viewmodel notifier
class ImageClassificationViewmodel extends ChangeNotifier {
  // create a constructor
  final ImageClassificationService _service;

  ImageClassificationViewmodel(this._service) {
    _service.initHelper();
  }

  // create a state and getter to get a top three on classification item
  Map<String, num> _classifications = {};

  Map<String, num> get classifications => Map.fromEntries(
    (_classifications.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value)))
        .reversed
        .take(3),
  );

  List<(String, String)> get classificationList => classifications.entries
      .map((e) => (e.key, e.value.toStringAsFixed(2)))
      .toList();

  String _imagePath = '';
  String get imagePath => _imagePath;

  // Run classificatin via camera
  Future<void> runClassificationViaCamera(CameraImage camera) async {
    _classifications = await _service.inferenceCameraFrame(camera);
    notifyListeners();
  }

  // Run classification via gallery
  Future<void> runClassificationViaGallery(String imagePath) async {
    _imagePath = imagePath;
    final imageData = File(_imagePath).readAsBytesSync();
    final image = img.decodeImage(imageData);

    if (image != null) {
      _classifications = await _service.inferenceGalleryFrame(image);

      notifyListeners();
    }
  }

  // close everything
  Future<void> close() async {
    await _service.close();
  }
}
