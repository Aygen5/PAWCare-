import 'package:flutter/material.dart';

import '../../../domain/entities/dog.dart';
import '../../../domain/entities/user_role.dart';

/// Profil ekranı durum aşamaları
enum ProfileStatus { initial, loading, loaded, error }

/// Profil ve ayarlar ekranının durumunu temsil eden state modeli.
class ProfileState {
  final ProfileStatus status;
  final String userName;
  final String userEmail;
  final String userPhone;
  final UserRole role;
  final Dog? dog;
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.userName = 'Aygen Yıldırım',
    this.userEmail = 'aygen@pawcare.com',
    this.userPhone = '+90 532 123 45 67',
    this.role = UserRole.owner,
    this.dog,
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? userName,
    String? userEmail,
    String? userPhone,
    UserRole? role,
    Dog? dog,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      role: role ?? this.role,
      dog: dog ?? this.dog,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          userName == other.userName &&
          userEmail == other.userEmail &&
          userPhone == other.userPhone &&
          role == other.role &&
          dog == other.dog &&
          themeMode == other.themeMode &&
          notificationsEnabled == other.notificationsEnabled &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      status.hashCode ^
      userName.hashCode ^
      userEmail.hashCode ^
      userPhone.hashCode ^
      role.hashCode ^
      dog.hashCode ^
      themeMode.hashCode ^
      notificationsEnabled.hashCode ^
      errorMessage.hashCode;
}
