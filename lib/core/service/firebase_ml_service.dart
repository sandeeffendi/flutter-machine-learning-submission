import 'dart:io';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseMlService {
  File? _cachedModelFile;

  Future<void> downloadModelIfNeeded() async {
    final directory = await getApplicationDocumentsDirectory();
    final localModelPath = '${directory.path}/food_identification_model.tflite';

    final localModelFile = File(localModelPath);

    if (await localModelFile.exists()) {
      _cachedModelFile = localModelFile;
      return;
    }

    final model = await FirebaseModelDownloader.instance.getModel(
      'Food-Identification-Model',
      FirebaseModelDownloadType.latestModel,
      FirebaseModelDownloadConditions(
        androidChargingRequired: false,
        androidWifiRequired: false,
        androidDeviceIdleRequired: false,
      ),
    );

    await model.file.copy(localModelPath);
    _cachedModelFile = File(localModelPath);
  }

  Future<File> loadModel() async {
    if (_cachedModelFile != null) {
      return _cachedModelFile!;
    }

    final model = await FirebaseModelDownloader.instance.getModel(
      'Food-Identification-Model',
      FirebaseModelDownloadType.localModel,
      FirebaseModelDownloadConditions(
        androidChargingRequired: false,
        androidWifiRequired: false,
        androidDeviceIdleRequired: false,
      ),
    );
    return model.file;
  }
}
