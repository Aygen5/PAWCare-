import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../utils/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Ekranların sağ üst köşesinde profil ve bildirim rozetini sunan standart eylem bileşeni.
class PawHeaderActions extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final bool showProfile;

  const PawHeaderActions({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
    this.showProfile = true,
  });

  void _handleNotificationTap(BuildContext context, AppState state) {
    if (onNotificationTap != null) {
      onNotificationTap!();
      return;
    }
    _showNotificationsBottomSheet(context, state);
  }

  void _handleProfileTap(BuildContext context, AppState state) {
    if (onProfileTap != null) {
      onProfileTap!();
      return;
    }
    state.setOwnerNavIndex(4);
    try {
      context.go(RoutePaths.profile);
    } catch (_) {
      // GoRouter bağlı değilse durum indeksi ile profil sekmesine geçilir.
    }
  }

  void _showNotificationsBottomSheet(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final notifications = state.notifications;

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.75,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst çekme çubuğu
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications_active,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text('Bildirimler', style: AppTypography.headlineSection),
                    ],
                  ),
                  if (notifications.any((n) => !n.isRead))
                    TextButton(
                      onPressed: () {
                        state.markAllNotificationsAsRead();
                        Navigator.of(ctx).pop();
                      },
                      child: Text(
                        'Tümünü Oku',
                        style: AppTypography.labelTag.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (notifications.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'Yeni bildiriminiz bulunmuyor.',
                      style: AppTypography.bodyDefault.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: notif.isRead
                              ? AppColors.surfaceContainerLow
                              : AppColors.secondaryContainer.withValues(
                                  alpha: 0.45,
                                ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: notif.isRead
                                ? AppColors.outlineVariant.withValues(
                                    alpha: 0.25,
                                  )
                                : AppColors.primary.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: notif.isRead
                                    ? AppColors.surfaceContainerHighest
                                    : AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.pets,
                                size: 16,
                                color: notif.isRead
                                    ? AppColors.onSurfaceVariant
                                    : AppColors.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notif.title,
                                    style: AppTypography.titleCard.copyWith(
                                      fontWeight: notif.isRead
                                          ? FontWeight.w600
                                          : FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    notif.body,
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final unreadCount = state.unreadNotificationCount;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bildirim ikonu ve okunmamış rozet
        InkWell(
          onTap: () => _handleNotificationTap(context, state),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
              ),
              boxShadow: AppColors.cardShadow,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  size: 20,
                  color: AppColors.secondary,
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (showProfile) ...[
          const SizedBox(width: 10),
          // Profil ikonu
          InkWell(
            onTap: () => _handleProfileTap(context, state),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.4),
                ),
                boxShadow: AppColors.cardShadow,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.person_outline,
                size: 22,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
