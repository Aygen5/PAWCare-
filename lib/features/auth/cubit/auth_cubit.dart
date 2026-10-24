import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_role.dart';
import '../../../domain/repositories/settings_repository_interface.dart';

/// Kimlik doğrulama durumunu temsil eden model.
class AuthState {
  final bool isAuthenticated;
  final String? userEmail;
  final String? userName;
  final UserRole role;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.isAuthenticated = false,
    this.userEmail,
    this.userName,
    this.role = UserRole.owner,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userEmail,
    String? userName,
    UserRole? role,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Giriş, kayıt ve oturum durumunu yöneten Cubit.
class AuthCubit extends Cubit<AuthState> {
  final SettingsRepositoryInterface? settingsRepository;

  AuthCubit({this.settingsRepository}) : super(const AuthState());

  /// Demo hesabı veya kullanıcı bilgileriyle giriş yapar.
  Future<bool> login({required String email, required String password}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.trim().isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Lütfen tüm alanları doldurunuz.',
        ),
      );
      return false;
    }

    // Demo kullanıcı rol eşleştirmesi
    final UserRole role = trimmedEmail.contains('ayse')
        ? UserRole.sitter
        : UserRole.owner;
    final String name = role == UserRole.sitter ? 'Ayşe Yılmaz' : 'Aygen Y.';

    await settingsRepository?.setUserRole(
      role == UserRole.sitter ? 'sitter' : 'owner',
    );

    emit(
      AuthState(
        isAuthenticated: true,
        userEmail: trimmedEmail,
        userName: name,
        role: role,
        isLoading: false,
      ),
    );
    return true;
  }

  /// Yeni kullanıcı hesabı kaydeder.
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Lütfen tüm alanları doldurunuz.',
        ),
      );
      return false;
    }

    await settingsRepository?.setUserRole(
      role == UserRole.sitter ? 'sitter' : 'owner',
    );

    emit(
      AuthState(
        isAuthenticated: true,
        userEmail: email.trim(),
        userName: name.trim(),
        role: role,
        isLoading: false,
      ),
    );
    return true;
  }

  /// Oturumu sonlandırır.
  Future<void> logout() async {
    emit(const AuthState(isAuthenticated: false));
  }
}
