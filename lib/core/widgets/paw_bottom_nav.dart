import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../data/models/models.dart';
import '../../features/auth/cubit/role_cubit.dart';
import '../utils/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// PawCare rol bazlı ve GoRouter ile senkronize alt gezinme çubuğu.
class PawBottomNav extends StatelessWidget {
  const PawBottomNav({super.key});

  int _calculateCurrentIndex(
    BuildContext context,
    AppState state,
    bool isOwner,
  ) {
    try {
      final location = GoRouterState.of(context).uri.path;
      if (isOwner) {
        if (location.startsWith(RoutePaths.explore)) return 1;
        if (location.startsWith(RoutePaths.pets)) return 2;
        if (location.startsWith(RoutePaths.bookings)) return 3;
        if (location.startsWith(RoutePaths.profile)) return 4;
        if (location.startsWith(RoutePaths.home)) return 0;
      } else {
        if (location.startsWith(RoutePaths.sitterDashboard)) return 0;
      }
    } catch (_) {
      // GoRouter henüz bağlı değilse durum indeksi kullanılır.
    }
    return isOwner ? state.ownerNavIndex : state.sitterNavIndex;
  }

  void _onItemTapped(
    BuildContext context,
    AppState state,
    bool isOwner,
    int index,
  ) {
    if (isOwner) {
      state.setOwnerNavIndex(index);
      switch (index) {
        case 0:
          context.go(RoutePaths.home);
          break;
        case 1:
          context.go(RoutePaths.explore);
          break;
        case 2:
          context.go(RoutePaths.pets);
          break;
        case 3:
          context.go(RoutePaths.bookings);
          break;
        case 4:
          context.go(RoutePaths.profile);
          break;
      }
    } else {
      state.setSitterNavIndex(index);
      if (index == 0) {
        context.go(RoutePaths.sitterDashboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final activeRole = context.watch<RoleCubit?>()?.state ?? state.role;
    final isOwner = activeRole == UserRole.owner;
    final currentIndex = _calculateCurrentIndex(context, state, isOwner);

    final ownerItems = const [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Ana Sayfa',
      ),
      _NavItem(
        icon: Icons.explore_outlined,
        activeIcon: Icons.explore,
        label: 'Keşfet',
      ),
      _NavItem(
        icon: Icons.pets_outlined,
        activeIcon: Icons.pets,
        label: 'Köpeklerim',
      ),
      _NavItem(
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_month,
        label: 'Taleplerim',
      ),
      _NavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profil',
      ),
    ];

    final sitterItems = const [
      _NavItem(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        label: 'Panel',
      ),
      _NavItem(
        icon: Icons.storefront_outlined,
        activeIcon: Icons.storefront,
        label: 'İlanım',
      ),
      _NavItem(
        icon: Icons.calendar_month_outlined,
        activeIcon: Icons.calendar_month,
        label: 'Takvim',
      ),
      _NavItem(
        icon: Icons.star_outline,
        activeIcon: Icons.star,
        label: 'Yorumlar',
      ),
      _NavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profil',
      ),
    ];

    final items = isOwner ? ownerItems : sitterItems;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color:
            isDark
                ? AppColors.darkSurfaceContainerLowest
                : AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(
            color:
                isDark
                    ? AppColors.darkOutlineVariant.withValues(alpha: 0.6)
                    : AppColors.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        boxShadow:
            isDark
                ? AppColors.darkCardShadow
                : const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;

              final activeItemColor =
                  isDark ? AppColors.darkPrimary : AppColors.primary;
              final inactiveItemColor =
                  isDark
                      ? AppColors.darkOnSurfaceVariant
                      : AppColors.onSurfaceVariant;
              final activeContainerColor =
                  isDark
                      ? AppColors.darkPrimaryContainer
                      : AppColors.secondaryContainer;

              return Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(context, state, isOwner, index),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? activeContainerColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected ? activeItemColor : inactiveItemColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: AppTypography.labelTag.copyWith(
                          color:
                              isSelected ? activeItemColor : inactiveItemColor,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
