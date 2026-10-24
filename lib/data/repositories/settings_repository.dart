import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const String _themeModeKey = 'theme_mode';
  static const String _userRoleKey = 'user_role';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  static Future<SettingsRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsRepository(prefs);
  }

  /// Tema modu: 'system', 'light', 'dark'
  String getThemeMode() {
    return _prefs.getString(_themeModeKey) ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeModeKey, mode);
  }

  /// Kayıtlı kullanıcı rolü: 'owner' veya 'sitter'
  String getUserRole() {
    return _prefs.getString(_userRoleKey) ?? 'owner';
  }

  Future<void> setUserRole(String role) async {
    await _prefs.setString(_userRoleKey, role);
  }

  /// Tanıtım (onboarding) ekranının görülme durumu
  bool hasSeenOnboarding() {
    return _prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  Future<void> setHasSeenOnboarding(bool seen) async {
    await _prefs.setBool(_hasSeenOnboardingKey, seen);
  }
}
