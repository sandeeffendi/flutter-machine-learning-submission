import 'dart:io';
import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../utils/image_utils.dart';

// todo-03-isolate-02: create a class isolate
class IsolateInference {
  // todo-03-isolate-03: setup a state
  static const String _debugName = "TFLITE_INFERENCE";
  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;
  late SendPort _sendPort;
  SendPort get sendPort => _sendPort;

  // todo-03-isolate-04: open the new thread and create a static function
  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: _debugName,
    );
    _sendPort = await _receivePort.first;
  }

  // static void entryPoint(SendPort sendPort) async {
  //   final port = ReceivePort();
  //   sendPort.send(port.sendPort);

  //   await for (final InferenceModel isolateModel in port) {
  //     // todo-03-isolate-05: create a _imagePreProcessing function and run image pre-processing
  //     final cameraImage = isolateModel.cameraImage!;
  //     final inputShape = isolateModel.inputShape;
  //     final imageMatrix = _imagePreProcessing(cameraImage, inputShape);

  //     // todo-03-isolate-06: run inference
  //     final input = [imageMatrix];
  //     final output = [List<int>.filled(isolateModel.outputShape[1], 0)];
  //     final address = isolateModel.interpreterAddress;

  //     final result = _runInference(input, output, address);

  //     // todo-03-isolate-07: result preperation
  //     int maxScore = result.reduce((a, b) => a + b);
  //     final keys = isolateModel.labels;
  //     final values = result
  //         .map((e) => e.toDouble() / maxScore.toDouble())
  //         .toList();

  //     var classification = Map.fromIterables(keys, values);
  //     classification.removeWhere((key, value) => value == 0);

  //     // todo-03-isolate-08: send the result to main thread
  //     isolateModel.responsePort.send(classification);
  //   }

  // }

  static List<List<List<num>>> _imagePreProcessingFromGallery(
    image_lib.Image galleryImage,
    List<int> inputShape,
  ) {
    // Resize ke ukuran model
    final imageInput = image_lib.copyResize(
      galleryImage,
      width: inputShape[1],
      height: inputShape[2],
    );

    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(imageInput.width, (x) {
        final pixel = imageInput.getPixel(x, y);
        return [pixel.r, pixel.g, pixel.b];
      }),
    );
    return imageMatrix;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final InferenceModel isolateModel in port) {
      final inputShape = isolateModel.inputShape;
      List<List<List<num>>> imageMatrix;

      if (isolateModel.cameraImage != null) {
        // Preprocess kamera
        imageMatrix = _imagePreProcessing(
          isolateModel.cameraImage!,
          inputShape,
        );
      } else if (isolateModel.image != null) {
        // Preprocess gallery
        imageMatrix = _imagePreProcessingFromGallery(
          isolateModel.image!,
          inputShape,
        );
      } else {
        throw Exception(
          "InferenceModel tidak punya input data (cameraImage/image)",
        );
      }

      // Jalankan inference
      final input = [imageMatrix];
      final output = [List<int>.filled(isolateModel.outputShape[1], 0)];
      final result = _runInference(
        input,
        output,
        isolateModel.interpreterAddress,
      );

      // Normalisasi hasil
      int maxScore = result.reduce((a, b) => a + b);
      final keys = isolateModel.labels;
      final values = result
          .map((e) => e.toDouble() / maxScore.toDouble())
          .toList();

      var classification = Map.fromIterables(keys, values);
      classification.removeWhere((key, value) => value == 0);

      isolateModel.responsePort.send(classification);
    }
  }

  // todo-03-isolate-09: close every thread that might be open
  Future<void> close() async {
    _isolate.kill();
    _receivePort.close();
  }

  static List<List<List<num>>> _imagePreProcessing(
    CameraImage cameraImage,
    List<int> inputShape,
  ) {
    image_lib.Image? img;
    img = ImageUtils.convertCameraImage(cameraImage);

    // resize original image to match model shape.
    image_lib.Image imageInput = image_lib.copyResize(
      img!,
      width: inputShape[1],
      height: inputShape[2],
    );

    if (Platform.isAndroid) {
      imageInput = image_lib.copyRotate(imageInput, angle: 90);
    }

    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(imageInput.width, (x) {
        final pixel = imageInput.getPixel(x, y);
        return [pixel.r, pixel.g, pixel.b];
      }),
    );
    return imageMatrix;
  }

  static List<int> _runInference(
    List<List<List<List<num>>>> input,
    List<List<int>> output,
    int interpreterAddress,
  ) {
    Interpreter interpreter = Interpreter.fromAddress(interpreterAddress);
    interpreter.run(input, output);
    // Get first output tensor
    final result = output.first;
    return result;
  }
}

// todo-03-isolate-01: create a model class
class InferenceModel {
  CameraImage? cameraImage;
  image_lib.Image? image;
  int interpreterAddress;
  List<String> labels;
  List<int> inputShape;
  List<int> outputShape;
  late SendPort responsePort;

  InferenceModel(
    this.interpreterAddress,
    this.labels,
    this.inputShape,
    this.outputShape, {
    this.cameraImage,
    this.image,
  });
}
