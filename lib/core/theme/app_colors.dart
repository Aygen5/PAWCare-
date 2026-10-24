import 'package:flutter/material.dart';

/// PawCare tasarım sistemi açık ve koyu tema renk paleti.
class AppColors {
  // Açık Tema — Yüzey ve Arka Planlar
  static const Color surface = Color(0xFFFBF9F3);
  static const Color background = Color(0xFFF7F5EF);
  static const Color surfaceDim = Color(0xFFDCDAD4);
  static const Color surfaceBright = Color(0xFFFBF9F3);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF5F3ED);
  static const Color surfaceContainer = Color(0xFFF0EEE8);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E2);
  static const Color surfaceContainerHighest = Color(0xFFE4E2DD);

  // Açık Tema — Metin ve Yüzey Üzeri
  static const Color onSurface = Color(0xFF1B1C18);
  static const Color onSurfaceVariant = Color(0xFF434843);
  static const Color textMain = Color(0xFF292F29);
  static const Color inverseSurface = Color(0xFF30312D);
  static const Color inverseOnSurface = Color(0xFFF3F1EB);

  // Açık Tema — Anahat ve Sınırlar
  static const Color outline = Color(0xFF737872);
  static const Color outlineVariant = Color(0xFFC3C8C1);
  static const Color surfaceTint = Color(0xFF506354);

  // Açık Tema — Birincil (Koyu Orman / Zeytin)
  static const Color primary = Color(0xFF1E3023);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF344638);
  static const Color onPrimaryContainer = Color(0xFF9FB3A1);
  static const Color inversePrimary = Color(0xFFB7CCB9);
  static const Color primaryFixed = Color(0xFFD3E8D5);

  // Açık Tema — İkincil (Adaçayı)
  static const Color secondary = Color(0xFF586156);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFDCE5D7);
  static const Color onSecondaryContainer = Color(0xFF5E675C);
  static const Color secondaryFixed = Color(0xFFDCE5D7);

  // Açık Tema — Üçüncül (Sıcak Kum / Amber)
  static const Color tertiary = Color(0xFF3B2811);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF533E25);
  static const Color onTertiaryContainer = Color(0xFFC7A98A);
  static const Color tertiaryFixed = Color(0xFFFEDDBB);
  static const Color accentWarm = Color(0xFFE9C9A8);
  static const Color accentBeige = Color(0xFFE9DCD2);

  // Açık Tema — Hata ve Durum
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color success = Color(0xFF2E6930);
  static const Color successContainer = Color(0xFFD8F3DC);

  // Koyu Tema (Haki / Koyu Zeytin) — Saf siyah (#000000) kullanılmaz
  static const Color darkBackground = Color(0xFF16241A);
  static const Color darkSurface = Color(0xFF1E3023);
  static const Color darkSurfaceDim = Color(0xFF131E16);
  static const Color darkSurfaceBright = Color(0xFF243628);
  static const Color darkSurfaceContainerLowest = Color(0xFF18261C);
  static const Color darkSurfaceContainerLow = Color(0xFF1E3023);
  static const Color darkSurfaceContainer = Color(0xFF243628);
  static const Color darkSurfaceContainerHigh = Color(0xFF304334);
  static const Color darkSurfaceContainerHighest = Color(0xFF344638);

  static const Color darkOnSurface = Color(0xFFEAE8E2);
  static const Color darkOnSurfaceVariant = Color(0xFFDCE5D7);
  static const Color darkTextMain = Color(0xFFEAE8E2);

  static const Color darkOutline = Color(0xFF506354);
  static const Color darkOutlineVariant = Color(0xFF344638);

  static const Color darkPrimary = Color(0xFF9FB3A1);
  static const Color darkOnPrimary = Color(0xFF16241A);
  static const Color darkPrimaryContainer = Color(0xFF344638);
  static const Color darkOnPrimaryContainer = Color(0xFFDCE5D7);

  static const Color darkSecondary = Color(0xFFB7CCB9);
  static const Color darkOnSecondary = Color(0xFF1E3023);
  static const Color darkSecondaryContainer = Color(0xFF2E4032);
  static const Color darkOnSecondaryContainer = Color(0xFFDCE5D7);

  static const Color darkTertiary = Color(0xFFE1C1A0);
  static const Color darkOnTertiary = Color(0xFF291804);
  static const Color darkTertiaryContainer = Color(0xFF533E25);
  static const Color darkOnTertiaryContainer = Color(0xFFFEDDBB);

  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);

  // Gölgeler — Açık tema
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0D344638),
      blurRadius: 20,
      offset: Offset(0, 4),
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Color(0x14292F29),
      blurRadius: 30,
      offset: Offset(0, 10),
      spreadRadius: -4,
    ),
  ];

  static const List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Color(0x081B1C18),
      blurRadius: 12,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  // Gölgeler — Koyu tema (yeşilimsi derinlik)
  static const List<BoxShadow> darkCardShadow = [
    BoxShadow(
      color: Color(0x330D1710),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: -2,
    ),
  ];
}
