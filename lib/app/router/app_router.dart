import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/models.dart';
import '../../data/repositories/settings_repository.dart';
import '../../features/splash/cubit/splash_cubit.dart';
import '../../features/splash/view/splash_page.dart';
import '../../screens/dog_profile_screen.dart';
import '../../screens/explore_screen.dart';
import '../../screens/owner_home_screen.dart';
import '../../screens/sitter_dashboard_screen.dart';
import '../../screens/sitter_detail_screen.dart';
import '../../features/onboarding/view/welcome_screen.dart';
import '../../state/app_state.dart';
import 'app_shell.dart';
import 'route_names.dart';

/// PawCare GoRouter rota yöneticisi ve sayfa geçiş yapılandırması.
class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNav');
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellNav');

  /// Belirtilen başlangıç konumuyla GoRouter örneği oluşturur.
  static GoRouter createRouter({
    String initialLocation = RoutePaths.splash,
    SettingsRepository? settingsRepository,
  }) {
    final settings = settingsRepository ?? SettingsRepository.inMemory();

    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      routes: [
        // 1. Açılış Splash Ekranı
        GoRoute(
          path: RoutePaths.splash,
          name: RouteNames.splash,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => SplashCubit(settingsRepository: settings),
              child: SplashPage(
                onReady: (hasSeenOnboarding) {
                  context.go(RoutePaths.welcome);
                },
              ),
            );
          },
        ),

        // 2. Karşılama ve Giriş/Kayıt Ekranı
        GoRoute(
          path: RoutePaths.welcome,
          name: RouteNames.welcome,
          builder: (context, state) {
            final appState = AppStateScope.of(context);
            return WelcomeScreen(
              onContinue: () {
                if (appState.role == UserRole.sitter) {
                  context.go(RoutePaths.sitterDashboard);
                } else {
                  context.go(RoutePaths.home);
                }
              },
            );
          },
        ),

        // 3. Bakıcı Detay Ekranı (Tam Ekran)
        GoRoute(
          path: RoutePaths.sitterDetail,
          name: RouteNames.sitterDetail,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final appState = AppStateScope.of(context);
            final sitter =
                state.extra as SitterListing? ?? appState.sitters.first;
            return SitterDetailScreen(
              sitter: sitter,
              onBack: () => context.pop(),
              onBookingCompleted: () {
                appState.setOwnerNavIndex(3);
                context.go(RoutePaths.bookings);
              },
            );
          },
        ),

        // 4. Alt Navigasyonlu ve Mobil Çerçeveli Ana Uygulama İskeleti (AppShell)
        ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            // Köpek Sahibi Ana Sayfası
            GoRoute(
              path: RoutePaths.home,
              name: RouteNames.home,
              builder: (context, state) => OwnerHomeScreen(
                onSitterSelected: (sitter) =>
                    context.push(RoutePaths.sitterDetail, extra: sitter),
              ),
            ),

            // Hizmet Arama ve Keşfet Ekranı
            GoRoute(
              path: RoutePaths.explore,
              name: RouteNames.explore,
              builder: (context, state) => ExploreScreen(
                onSitterSelected: (sitter) =>
                    context.push(RoutePaths.sitterDetail, extra: sitter),
              ),
            ),

            // Köpek Profili Ekranı
            GoRoute(
              path: RoutePaths.pets,
              name: RouteNames.pets,
              builder: (context, state) => const DogProfileScreen(),
            ),

            // Rezervasyon Talepleri Sekmesi
            GoRoute(
              path: RoutePaths.bookings,
              name: RouteNames.bookings,
              builder: (context, state) {
                final appState = AppStateScope.of(context);
                appState.setOwnerNavIndex(3);
                return OwnerHomeScreen(
                  onSitterSelected: (sitter) =>
                      context.push(RoutePaths.sitterDetail, extra: sitter),
                );
              },
            ),

            // Profil ve Ayarlar Sekmesi
            GoRoute(
              path: RoutePaths.profile,
              name: RouteNames.profile,
              builder: (context, state) {
                final appState = AppStateScope.of(context);
                appState.setOwnerNavIndex(4);
                return OwnerHomeScreen(
                  onSitterSelected: (sitter) =>
                      context.push(RoutePaths.sitterDetail, extra: sitter),
                );
              },
            ),

            // Hizmet Veren / Bakıcı Paneli
            GoRoute(
              path: RoutePaths.sitterDashboard,
              name: RouteNames.sitterDashboard,
              builder: (context, state) => const SitterDashboardScreen(),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text('Sayfa bulunamadı: ${state.uri.path}')),
      ),
    );
  }
}
