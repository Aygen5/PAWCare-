import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_cubit.dart';
import '../data/repositories/settings_repository.dart';
import '../state/app_state.dart';
import 'router/app_router.dart';
import 'router/route_names.dart';

/// PawCare ana uygulama kurulumu ve tema/router bağlantısı.
class PawCareApp extends StatefulWidget {
  final SettingsRepository? settingsRepository;
  final String initialLocation;
  final bool enableSplash;

  const PawCareApp({
    super.key,
    this.settingsRepository,
    this.initialLocation = RoutePaths.splash,
    this.enableSplash = true,
  });

  @override
  State<PawCareApp> createState() => _PawCareAppState();
}

class _PawCareAppState extends State<PawCareApp> {
  late final AppState _appState;
  late final ThemeCubit _themeCubit;
  late final SettingsRepository _settingsRepository;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _settingsRepository =
        widget.settingsRepository ?? SettingsRepository.inMemory();
    _themeCubit = ThemeCubit(_settingsRepository);
    final effectiveLocation = widget.enableSplash
        ? widget.initialLocation
        : RoutePaths.welcome;
    _router = AppRouter.createRouter(
      initialLocation: effectiveLocation,
      settingsRepository: _settingsRepository,
    );
  }

  @override
  void dispose() {
    _appState.dispose();
    _themeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _themeCubit,
      child: AppStateScope(
        notifier: _appState,
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'PawCare — Evcil Hayvan Yönetimi',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: _router,
            );
          },
        ),
      ),
    );
  }
}
