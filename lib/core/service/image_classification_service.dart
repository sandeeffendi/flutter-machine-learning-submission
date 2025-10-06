// import 'dart:developer';
// import 'dart:io';
// import 'dart:isolate';

// import 'package:image/image.dart' as img;
// import 'package:camera/camera.dart';
// import 'package:flutter/services.dart';
// import 'package:image_identification_submisison_app/core/service/firebase_ml_service.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

// import 'isolate_inference.dart';

// // todo-02-service-01: create a ImageClassificationService class
// class ImageClassificationService {
//   final FirebaseMlService _firebaseMlService;

//   ImageClassificationService(this._firebaseMlService);

//   late final File modelFile;

//   // todo-02-service-03: setup the variable
//   late final Interpreter interpreter;
//   late final List<String> labels;
//   late Tensor inputTensor;
//   late Tensor outputTensor;
//   late final IsolateInference isolateInference;

//   // todo-02-service-04: load model
//   Future<void> _loadModel() async {
//     modelFile = await _firebaseMlService.loadModel();

//     final options = InterpreterOptions()
//       ..useNnApiForAndroid = true
//       ..useMetalDelegateForIOS = true;

//     // Load model from assets
//     interpreter = Interpreter.fromFile(modelFile, options: options);
//     // Get tensor input shape [1, 224, 224, 3]
//     inputTensor = interpreter.getInputTensors().first;
//     // Get tensor output shape [1, 1001]
//     outputTensor = interpreter.getOutputTensors().first;

//     log('Interpreter loaded successfully');
//   }

//   // todo-02-service-05: load labels from assets
//   Future<void> _loadLabels() async {
//     final labelTxt = await rootBundle.loadString(labelsPath);
//     labels = labelTxt.split('\n');
//   }

//   // todo-02-service-06: run init function
//   Future<void> initHelper() async {
//     await _loadLabels();
//     await _loadModel();
//     // todo-03-isolate-10: define a Isolate inference
//     isolateInference = IsolateInference();
//     await isolateInference.start();
//   }

//   // inference models
//   Future<Map<String, double>> _inference(InferenceModel inferenceModel) async {
//     ReceivePort responsePort = ReceivePort();

//     isolateInference.sendPort.send(
//       inferenceModel..responsePort = responsePort.sendPort,
//     );

//     var result = await responsePort.first;
//     return result;
//   }

//   // inference camera frame
//   Future<Map<String, double>> inferenceCameraFrame(
//     CameraImage cameraImage,
//   ) async {
//     var isolateModel = InferenceModel(
//       cameraImage: cameraImage,
//       interpreter.address,
//       labels,
//       inputTensor.shape,
//       outputTensor.shape,
//     );

//     return _inference(isolateModel);
//   }

//   // inferece gallery frame
//   Future<Map<String, double>> inferenceGalleryFrame(img.Image image) {
//     var isolateModel = InferenceModel(
//       image: image,
//       interpreter.address,
//       labels,
//       inputTensor.shape,
//       outputTensor.shape,
//     );

//     return _inference(isolateModel);
//   }

//   // close the process from the service
//   Future<void> close() async {
//     await isolateInference.close();
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_identification_submisison_app/core/service/firebase_ml_service.dart';
import 'isolate_inference.dart';

/// Service for image classification using TensorFlow Lite model
/// Downloaded dynamically from Firebase via [FirebaseMlService].
class ImageClassificationService {
  final FirebaseMlService _firebaseMlService;

  ImageClassificationService(this._firebaseMlService);

  late final File modelFile;
  late final Interpreter interpreter;
  late final List<String> labels;
  late Tensor inputTensor;
  late Tensor outputTensor;
  late final IsolateInference isolateInference;

  /// Default path for labels if not downloaded from Firebase
  final String labelsPath = 'assets/models/probability-labels-en.txt';

  /// Initialize and prepare everything
  Future<void> initHelper() async {
    try {
      await _loadLabels();
      await _loadModel();

      isolateInference = IsolateInference();
      await isolateInference.start();

      log('ImageClassificationService initialized successfully');
    } catch (e, s) {
      log('Failed to initialize ImageClassificationService: $e');
      log('$s');
      rethrow;
    }
  }

  /// Load TFLite model file from Firebase
  Future<void> _loadModel() async {
    modelFile = await _firebaseMlService.loadModel();

    final options = InterpreterOptions();

    // Add appropriate delegate for platform
    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    } else if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    interpreter = Interpreter.fromFile(modelFile, options: options);
    inputTensor = interpreter.getInputTensors().first;
    outputTensor = interpreter.getOutputTensors().first;

    log('Model loaded successfully: ${modelFile.path}');
  }

  /// Load label list from local asset
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n').where((e) => e.isNotEmpty).toList();
    log('Labels loaded: ${labels.length} found');
  }

  /// Run inference from an isolate
  Future<Map<String, double>> _inference(InferenceModel inferenceModel) async {
    final responsePort = ReceivePort();
    inferenceModel.responsePort = responsePort.sendPort;
    isolateInference.sendPort.send(inferenceModel);

    final result = await responsePort.first;
    return Map<String, double>.from(result);
  }

  /// Inference from a camera frame
  Future<Map<String, double>> inferenceCameraFrame(
    CameraImage cameraImage,
  ) async {
    final isolateModel = InferenceModel(
      cameraImage: cameraImage,
      interpreter.address,
      labels,
      inputTensor.shape,
      outputTensor.shape,
    );
    return _inference(isolateModel);
  }

  /// Inference from a gallery image
  Future<Map<String, double>> inferenceGalleryFrame(img.Image image) async {
    final isolateModel = InferenceModel(
      image: image,
      interpreter.address,
      labels,
      inputTensor.shape,
      outputTensor.shape,
    );
    return _inference(isolateModel);
  }

  /// Dispose resources safely
  Future<void> close() async {
    await isolateInference.close();
    interpreter.close();
    log('ImageClassificationService closed');
  }
}
