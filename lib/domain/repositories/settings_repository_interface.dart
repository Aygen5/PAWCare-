/// Tema, kullanıcı rolü ve tanıtım durumu gibi uygulama ayarlarını yöneten soyut Domain sözleşmesi.
abstract class SettingsRepositoryInterface {
  /// Tema modu tercihini döner ('light', 'dark', 'system').
  String getThemeMode();

  /// Tema modunu günceller.
  Future<void> setThemeMode(String mode);

  /// Kullanıcı rolünü döner ('owner', 'sitter').
  String getUserRole();

  /// Kullanıcı rolünü günceller.
  Future<void> setUserRole(String role);

  /// Karşılama/tanıtım (onboarding) ekranının daha önce tamamlanıp tamamlanmadığını döner.
  bool hasSeenOnboarding();

  /// Tanıtım görülme durumunu kaydeder.
  Future<void> setHasSeenOnboarding(bool seen);
}
