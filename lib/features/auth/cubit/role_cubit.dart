import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_role.dart';
import '../../../domain/repositories/settings_repository_interface.dart';

/// Aktif kullanıcı rolünü (Köpek Sahibi / Hizmet Veren) ve kalıcılığını yöneten Cubit.
class RoleCubit extends Cubit<UserRole> {
  final SettingsRepositoryInterface? _settingsRepository;

  RoleCubit({SettingsRepositoryInterface? settingsRepository})
    : _settingsRepository = settingsRepository,
      super(_resolveInitialRole(settingsRepository));

  static UserRole _resolveInitialRole(SettingsRepositoryInterface? repo) {
    if (repo == null) return UserRole.owner;
    final saved = repo.getUserRole();
    return saved == 'sitter' ? UserRole.sitter : UserRole.owner;
  }

  /// Kullanıcı rolünü doğrudan belirler.
  Future<void> setRole(UserRole newRole) async {
    if (state == newRole) return;
    emit(newRole);
    await _settingsRepository?.setUserRole(
      newRole == UserRole.sitter ? 'sitter' : 'owner',
    );
  }

  /// Aktif rolü Köpek Sahibi ve Hizmet Veren arasında değiştirir.
  Future<void> toggleRole() async {
    final nextRole = state == UserRole.owner ? UserRole.sitter : UserRole.owner;
    await setRole(nextRole);
  }

  /// Köpek Sahibi rolüne geçiş yapar.
  Future<void> switchToOwner() async {
    await setRole(UserRole.owner);
  }

  /// Hizmet Veren (Bakıcı) rolüne geçiş yapar.
  Future<void> switchToSitter() async {
    await setRole(UserRole.sitter);
  }
}
