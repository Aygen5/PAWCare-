import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_cubit.dart';
import '../cubit/profile_cubit.dart';

/// Açık Tema / Koyu Yeşil (Haki) Seçici Kartı — Faz 5 Adım 5.2.
class ThemeSelectorCard extends StatelessWidget {
  const ThemeSelectorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Aktif ThemeMode'u ThemeCubit'ten dinle
    final currentThemeMode =
        context.watch<ThemeCubit?>()?.state ?? ThemeMode.system;

    final cardBg =
        isDark
            ? AppColors.darkSurfaceContainerLow
            : AppColors.surfaceContainerLowest;
    final borderColor =
        isDark
            ? AppColors.darkOutlineVariant
            : AppColors.outlineVariant.withValues(alpha: 0.35);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: isDark ? AppColors.darkCardShadow : AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? AppColors.darkPrimaryContainer
                          : AppColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.palette_outlined,
                  size: 20,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Görünüm ve Tema',
                      style: AppTypography.headlineSection.copyWith(
                        color:
                            isDark
                                ? AppColors.darkOnSurface
                                : AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Açık veya göz yormayan özel haki koyu tema',
                      style: AppTypography.caption.copyWith(
                        color:
                            isDark
                                ? AppColors.darkOnSurfaceVariant
                                : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3 Seçenekli Segmented Toggle: Açık, Koyu (Haki), Sistem
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? AppColors.darkSurfaceContainerLowest
                      : AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _buildSegmentItem(
                  context: context,
                  mode: ThemeMode.light,
                  label: 'Açık',
                  icon: Icons.light_mode_outlined,
                  activeIcon: Icons.light_mode,
                  isSelected: currentThemeMode == ThemeMode.light,
                  isDark: isDark,
                ),
                _buildSegmentItem(
                  context: context,
                  mode: ThemeMode.dark,
                  label: 'Koyu Haki',
                  icon: Icons.dark_mode_outlined,
                  activeIcon: Icons.dark_mode,
                  isSelected: currentThemeMode == ThemeMode.dark,
                  isDark: isDark,
                ),
                _buildSegmentItem(
                  context: context,
                  mode: ThemeMode.system,
                  label: 'Sistem',
                  icon: Icons.brightness_auto_outlined,
                  activeIcon: Icons.brightness_auto,
                  isSelected: currentThemeMode == ThemeMode.system,
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Bilgilendirme Notu
          Row(
            children: [
              Icon(
                Icons.nature_people_outlined,
                size: 14,
                color:
                    isDark
                        ? AppColors.darkPrimary
                        : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'PawCare koyu modu saf siyah (#000000) değil, sakinleştirici zeytin ve haki tonlarındadır.',
                  style: AppTypography.caption.copyWith(
                    fontSize: 11,
                    color:
                        isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentItem({
    required BuildContext context,
    required ThemeMode mode,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required bool isSelected,
    required bool isDark,
  }) {
    final activeBg =
        isDark
            ? AppColors.darkPrimaryContainer
            : AppColors.surfaceContainerLowest;
    final activeTextColor =
        isDark ? AppColors.darkOnPrimaryContainer : AppColors.primary;
    final inactiveTextColor =
        isDark ? AppColors.darkOnSurfaceVariant : AppColors.onSurfaceVariant;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // ThemeCubit üzerinden tüm uygulamada anında temayı değiştir
          context.read<ThemeCubit?>()?.setThemeMode(mode);
          context.read<ProfileCubit?>()?.setThemeMode(mode);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 16,
                color: isSelected ? activeTextColor : inactiveTextColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeTextColor : inactiveTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
