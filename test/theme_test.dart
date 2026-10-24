import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paw_care/core/theme/app_colors.dart';
import 'package:paw_care/core/theme/app_theme.dart';
import 'package:paw_care/core/theme/theme_cubit.dart';
import 'package:paw_care/data/repositories/settings_repository.dart';

import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('Adım 2.1: AppTheme & Renk Paleti Kontrast Testleri', () {
    test('Açık tema (lightTheme) tasarım sistemi tokenlarıyla uyumlu olmalı', () {
      final theme = AppTheme.lightTheme;
      expect(theme.brightness, Brightness.light);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.surface, AppColors.surface);
      expect(theme.colorScheme.onSurface, AppColors.onSurface);
      expect(theme.colorScheme.onSurfaceVariant, AppColors.onSurfaceVariant);

      // Açık tema metin-arkaplan kontrastı
      expect(theme.colorScheme.onSurface.computeLuminance(), lessThan(0.2));
      expect(theme.scaffoldBackgroundColor.computeLuminance(), greaterThan(0.8));
    });

    test('Koyu tema (darkTheme) koyu zeytin/haki paletine uymalı ve saf siyah içermemeli', () {
      final theme = AppTheme.darkTheme;
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, AppColors.darkBackground);
      expect(theme.colorScheme.surface, AppColors.darkSurface);
      expect(theme.colorScheme.primary, AppColors.darkPrimary);
      expect(theme.colorScheme.onSurface, AppColors.darkOnSurface);

      // Koyu tema arkaplanı saf siyah (#000000) olmamalıdır
      expect(theme.scaffoldBackgroundColor, isNot(const Color(0xFF000000)));
      expect(theme.colorScheme.surface, isNot(const Color(0xFF000000)));

      // Koyu tema arkaplanı koyu yeşil/haki (#16241A) olmalıdır
      expect(theme.scaffoldBackgroundColor, const Color(0xFF16241A));
      expect(theme.colorScheme.surface, const Color(0xFF1E3023));

      // Koyu tema metin kontrastı doğrulaması
      expect(theme.colorScheme.onSurface.computeLuminance(), greaterThan(0.7));
      expect(theme.scaffoldBackgroundColor.computeLuminance(), lessThan(0.05));
    });
  });

  group('Adım 2.2: ThemeCubit ve Kalıcı Tema Durumu Testleri', () {
    late SettingsRepository settingsRepository;

    setUp(() {
      settingsRepository = SettingsRepository.inMemory();
    });

    test('ThemeCubit varsayılan olarak sistem temasını veya kayıtlı tercihi yükler', () {
      final cubit = ThemeCubit(settingsRepository);
      expect(cubit.state, ThemeMode.system);
    });

    test('ThemeCubit koyu temaya geçildiğinde durumu ve depolamayı günceller', () async {
      final cubit = ThemeCubit(settingsRepository);

      await cubit.setDark();
      expect(cubit.state, ThemeMode.dark);
      expect(settingsRepository.getThemeMode(), 'dark');

      await cubit.setLight();
      expect(cubit.state, ThemeMode.light);
      expect(settingsRepository.getThemeMode(), 'light');

      await cubit.setSystem();
      expect(cubit.state, ThemeMode.system);
      expect(settingsRepository.getThemeMode(), 'system');
    });

    test('ThemeCubit toggleTheme fonksiyonu iki yönlü geçişi sağlar', () async {
      final cubit = ThemeCubit(settingsRepository);

      await cubit.setLight();
      await cubit.toggleTheme();
      expect(cubit.state, ThemeMode.dark);
      expect(settingsRepository.getThemeMode(), 'dark');

      await cubit.toggleTheme();
      expect(cubit.state, ThemeMode.light);
      expect(settingsRepository.getThemeMode(), 'light');
    });

    test('ThemeCubit mevcut kayıtlı tercihle doğru başlatılır', () async {
      await settingsRepository.setThemeMode('dark');
      final cubit = ThemeCubit(settingsRepository);
      expect(cubit.state, ThemeMode.dark);
    });
  });
}
