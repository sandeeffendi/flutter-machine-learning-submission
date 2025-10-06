import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/core/service/image_classification_service.dart';

class CameraInferenceProvider extends ChangeNotifier {
  final ImageClassificationService _service;

  CameraInferenceProvider(this._service) {
    _service.initHelper();
  }

  bool _isAnalyzing = false;
  bool get isAnalyzing => _isAnalyzing;

  Map<String, double>? _liveResult;
  Map<String, double>? get liveResult => _liveResult;

  /// Jalankan inferensi live dari stream kamera
  Future<void> runLiveInference(CameraImage image) async {
    if (_isAnalyzing) return;
    _isAnalyzing = true;

    try {
      final result = await _service.inferenceCameraFrame(image);

      if (result.isNotEmpty) {
        // Ambil prediksi dengan confidence tertinggi
        // final best = result.entries.reduce((a, b) => a.value > b.value ? a : b);

        // Filter confidence di atas 80%
        final listBest = result.entries.take(3);
        final sortedList = listBest.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final bestEntry = sortedList.first;

        _liveResult = {bestEntry.key: bestEntry.value};
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error run live inference camera: $e');
    } finally {
      await Future.delayed(const Duration(milliseconds: 50));
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  // /// Jalankan snapshot (satu kali analisis saat tombol ditekan)
  // Future<Map<String, double>?> runSnapshotAnalysis(CameraImage image) async {
  //   try {
  //     final result = await _service.inferenceCameraFrame(image);

  //     if (result.isNotEmpty) {
  //       final best = result.entries.first;

  //       return best.value >= 0.8 ? {best.key: best.value} : null;
  //     }
  //     return null;
  //   } catch (e) {
  //     debugPrint('⚠️ Error snapshot inference: $e');
  //     return null;
  //   }
  // }
}
