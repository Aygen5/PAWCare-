import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// PawCare Nunito Sans tipografi tanımları ve temaya duyarlı metin stilleri.
class AppTypography {
  // Statik getter'lar (Varsayılan Açık Tema Uyumluluğu)
  static TextStyle get display => GoogleFonts.nunitoSans(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 44 / 36,
    color: AppColors.onSurface,
    letterSpacing: -0.5,
  );

  static TextStyle get headlineHero => GoogleFonts.nunitoSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    color: AppColors.onSurface,
    letterSpacing: -0.3,
  );

  static TextStyle get headlineScreen => GoogleFonts.nunitoSans(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 34 / 26,
    color: AppColors.onSurface,
    letterSpacing: -0.2,
  );

  static TextStyle get headlineSection => GoogleFonts.nunitoSans(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    height: 26 / 19,
    color: AppColors.onSurface,
  );

  static TextStyle get titleCard => GoogleFonts.nunitoSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22 / 16,
    color: AppColors.onSurface,
  );

  static TextStyle get bodyDefault => GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get bodyMedium => GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    color: AppColors.onSurface,
  );

  static TextStyle get caption => GoogleFonts.nunitoSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get labelTag => GoogleFonts.nunitoSans(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 14 / 11,
    color: AppColors.onSurface,
    letterSpacing: 0.3,
  );

  /// Verilen renk şemasına göre uyarlanmış Material 3 TextTheme üretir.
  static TextTheme createTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: GoogleFonts.nunitoSans(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 44 / 36,
        color: colorScheme.onSurface,
        letterSpacing: -0.5,
      ),
      headlineLarge: GoogleFonts.nunitoSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        color: colorScheme.onSurface,
        letterSpacing: -0.3,
      ),
      headlineMedium: GoogleFonts.nunitoSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 34 / 26,
        color: colorScheme.onSurface,
        letterSpacing: -0.2,
      ),
      headlineSmall: GoogleFonts.nunitoSans(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        height: 26 / 19,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 22 / 16,
        color: colorScheme.onSurface,
      ),
      bodyLarge: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: colorScheme.onSurface,
      ),
      bodyMedium: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: colorScheme.onSurfaceVariant,
      ),
      bodySmall: GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: colorScheme.onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.nunitoSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 14 / 11,
        color: colorScheme.onSurface,
        letterSpacing: 0.3,
      ),
    );
  }
}
