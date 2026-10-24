import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paw_care/core/theme/app_theme.dart';
import 'package:paw_care/data/repositories/settings_repository.dart';
import 'package:paw_care/features/splash/cubit/splash_cubit.dart';
import 'package:paw_care/features/splash/view/splash_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('Adım 2.3: SplashCubit ve SplashPage Testleri', () {
    late SettingsRepository settingsRepository;

    setUp(() {
      settingsRepository = SettingsRepository.inMemory();
    });

    test('SplashCubit initializeApp sonrası SplashReady durumunu yayınlar', () async {
      final cubit = SplashCubit(
        settingsRepository: settingsRepository,
        minDisplayDuration: const Duration(milliseconds: 10),
      );

      expect(cubit.state, isA<SplashInitial>());

      final states = <SplashState>[];
      final subscription = cubit.stream.listen(states.add);

      await cubit.initializeApp();
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(states.length, 2);
      expect(states[0], isA<SplashLoading>());
      expect(states[1], isA<SplashReady>());

      await subscription.cancel();
      await cubit.close();
    });

    testWidgets('SplashPage pati logosunu, başlığı ve animasyonu başarıyla çizer', (tester) async {
      final cubit = SplashCubit(
        settingsRepository: settingsRepository,
        minDisplayDuration: Duration.zero,
      );

      bool readyCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: BlocProvider.value(
            value: cubit,
            child: SplashPage(
              onReady: (hasSeenOnboarding) {
                readyCalled = true;
              },
            ),
          ),
        ),
      );

      // Logo ve marka metninin varlığını doğrular
      expect(find.text('PawCare'), findsOneWidget);
      expect(find.byIcon(Icons.pets), findsOneWidget);
      expect(find.textContaining('Güven & Sevgi'), findsOneWidget);

      // Animasyonları ilerletir
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 500));

      // Süre bitiminde onReady geri çağrımının tetiklendiğini doğrular
      expect(readyCalled, isTrue);

      await cubit.close();
    });

    testWidgets('SplashPage koyu yeşil temada da başarıyla oluşturulur', (tester) async {
      final cubit = SplashCubit(
        settingsRepository: settingsRepository,
        minDisplayDuration: Duration.zero,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: BlocProvider.value(
            value: cubit,
            child: const SplashPage(),
          ),
        ),
      );

      expect(find.text('PawCare'), findsOneWidget);
      expect(find.byIcon(Icons.pets), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 200));
      await cubit.close();
    });
  });
}
