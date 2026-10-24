import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class ImageStorageService {
  static const String _folderName = 'pawcare_pets';

  /// Seçilen evcil hayvan fotoğrafını yerel cihaz depolamasına kalıcı olarak kopyalar.
  static Future<String> persistPetPhoto(XFile pickedFile) async {
    if (kIsWeb) {
      // Web ortamında dosya yolu doğrudan kullanılır.
      return pickedFile.path;
    }

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final petDir = Directory('${appDir.path}/$_folderName');

      if (!await petDir.exists()) {
        await petDir.create(recursive: true);
      }

      final fileName = 'dog_${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
      final permanentPath = '${petDir.path}/$fileName';

      final savedFile = await File(pickedFile.path).copy(permanentPath);
      return savedFile.path;
    } catch (e) {
      debugPrint('Error saving pet photo permanently: $e');
      return pickedFile.path;
    }
  }

  /// Dosya yolunun assets kaynağı olup olmadığını belirler.
  static bool isAssetPath(String path) {
    return path.startsWith('assets/');
  }
}
