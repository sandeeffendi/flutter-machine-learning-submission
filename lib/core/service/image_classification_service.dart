import 'dart:developer';
import 'dart:isolate';

import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'isolate_inference.dart';

// todo-02-service-01: create a ImageClassificationService class
class ImageClassificationService {
  // todo-02-service-02: setup the static
  final modelPath = 'assets/models/aiy_classifier_food_v1.tflite';
  final labelsPath = 'assets/models/probability-labels-en.txt';

  // todo-02-service-03: setup the variable
  late final Interpreter interpreter;
  late final List<String> labels;
  late Tensor inputTensor;
  late Tensor outputTensor;
  late final IsolateInference isolateInference;

  // todo-02-service-04: load model
  Future<void> _loadModel() async {
    final options = InterpreterOptions()
      ..useNnApiForAndroid = true
      ..useMetalDelegateForIOS = true;

    // Load model from assets
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    // Get tensor input shape [1, 224, 224, 3]
    inputTensor = interpreter.getInputTensors().first;
    // Get tensor output shape [1, 1001]
    outputTensor = interpreter.getOutputTensors().first;

    log('Interpreter loaded successfully');
  }

  // todo-02-service-05: load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  // todo-02-service-06: run init function
  Future<void> initHelper() async {
    await _loadLabels();
    await _loadModel();
    // todo-03-isolate-10: define a Isolate inference
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  // inference models
  Future<Map<String, double>> _inference(InferenceModel inferenceModel) async {
    ReceivePort responsePort = ReceivePort();

    isolateInference.sendPort.send(
      inferenceModel..responsePort = responsePort.sendPort,
    );

    var result = await responsePort.first;
    return result;
  }

  // inference camera frame
  Future<Map<String, double>> inferenceCameraFrame(
    CameraImage cameraImage,
  ) async {
    var isolateModel = InferenceModel(
      cameraImage: cameraImage,
      interpreter.address,
      labels,
      inputTensor.shape,
      outputTensor.shape,
    );

    return _inference(isolateModel);
  }

  // inferece gallery frame
  Future<Map<String, double>> inferenceGalleryFrame(img.Image image) {
    var isolateModel = InferenceModel(
      image: image,
      interpreter.address,
      labels,
      inputTensor.shape,
      outputTensor.shape,
    );

    return _inference(isolateModel);
  }

  // close the process from the service
  Future<void> close() async {
    await isolateInference.close();
  }
}
