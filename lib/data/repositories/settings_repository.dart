import 'package:shared_preferences/shared_preferences.dart';

/// Tema, rol ve tanıtım durumunu SharedPreferences ve bellek içi depoda saklayan repository.
class SettingsRepository {
  static const String _themeModeKey = 'theme_mode';
  static const String _userRoleKey = 'user_role';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  final SharedPreferences? _prefs;
  final Map<String, dynamic> _memoryStore = {};

  SettingsRepository([this._prefs]);

  /// Bellek içi test veya hazır instance üretir.
  factory SettingsRepository.inMemory() => SettingsRepository();

  static Future<SettingsRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsRepository(prefs);
  }

  /// Tema modu: 'system', 'light', 'dark'
  String getThemeMode() {
    return _prefs?.getString(_themeModeKey) ??
        _memoryStore[_themeModeKey] as String? ??
        'system';
  }

  Future<void> setThemeMode(String mode) async {
    _memoryStore[_themeModeKey] = mode;
    await _prefs?.setString(_themeModeKey, mode);
  }

  /// Kayıtlı kullanıcı rolü: 'owner' veya 'sitter'
  String getUserRole() {
    return _prefs?.getString(_userRoleKey) ??
        _memoryStore[_userRoleKey] as String? ??
        'owner';
  }

  Future<void> setUserRole(String role) async {
    _memoryStore[_userRoleKey] = role;
    await _prefs?.setString(_userRoleKey, role);
  }

  /// Tanıtım (onboarding) ekranının görülme durumu
  bool hasSeenOnboarding() {
    return _prefs?.getBool(_hasSeenOnboardingKey) ??
        _memoryStore[_hasSeenOnboardingKey] as bool? ??
        false;
  }

  Future<void> setHasSeenOnboarding(bool seen) async {
    _memoryStore[_hasSeenOnboardingKey] = seen;
    await _prefs?.setBool(_hasSeenOnboardingKey, seen);
  }
}
