import '../../repositories/settings_repository_interface.dart';

/// Tema, rol ve tanıtım ekranı durumunu güncelleyen kullanım senaryosu.
class UpdateAppSettingsUseCase {
  final SettingsRepositoryInterface repository;

  const UpdateAppSettingsUseCase(this.repository);

  Future<void> setThemeMode(String mode) => repository.setThemeMode(mode);

  Future<void> setUserRole(String role) => repository.setUserRole(role);

  Future<void> setHasSeenOnboarding(bool seen) =>
      repository.setHasSeenOnboarding(seen);
}
