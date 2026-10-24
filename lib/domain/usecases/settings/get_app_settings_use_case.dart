import '../../repositories/settings_repository_interface.dart';

/// Tema, rol ve tanıtım ekranı görülme durumunu getiren kullanım senaryosu.
class GetAppSettingsUseCase {
  final SettingsRepositoryInterface repository;

  const GetAppSettingsUseCase(this.repository);

  String getThemeMode() => repository.getThemeMode();

  String getUserRole() => repository.getUserRole();

  bool hasSeenOnboarding() => repository.hasSeenOnboarding();
}
