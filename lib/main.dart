import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'data/local/hive_boxes.dart';
import 'data/repositories/settings_repository.dart';
import 'features/splash/cubit/splash_cubit.dart';
import 'features/splash/view/splash_page.dart';
import 'screens/app_shell.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBoxes.init();
  final settingsRepo = await SettingsRepository.create();
  runApp(PawCareApp(settingsRepository: settingsRepo));
}

class PawCareApp extends StatefulWidget {
  final SettingsRepository? settingsRepository;
  final bool enableSplash;

  const PawCareApp({
    super.key,
    this.settingsRepository,
    this.enableSplash = true,
  });

  @override
  State<PawCareApp> createState() => _PawCareAppState();
}

class _PawCareAppState extends State<PawCareApp> {
  late final AppState _appState;
  late final ThemeCubit _themeCubit;
  late final SettingsRepository _settingsRepository;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _settingsRepository = widget.settingsRepository ?? SettingsRepository.inMemory();
    _themeCubit = ThemeCubit(_settingsRepository);
    _showSplash = widget.enableSplash;
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
            return MaterialApp(
              title: 'PawCare — Evcil Hayvan Yönetimi',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              home: _showSplash
                  ? BlocProvider(
                      create: (_) => SplashCubit(
                        settingsRepository: _settingsRepository,
                      ),
                      child: SplashPage(
                        onReady: (_) {
                          if (mounted) {
                            setState(() {
                              _showSplash = false;
                            });
                          }
                        },
                      ),
                    )
                  : const AppShell(),
            );
          },
        ),
      ),
    );
  }
}
