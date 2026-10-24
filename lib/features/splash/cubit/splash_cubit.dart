import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/settings_repository.dart';

/// Splash ekranının durumlarını temsil eden temel soyut sınıf.
abstract class SplashState {
  const SplashState();
}

/// Uygulama ilk açıldığında gösterilen başlangıç durumu.
class SplashInitial extends SplashState {
  const SplashInitial();
}

/// Verilerin hazırlandığı ve animasyonun devam ettiği yükleme durumu.
class SplashLoading extends SplashState {
  const SplashLoading();
}

/// Başlatma tamamlandığında ve sonraki ekrana geçişe hazır olunduğunda yayınlanan durum.
class SplashReady extends SplashState {
  final bool hasSeenOnboarding;

  const SplashReady({required this.hasSeenOnboarding});
}

/// Splash ekranı animasyonunu ve başlangıç verilerinin hazır olma sürecini yöneten Cubit.
class SplashCubit extends Cubit<SplashState> {
  final SettingsRepository settingsRepository;
  final Duration minDisplayDuration;

  SplashCubit({
    required this.settingsRepository,
    this.minDisplayDuration = const Duration(milliseconds: 1800),
  }) : super(const SplashInitial());

  /// Başlangıç kontrollerini yapar ve süre bitiminde hazır olma durumunu yayınlar.
  Future<void> initializeApp() async {
    emit(const SplashLoading());

    // Animasyon veya asenkron veri hazırlık süresini bekler
    await Future.delayed(minDisplayDuration);

    final hasSeenOnboarding = settingsRepository.hasSeenOnboarding();
    emit(SplashReady(hasSeenOnboarding: hasSeenOnboarding));
  }
}
