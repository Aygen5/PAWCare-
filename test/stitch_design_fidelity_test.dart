import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:paw_care/core/theme/theme_cubit.dart';
import 'package:paw_care/core/utils/app_state.dart';
import 'package:paw_care/data/models/models.dart';
import 'package:paw_care/data/repositories/settings_repository.dart';
import 'package:paw_care/domain/repositories/settings_repository_interface.dart';
import 'package:paw_care/features/auth/cubit/auth_cubit.dart';
import 'package:paw_care/features/auth/cubit/role_cubit.dart';
import 'package:paw_care/features/discovery/view/explore_screen.dart';
import 'package:paw_care/features/discovery/view/sitter_detail_screen.dart';
import 'package:paw_care/features/home/cubit/home_cubit.dart';
import 'package:paw_care/features/home/view/owner_home_screen.dart';
import 'package:paw_care/features/onboarding/view/welcome_screen.dart';
import 'package:paw_care/features/pets/view/dog_profile_screen.dart';
import 'package:paw_care/features/provider/view/sitter_dashboard_screen.dart';

void main() {
  late SettingsRepositoryInterface settingsRepo;
  late ThemeCubit themeCubit;
  late RoleCubit roleCubit;
  late AuthCubit authCubit;
  late AppState appState;

  setUp(() {
    settingsRepo = SettingsRepository.inMemory();
    themeCubit = ThemeCubit(settingsRepo);
    roleCubit = RoleCubit(settingsRepository: settingsRepo);
    authCubit = AuthCubit(settingsRepository: settingsRepo);
    appState = AppState();
  });

  tearDown(() {
    themeCubit.close();
    roleCubit.close();
    authCubit.close();
  });

  Widget wrapWithProviders(Widget child, {Size size = const Size(800, 1200)}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider.value(value: roleCubit),
        BlocProvider.value(value: authCubit),
      ],
      child: AppStateScope(
        notifier: appState,
        child: MediaQuery(
          data: MediaQueryData(size: size),
          child: MaterialApp(home: child),
        ),
      ),
    );
  }

  group('Adım 6.2: 6 Stitch Ekranının Tasarım Sadakati ve Etkileşim Denetimi', () {
    testWidgets('Ekran 1: Karşılama Ekranı (WelcomeScreen) görsel hiyerarşi ve demo rolleri', (tester) async {
      await tester.pumpWidget(
        wrapWithProviders(WelcomeScreen(onContinue: () {})),
      );
      await tester.pump();

      expect(find.text('PawCare'), findsWidgets);
      expect(find.text('Dostunuz için en güvenilir eller.'), findsOneWidget);
      expect(find.text('Köpek Sahibi Olarak Başla'), findsOneWidget);
      expect(find.text('Hizmet Veren Paneline Geç'), findsOneWidget);
      expect(find.text('Giriş Yap'), findsOneWidget);
      expect(find.text('Hesap Oluştur'), findsOneWidget);
    });

    testWidgets('Ekran 2: Keşfet Ekranı (ExploreScreen) başlık, arama ve filtreler', (tester) async {
      await tester.pumpWidget(
        wrapWithProviders(ExploreScreen(onSitterSelected: (_) {})),
      );
      await tester.pump();

      expect(find.text('Hizmet Keşfet'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Tümü'), findsOneWidget);
      expect(find.text('Köpek Oteli'), findsWidgets);
      expect(find.text('Köpek Gezdirme'), findsWidgets);
    });

    testWidgets('Ekran 3: Köpek Sahibi Ana Sayfa (OwnerHomeScreen) karşılama ve köpek kartı', (tester) async {
      final homeCubit = HomeCubit();
      await tester.pumpWidget(
        wrapWithProviders(OwnerHomeScreen(cubit: homeCubit, onSitterSelected: (_) {})),
      );
      // Animasyon sonsuz döngüde olduğu için pumpAndSettle yerine pump kullanılır
      await tester.pump();

      expect(find.text('Merhaba, Aygen 👋'), findsOneWidget);
      expect(find.text('Barley'), findsWidgets);
      expect(find.text('Popüler Hizmetler'), findsOneWidget);

      homeCubit.close();
    });

    testWidgets('Ekran 4: Bakıcı Detay ve Rezervasyon Ekranı (SitterDetailScreen) detaylar ve rezervasyon', (tester) async {
      final sampleSitter = SitterListing(
        id: 'sitter_1',
        name: 'Mert Demir',
        facilityTitle: 'Pati Köpek Oteli',
        category: 'Yatılı Bakım',
        rating: 4.9,
        reviewsCount: 38,
        pricePerUnit: 350.0,
        unitLabel: 'gece',
        location: 'Kadıköy, Moda',
        distanceKm: 1.2,
        imagePath: 'assets/images/sitters/mert_demir.jpg',
        galleryPaths: const ['assets/images/sitters/mert_demir.jpg'],
        bio: 'Hayvansever deneyimli bakıcı.',
        amenities: const ['Geniş Bahçe', 'Kamera Takibi'],
        isVerified: true,
      );

      await tester.pumpWidget(
        wrapWithProviders(
          SitterDetailScreen(
            sitter: sampleSitter,
            onBack: () {},
            onBookingCompleted: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Pati Köpek Oteli'), findsWidgets);
      expect(find.textContaining('Mert Demir'), findsWidgets);
      expect(find.text('Rezervasyon Talebi Gönder'), findsOneWidget);
    });

    testWidgets('Ekran 5: Köpek Profili Ekranı (DogProfileScreen) sağlık kartı ve profil düzenleme', (tester) async {
      await tester.pumpWidget(
        wrapWithProviders(const DogProfileScreen()),
      );
      await tester.pump();

      expect(find.text('Köpek Profili & Sağlık'), findsOneWidget);
      expect(find.text('Barley'), findsWidgets);
      expect(find.text('Yaş'), findsOneWidget);
      expect(find.text('Ağırlık'), findsOneWidget);
      expect(find.text('Cinsiyet'), findsOneWidget);
      expect(find.text('Profili Düzenle'), findsOneWidget);
    });

    testWidgets('Ekran 6: Hizmet Veren Paneli (SitterDashboardScreen) metrikler ve gelen talepler', (tester) async {
      appState.setRole(UserRole.sitter);

      await tester.pumpWidget(
        wrapWithProviders(const SitterDashboardScreen()),
      );
      await tester.pump();

      expect(find.text('Hizmet Veren Paneli'), findsOneWidget);
      expect(find.text('Bekleyen'), findsOneWidget);
      expect(find.text('Onaylı'), findsOneWidget);
      expect(find.text('Kazanç'), findsOneWidget);
      expect(find.text('Yeni Gelen Talepler'), findsOneWidget);
    });
  });
}
