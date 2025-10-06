// import 'package:camera/camera.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:image_identification_submisison_app/app/app_router.dart';
// import 'package:image_identification_submisison_app/app/arguments/meal_detail_argument.dart';
// import 'package:image_identification_submisison_app/core/providers/camera_inference_provider.dart';
// import 'package:image_identification_submisison_app/core/providers/image_classification_provider.dart';
// import 'package:image_identification_submisison_app/widgets/camera_view.dart';
// import 'package:provider/provider.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({super.key});

//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   CameraImage? _lastFrame;

//   /// Format hasil inference jadi string "Label: 92.3%"
//   String _formatResult(Map<String, double> result) {
//     final sorted = result.entries.toList()
//       ..sort((a, b) => b.value.compareTo(a.value));
//     final top = sorted.first;
//     return '${top.key}: ${(top.value * 100).toStringAsFixed(2)}%';
//   }

//   /// Ambil frame terakhir dari stream kamera
//   Future<CameraImage?> _captureFrame() async {
//     return _lastFrame;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cameraProvider = context.watch<CameraInferenceProvider>();

//     return Scaffold(
//       body: Consumer<ImageClassificationViewmodel>(
//         builder: (context, value, child) {
//           return Stack(
//             children: [
//               CameraView(
//                 onImage: (CameraImage image) {
//                   // Simpan frame terakhir
//                   _lastFrame = image;

//                   // Jalankan live inference
//                   context.read<CameraInferenceProvider>().runLiveInference(
//                     image,
//                   );
//                 },
//               ),

//               // Live result (confidence >= 0.8)
//               // if (cameraProvider.liveResult != null)
//               Consumer<CameraInferenceProvider>(
//                 builder: (context, value, child) {
//                   final filtered = cameraProvider.liveResult!.entries
//                       .where((e) => e.value >= 0.8)
//                       .toList();
//                   if (filtered.isEmpty) return const SizedBox.shrink();
//                   final best = filtered.first;
//                   return Align(
//                     alignment: Alignment.topCenter,
//                     child: Container(
//                       color: Colors.black54,
//                       padding: const EdgeInsets.all(8),
//                       child: Text(
//                         '${best.key}: ${(best.value * 100).toStringAsFixed(1)}%',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),

//               // Analyze Button
//               Consumer<CameraInferenceProvider>(
//                 builder: (context, value, child) {
//                   return Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.all(24),
//                       child: ElevatedButton(
//                         onPressed: cameraProvider.isAnalyzing
//                             ? null
//                             : () async {
//                                 final image = await _captureFrame();
//                                 if (image == null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text('camera not ready')),
//                                   );
//                                 } else {
//                                   final best =
//                                       cameraProvider.liveResult!.entries.first;
//                                   final argument = (
//                                     best.key,
//                                     best.value.toString(),
//                                   );

//                                   Navigator.pushNamed(
//                                     context,
//                                     AppRouter.mealDetail,
//                                     arguments: MealResultArgument(argument),
//                                   );
//                                 }
//                               },
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 48,
//                             vertical: 16,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         child: const Text(
//                           'Analyze',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/app/app_router.dart';
import 'package:image_identification_submisison_app/app/arguments/meal_detail_argument.dart';
import 'package:image_identification_submisison_app/core/providers/camera_inference_provider.dart';
import 'package:image_identification_submisison_app/widgets/camera_view.dart';
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
                      final image = await _captureFrame();
                      if (image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Camera not ready')),
                        );
                        return;
                      }

                      final result = cameraProvider.liveResult;
                      if (result == null || result.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No result from analysis'),
                          ),
                        );
                        return;
                      }

                      // Ambil label terbaik
                      final sorted = result.entries.toList()
                        ..sort((a, b) => b.value.compareTo(a.value));
                      final bestLabel = sorted.first;
                      final argument = (
                        bestLabel.key,
                        bestLabel.value.toString(),
                      );
                      // Navigasi dengan argument aman

                      Navigator.pushNamed(
                        context,
                        AppRouter.mealDetail,
                        arguments: MealResultArgument(argument),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Analyze',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
