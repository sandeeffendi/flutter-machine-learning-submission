import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_identification_submisison_app/app/app_router.dart';
import 'package:image_identification_submisison_app/app/arguments/meal_detail_argument.dart';
import 'package:image_identification_submisison_app/core/providers/camera_inference_provider.dart';
import 'package:image_identification_submisison_app/widgets/camera_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraImage? _lastFrame;

  /// Ambil frame terakhir dari stream kamera
  Future<CameraImage?> _captureFrame() async {
    return _lastFrame;
  }

  Future<File> _convertCameraImageToFile(CameraImage image) async {
    final width = image.width;
    final height = image.height;

    // Konversi YUV → RGB (sederhana)
    final img.Image rgbImage = img.Image(width: width, height: height);
    final yPlane = image.planes[0].bytes;
    final bytesPerRow = image.planes[0].bytesPerRow;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = yPlane[y * bytesPerRow + x];
        rgbImage.setPixelRgb(x, y, pixel, pixel, pixel);
      }
    }

    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
      '${tempDir.path}/captured_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await tempFile.writeAsBytes(img.encodeJpg(rgbImage));
    return tempFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera view
          CameraView(
            onImage: (CameraImage image) {
              _lastFrame = image;
              context.read<CameraInferenceProvider>().runLiveInference(image);
            },
          ),

          // Live result overlay
          Consumer<CameraInferenceProvider>(
            builder: (context, cameraProvider, child) {
              final liveResult = cameraProvider.liveResult;
              if (liveResult == null) return const SizedBox.shrink();

              // Filter confidence >= 0.8 dan sort
              final filtered = liveResult.entries
                  .where((e) => e.value >= 0.1)
                  .toList();
              if (filtered.isEmpty) return const SizedBox.shrink();
              filtered.sort((a, b) => b.value.compareTo(a.value));
              final best = filtered.first;

              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '${best.key}: ${(best.value * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),

          // Analyze Button
          Consumer<CameraInferenceProvider>(
            builder: (context, cameraProvider, child) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ElevatedButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);

                      // 1️⃣ Tangkap frame kamera (CameraImage?)
                      final CameraImage? image = await _captureFrame();
                      if (image == null) {
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Camera not ready')),
                        );
                        return;
                      }

                      // 2️⃣ Konversi CameraImage → File sementara
                      final tempFile = await _convertCameraImageToFile(image);

                      // 3️⃣ Jalankan ImageCropper
                      final cropped = await ImageCropper().cropImage(
                        sourcePath: tempFile.path,
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

                      if (cropped == null) {
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Crop canceled')),
                        );
                        return;
                      }

                      // 4️⃣ Ambil hasil analisis kamera
                      final result = cameraProvider.liveResult;
                      if (result == null || result.isEmpty) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('No result from analysis'),
                          ),
                        );
                        return;
                      }

                      // 5️⃣ Ambil label terbaik
                      final sorted = result.entries.toList()
                        ..sort((a, b) => b.value.compareTo(a.value));
                      final bestLabel = sorted.first;

                      // 6️⃣ Buat argument untuk navigasi
                      final argument = (
                        bestLabel.key,
                        bestLabel.value.toString(),
                      );

                      // 7️⃣ Navigasi ke halaman detail
                      navigator.pushNamed(
                        AppRouter.mealDetail,
                        arguments: MealResultArgument(argument, cropped),
                      );
                    },
                    child: const Text('Analyze'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
