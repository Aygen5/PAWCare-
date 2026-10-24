import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/settings_repository_interface.dart';

/// Tema modunu yöneten ve SharedPreferences üzerinde saklayan Cubit.
class ThemeCubit extends Cubit<ThemeMode> {
  final SettingsRepositoryInterface _settingsRepository;

  ThemeCubit(this._settingsRepository)
    : super(_loadInitialMode(_settingsRepository));

  // Kayıtlı metni ThemeMode nesnesine dönüştürür.
  static ThemeMode _loadInitialMode(SettingsRepositoryInterface repo) {
    final modeStr = repo.getThemeMode();
    switch (modeStr) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Tema modunu günceller ve kalıcı olarak kaydeder.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;

    final String modeStr;
    switch (mode) {
      case ThemeMode.light:
        modeStr = 'light';
        break;
      case ThemeMode.dark:
        modeStr = 'dark';
        break;
      case ThemeMode.system:
        modeStr = 'system';
        break;
    }

    await _settingsRepository.setThemeMode(modeStr);
    emit(mode);
  }

  /// Açık ve koyu tema arasında geçiş yapar.
  Future<void> toggleTheme() async {
    if (state == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }

  /// Açık temaya ayarlar.
  Future<void> setLight() async => setThemeMode(ThemeMode.light);

  /// Koyu yeşil temaya ayarlar.
  Future<void> setDark() async => setThemeMode(ThemeMode.dark);

  /// Sistem temasına ayarlar.
  Future<void> setSystem() async => setThemeMode(ThemeMode.system);
}
