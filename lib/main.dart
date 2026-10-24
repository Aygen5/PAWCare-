import 'package:flutter/material.dart';

import 'app/app.dart';
import 'data/local/hive_boxes.dart';
import 'data/repositories/settings_repository.dart';

// Geriye dönük uyumluluk için PawCareApp sınıfını dışa aktarır.
export 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBoxes.init();
  final settingsRepo = await SettingsRepository.create();
  runApp(PawCareApp(settingsRepository: settingsRepo));
}
