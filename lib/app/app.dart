import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../domain/repositories/settings_repository_interface.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_cubit.dart';
import '../data/repositories/settings_repository.dart';
import '../features/auth/cubit/auth_cubit.dart';
import '../features/auth/cubit/role_cubit.dart';
import '../core/utils/app_state.dart';
import 'router/app_router.dart';
import 'router/route_names.dart';

/// PawCare ana uygulama kurulumu, tema, rol, kimlik ve router bağlantısı.
class PawCareApp extends StatefulWidget {
  final SettingsRepositoryInterface? settingsRepository;
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
  late final RoleCubit _roleCubit;
  late final AuthCubit _authCubit;
  late final SettingsRepositoryInterface _settingsRepository;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _settingsRepository =
        widget.settingsRepository ?? SettingsRepository.inMemory();
    _themeCubit = ThemeCubit(_settingsRepository);
    _roleCubit = RoleCubit(settingsRepository: _settingsRepository);
    _authCubit = AuthCubit(settingsRepository: _settingsRepository);

    // RoleCubit ile AppState senkronizasyonu
    _appState.setRole(_roleCubit.state);
    _roleCubit.stream.listen((role) {
      if (_appState.role != role) {
        _appState.setRole(role);
      }
    });

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
    _roleCubit.close();
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _themeCubit),
        BlocProvider.value(value: _roleCubit),
        BlocProvider.value(value: _authCubit),
      ],
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
