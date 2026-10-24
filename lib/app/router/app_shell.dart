import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/paw_bottom_nav.dart';
import '../../core/widgets/paw_header_actions.dart';
import '../../data/models/models.dart';
import '../../core/utils/app_state.dart';
import '../../features/bookings/view/owner_bookings_screen.dart';
import '../../features/discovery/view/explore_screen.dart';
import '../../features/discovery/view/sitter_detail_screen.dart';
import '../../features/home/view/owner_home_screen.dart';
import '../../features/onboarding/view/welcome_screen.dart';
import '../../features/pets/view/dog_profile_screen.dart';
import '../../features/profile/view/profile_screen.dart';
import '../../features/provider/view/sitter_dashboard_screen.dart';

/// PawCare ana uygulama iskeleti; 480px mobil genişlik sınırı ve alt navigasyon barını barındırır.
class AppShell extends StatefulWidget {
  final Widget? child;
  final bool initialShowingWelcome;

  const AppShell({super.key, this.child, this.initialShowingWelcome = false});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late bool _showingWelcome;
  SitterListing? _activeDetailSitter;

  @override
  void initState() {
    super.initState();
    _showingWelcome = widget.initialShowingWelcome;
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget currentBody;
    if (_showingWelcome) {
      currentBody = WelcomeScreen(
        onContinue: () => setState(() => _showingWelcome = false),
      );
    } else if (_activeDetailSitter != null) {
      currentBody = SitterDetailScreen(
        sitter: _activeDetailSitter!,
        onBack: () => setState(() => _activeDetailSitter = null),
        onBookingCompleted: () {
          setState(() => _activeDetailSitter = null);
          state.setOwnerNavIndex(3);
        },
      );
    } else if (state.role == UserRole.sitter) {
      currentBody = _buildSitterTab(state.sitterNavIndex, context);
    } else if (widget.child != null) {
      currentBody = widget.child!;
    } else {
      currentBody = _buildOwnerTab(state.ownerNavIndex);
    }

    final showBottomNav =
        widget.child != null ||
        (!_showingWelcome && _activeDetailSitter == null);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121B15)
          : const Color(0xFFEFECE5),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.background,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 32,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Sayfa ana gövdesi
                Expanded(child: currentBody),
                // Alt gezinme çubuğu
                if (showBottomNav) const PawBottomNav(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerTab(int index) {
    switch (index) {
      case 0:
        return OwnerHomeScreen(
          onSitterSelected: (sitter) {
            setState(() => _activeDetailSitter = sitter);
          },
        );
      case 1:
        return ExploreScreen(
          onSitterSelected: (sitter) {
            setState(() => _activeDetailSitter = sitter);
          },
        );
      case 2:
        return const DogProfileScreen();
      case 3:
        return const OwnerBookingsScreen();
      case 4:
        return ProfileScreen(
          onLogout: () => setState(() => _showingWelcome = true),
        );
      default:
        return OwnerHomeScreen(
          onSitterSelected: (sitter) {
            setState(() => _activeDetailSitter = sitter);
          },
        );
    }
  }

  Widget _buildSitterTab(int index, BuildContext context) {
    switch (index) {
      case 0:
        return const SitterDashboardScreen();
      case 1:
        return _buildSitterListingTab(context);
      case 2:
        return _buildSitterCalendarTab(context);
      case 3:
        return _buildSitterReviewsTab(context);
      case 4:
        return ProfileScreen(
          onLogout: () => setState(() => _showingWelcome = true),
        );
      default:
        return const SitterDashboardScreen();
    }
  }

  /// Bakıcı — İlanım & Fiyatlarım Sekmesi
  Widget _buildSitterListingTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Başlık ve Rozetler
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'İlanım & Fiyatlarım',
                          style: AppTypography.headlineScreen,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${appState.sitterFacilityTitle} • ${appState.sitterLocation}',
                          style: AppTypography.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const PawHeaderActions(),
                ],
              ),
              const SizedBox(height: 16),

              // Yayın Durumu Rozeti
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkPrimaryContainer
                      : AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'İlanınız Aktif • Rezervasyon Talepleri Açık',
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? AppColors.darkOnPrimaryContainer
                              : AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tesis Tanıtım Kartı & Düzenleme
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkOutlineVariant
                        : AppColors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundImage: AssetImage('assets/images/ayse.jpg'),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ayşe Yılmaz',
                                style: AppTypography.titleCard,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Doğrulanmış Profesyonel Bakıcı 🐾',
                                style: AppTypography.caption.copyWith(
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9A825)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xFFF9A825),
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '4.9',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tesis Bilgisi',
                          style: AppTypography.titleCard.copyWith(fontSize: 14),
                        ),
                        TextButton.icon(
                          onPressed: () => _showEditFacilityDialog(
                            context,
                            appState,
                            isDark,
                          ),
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                          ),
                          label: Text(
                            'Düzenle',
                            style: AppTypography.caption.copyWith(
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appState.sitterBio,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Fiyatlandırma & Hizmet Yönetimi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hizmet Fiyatlandırması',
                    style: AppTypography.headlineSection,
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddServiceDialog(
                      context,
                      appState,
                      isDark,
                    ),
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 16,
                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                    label: Text(
                      'Hizmet Ekle',
                      style: AppTypography.caption.copyWith(
                        color:
                            isDark ? AppColors.darkPrimary : AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...appState.sitterServices.map(
                (srv) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildPriceCard(
                    service: srv,
                    isDark: isDark,
                    canDelete: appState.sitterServices.length > 1,
                    onEdit: () => _showEditServiceDialog(
                      context,
                      appState,
                      srv,
                      isDark,
                    ),
                    onDelete: () {
                      appState.removeSitterService(srv.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${srv.title} hizmeti kaldırıldı.'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Olanaklar Listesi & Yönetimi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tesis Olanakları',
                    style: AppTypography.headlineSection,
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddAmenityDialog(
                      context,
                      appState,
                      isDark,
                    ),
                    icon: Icon(
                      Icons.add,
                      size: 16,
                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                    label: Text(
                      'Olanak Ekle',
                      style: AppTypography.caption.copyWith(
                        color:
                            isDark ? AppColors.darkPrimary : AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: appState.sitterAmenities
                    .map(
                      (amenity) => _buildAmenityChip(
                        amenity,
                        isDark,
                        onRemove: () {
                          appState.removeSitterAmenity(amenity);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$amenity olanağı kaldırıldı.'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceCard({
    required SitterServiceItem service,
    required bool isDark,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required bool canDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceContainer
            : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.cardShadow,
        border: Border.all(
          color: isDark
              ? AppColors.darkOutlineVariant
              : AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkPrimaryContainer
                  : AppColors.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              service.icon,
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.title, style: AppTypography.titleCard),
                const SizedBox(height: 2),
                Text(service.description, style: AppTypography.caption),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₺${service.price}',
                style: AppTypography.titleCard.copyWith(
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(
                service.unit,
                style: AppTypography.caption.copyWith(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(width: 4),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              size: 18,
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.onSurfaceVariant,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            color: isDark
                ? AppColors.darkSurfaceContainerHigh
                : AppColors.surfaceContainerLowest,
            onSelected: (val) {
              if (val == 'edit') {
                onEdit();
              } else if (val == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text('Fiyatı / Hizmeti Düzenle'),
                  ],
                ),
              ),
              if (canDelete)
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: AppColors.error,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Hizmeti Kaldır',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(
    String label,
    bool isDark, {
    VoidCallback? onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceContainer
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkOutlineVariant
              : AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: isDark ? AppColors.darkPrimary : AppColors.primary,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 6),
            InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  Icons.close,
                  size: 12,
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Bakıcı — Müsaitlik Takvimi Sekmesi
  Widget _buildSitterCalendarTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Başlık ve Rozetler
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Müsaitlik Takvimi',
                          style: AppTypography.headlineScreen,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Ekim 2026 • Oda Kontenjan & Doluluk',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const PawHeaderActions(),
                ],
              ),
              const SizedBox(height: 16),

              // İstatistik Kartları (Kontenjan Güncelleme Tıklanabilir)
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Toplam Kapasite',
                      value: '${appState.totalSuites} Süit',
                      icon: Icons.domain,
                      isDark: isDark,
                      onTap: () => _showEditCapacityDialog(
                        context,
                        appState,
                        isDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Dolu Oda',
                      value: '${appState.occupiedSuites} Süit',
                      icon: Icons.pets,
                      isDark: isDark,
                      onTap: () => _showEditCapacityDialog(
                        context,
                        appState,
                        isDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Müsait',
                      value: '${appState.availableSuites} Süit',
                      icon: Icons.check_circle_outline,
                      isDark: isDark,
                      onTap: () => _showEditCapacityDialog(
                        context,
                        appState,
                        isDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Günlük Doluluk Durumu & Gün Ekleme
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Günlük Doluluk Durumu',
                    style: AppTypography.headlineSection,
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddCalendarDayDialog(
                      context,
                      appState,
                      isDark,
                    ),
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 16,
                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                    label: Text(
                      'Gün Ekle',
                      style: AppTypography.caption.copyWith(
                        color:
                            isDark ? AppColors.darkPrimary : AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...appState.sitterCalendarDays.map((day) {
                Color badgeColor;
                switch (day.statusType) {
                  case CalendarDayStatusType.full:
                    badgeColor = AppColors.error;
                    break;
                  case CalendarDayStatusType.limited:
                    badgeColor = const Color(0xFFF9A825);
                    break;
                  case CalendarDayStatusType.available:
                    badgeColor =
                        isDark ? AppColors.darkPrimary : AppColors.primary;
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildCalendarDayTile(
                    day: day.day,
                    month: day.month,
                    weekday: day.weekday,
                    status: day.status,
                    badgeColor: badgeColor,
                    details: day.details,
                    isDark: isDark,
                    onTap: () => _showEditDayDialog(
                      context,
                      appState,
                      day,
                      isDark,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceContainer
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
          border: Border.all(
            color: isDark
                ? AppColors.darkOutlineVariant
                : AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  size: 20,
                ),
                if (onTap != null)
                  Icon(
                    Icons.edit_outlined,
                    size: 13,
                    color: isDark
                        ? AppColors.darkOnSurfaceVariant
                        : AppColors.onSurfaceVariant,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: AppTypography.titleCard.copyWith(fontSize: 16)),
            const SizedBox(height: 2),
            Text(title, style: AppTypography.caption.copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarDayTile({
    required String day,
    required String month,
    required String weekday,
    required String status,
    required Color badgeColor,
    required String details,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    final effectiveBadgeColor = (isDark && badgeColor == AppColors.primary)
        ? AppColors.darkPrimary
        : badgeColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceContainer
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppColors.cardShadow,
          border: Border.all(
            color: isDark
                ? AppColors.darkOutlineVariant
                : AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkPrimaryContainer
                    : AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                  ),
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(weekday, style: AppTypography.titleCard),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: effectiveBadgeColor.withValues(
                                alpha: isDark ? 0.25 : 0.15,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: effectiveBadgeColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (onTap != null) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.edit_outlined,
                              size: 14,
                              color: isDark
                                  ? AppColors.darkOnSurfaceVariant
                                  : AppColors.onSurfaceVariant,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(details, style: AppTypography.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Hizmet Veren — Yönetim Modal ve Diyalogları
  // ==========================================

  void _showEditFacilityDialog(
    BuildContext context,
    AppState appState,
    bool isDark,
  ) {
    final titleCtrl = TextEditingController(text: appState.sitterFacilityTitle);
    final bioCtrl = TextEditingController(text: appState.sitterBio);
    final locCtrl = TextEditingController(text: appState.sitterLocation);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Tesis Bilgisini Düzenle',
          style: AppTypography.titleCard.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tesis Adı', style: AppTypography.caption),
              const SizedBox(height: 6),
              TextField(
                controller: titleCtrl,
                style: AppTypography.bodyDefault,
                decoration: InputDecoration(
                  hintText: 'Tesis adını girin',
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text('Konum', style: AppTypography.caption),
              const SizedBox(height: 6),
              TextField(
                controller: locCtrl,
                style: AppTypography.bodyDefault,
                decoration: InputDecoration(
                  hintText: 'Örn: Kadıköy, İstanbul',
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text('Tesis Tanıtımı & Bio', style: AppTypography.caption),
              const SizedBox(height: 6),
              TextField(
                controller: bioCtrl,
                maxLines: 3,
                style: AppTypography.bodyDefault,
                decoration: InputDecoration(
                  hintText: 'Tesis olanakları ve vizyonunuzu anlatın',
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'İptal',
              style: TextStyle(
                color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              appState.updateSitterFacilityInfo(
                facilityTitle: titleCtrl.text,
                bio: bioCtrl.text,
                location: locCtrl.text,
              );
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tesis bilgileri başarıyla güncellendi!'),
                  backgroundColor:
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? AppColors.darkPrimary : AppColors.primary,
              foregroundColor:
                  isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showEditServiceDialog(
    BuildContext context,
    AppState appState,
    SitterServiceItem service,
    bool isDark,
  ) {
    final titleCtrl = TextEditingController(text: service.title);
    final priceCtrl = TextEditingController(text: service.price.toString());
    final descCtrl = TextEditingController(text: service.description);
    String selectedUnit = service.unit;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkSurface : AppColors.surfaceContainerLowest,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Hizmet & Fiyat Düzenle',
            style: AppTypography.titleCard.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hizmet Adı', style: AppTypography.caption),
                const SizedBox(height: 6),
                TextField(
                  controller: titleCtrl,
                  style: AppTypography.bodyDefault,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurfaceContainer
                        : AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fiyat (₺)', style: AppTypography.caption),
                          const SizedBox(height: 6),
                          TextField(
                            controller: priceCtrl,
                            keyboardType: TextInputType.number,
                            style: AppTypography.bodyDefault,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.darkSurfaceContainer
                                  : AppColors.surfaceContainerLow,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Birim', style: AppTypography.caption),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceContainer
                                  : AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedUnit,
                                isExpanded: true,
                                dropdownColor: isDark
                                    ? AppColors.darkSurfaceContainer
                                    : AppColors.surfaceContainerLowest,
                                items: const [
                                  DropdownMenuItem(
                                    value: '/ gece',
                                    child: Text('/ gece'),
                                  ),
                                  DropdownMenuItem(
                                    value: '/ gün',
                                    child: Text('/ gün'),
                                  ),
                                  DropdownMenuItem(
                                    value: '/ saat',
                                    child: Text('/ saat'),
                                  ),
                                  DropdownMenuItem(
                                    value: '/ seans',
                                    child: Text('/ seans'),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setDialogState(() => selectedUnit = val);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('Açıklama', style: AppTypography.caption),
                const SizedBox(height: 6),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  style: AppTypography.bodyDefault,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurfaceContainer
                        : AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'İptal',
                style: TextStyle(
                  color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final p = int.tryParse(priceCtrl.text) ?? service.price;
                appState.updateSitterService(
                  service.id,
                  title: titleCtrl.text,
                  price: p,
                  unit: selectedUnit,
                  description: descCtrl.text,
                );
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${titleCtrl.text} fiyatı ₺$p $selectedUnit olarak güncellendi!',
                    ),
                    backgroundColor:
                        isDark ? AppColors.darkPrimary : AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? AppColors.darkPrimary : AppColors.primary,
                foregroundColor:
                    isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddServiceDialog(
    BuildContext context,
    AppState appState,
    bool isDark,
  ) {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '200');
    final descCtrl = TextEditingController();
    String selectedUnit = '/ gün';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkSurface : AppColors.surfaceContainerLowest,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Yeni Hizmet Ekle',
            style: AppTypography.titleCard.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hizmet Adı', style: AppTypography.caption),
                const SizedBox(height: 6),
                TextField(
                  controller: titleCtrl,
                  style: AppTypography.bodyDefault,
                  decoration: InputDecoration(
                    hintText: 'Örn: Özel Köpek Eğitimi & İtaat',
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurfaceContainer
                        : AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ücret (₺)', style: AppTypography.caption),
                          const SizedBox(height: 6),
                          TextField(
                            controller: priceCtrl,
                            keyboardType: TextInputType.number,
                            style: AppTypography.bodyDefault,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.darkSurfaceContainer
                                  : AppColors.surfaceContainerLow,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Birim', style: AppTypography.caption),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceContainer
                                  : AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedUnit,
                                isExpanded: true,
                                dropdownColor: isDark
                                    ? AppColors.darkSurfaceContainer
                                    : AppColors.surfaceContainerLowest,
                                items: const [
                                  DropdownMenuItem(
                                    value: '/ gece',
                                    child: Text('/ gece'),
                                  ),
                                  DropdownMenuItem(
                                    value: '/ gün',
                                    child: Text('/ gün'),
                                  ),
                                  DropdownMenuItem(
                                    value: '/ saat',
                                    child: Text('/ saat'),
                                  ),
                                  DropdownMenuItem(
                                    value: '/ seans',
                                    child: Text('/ seans'),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setDialogState(() => selectedUnit = val);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text('Hizmet Açıklaması', style: AppTypography.caption),
                const SizedBox(height: 6),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  style: AppTypography.bodyDefault,
                  decoration: InputDecoration(
                    hintText: 'Örn: Temel itaat ve sosyalleşme seansı',
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurfaceContainer
                        : AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'İptal',
                style: TextStyle(
                  color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                final p = int.tryParse(priceCtrl.text) ?? 200;
                appState.addSitterService(
                  SitterServiceItem(
                    id: 'srv_${DateTime.now().millisecondsSinceEpoch}',
                    title: titleCtrl.text.trim(),
                    price: p,
                    unit: selectedUnit,
                    description: descCtrl.text.trim().isEmpty
                        ? 'Standart bakım ve ilgi servisi'
                        : descCtrl.text.trim(),
                    icon: Icons.pets_outlined,
                  ),
                );
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${titleCtrl.text} hizmeti eklendi!'),
                    backgroundColor:
                        isDark ? AppColors.darkPrimary : AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? AppColors.darkPrimary : AppColors.primary,
                foregroundColor:
                    isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAmenityDialog(
    BuildContext context,
    AppState appState,
    bool isDark,
  ) {
    final amenityCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Yeni Tesis Olanağı Ekle',
          style: AppTypography.titleCard.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olanak Adı', style: AppTypography.caption),
            const SizedBox(height: 6),
            TextField(
              controller: amenityCtrl,
              style: AppTypography.bodyDefault,
              decoration: InputDecoration(
                hintText: 'Örn: Yerden Isıtmalı Zemin, Geniş Havuz',
                filled: true,
                fillColor: isDark
                    ? AppColors.darkSurfaceContainer
                    : AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'İptal',
              style: TextStyle(
                color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (amenityCtrl.text.trim().isNotEmpty) {
                appState.addSitterAmenity(amenityCtrl.text.trim());
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${amenityCtrl.text.trim()} olanağı eklendi!'),
                    backgroundColor:
                        isDark ? AppColors.darkPrimary : AppColors.primary,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? AppColors.darkPrimary : AppColors.primary,
              foregroundColor:
                  isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showEditDayDialog(
    BuildContext context,
    AppState appState,
    SitterCalendarDay day,
    bool isDark,
  ) {
    String selectedStatus = day.status;
    CalendarDayStatusType selectedType = day.statusType;
    final detailsCtrl = TextEditingController(text: day.details);

    final options = [
      ('Tamamen Müsait', CalendarDayStatusType.available),
      ('1 Oda Müsait', CalendarDayStatusType.limited),
      ('2 Oda Müsait', CalendarDayStatusType.limited),
      ('3 Oda Müsait', CalendarDayStatusType.available),
      ('Dolu (Tüm Odalar)', CalendarDayStatusType.full),
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkSurface : AppColors.surfaceContainerLowest,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            '${day.day} ${day.month} (${day.weekday}) Müsaitliği',
            style: AppTypography.titleCard.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Durum Seçin', style: AppTypography.caption),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((opt) {
                    final isSelected = selectedStatus == opt.$1;
                    return ChoiceChip(
                      label: Text(opt.$1),
                      selected: isSelected,
                      selectedColor: isDark
                          ? AppColors.darkPrimaryContainer
                          : AppColors.secondaryContainer,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? (isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary)
                            : (isDark
                                ? AppColors.darkOnSurface
                                : AppColors.onSurface),
                      ),
                      onSelected: (val) {
                        if (val) {
                          setDialogState(() {
                            selectedStatus = opt.$1;
                            selectedType = opt.$2;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('Rezervasyon / Not Detayı', style: AppTypography.caption),
                const SizedBox(height: 6),
                TextField(
                  controller: detailsCtrl,
                  maxLines: 2,
                  style: AppTypography.bodyDefault,
                  decoration: InputDecoration(
                    hintText: 'Misafir veya oda notlarını yazın',
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurfaceContainer
                        : AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'İptal',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                appState.updateCalendarDay(
                  day.id,
                  status: selectedStatus,
                  statusType: selectedType,
                  details: detailsCtrl.text.trim().isEmpty
                      ? 'Rezervasyon durumu güncellendi'
                      : detailsCtrl.text.trim(),
                );
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${day.day} ${day.month} müsaitlik durumu "$selectedStatus" olarak güncellendi!',
                    ),
                    backgroundColor:
                        isDark ? AppColors.darkPrimary : AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? AppColors.darkPrimary : AppColors.primary,
                foregroundColor:
                    isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Güncelle'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCalendarDayDialog(
    BuildContext context,
    AppState appState,
    bool isDark,
  ) {
    final dayCtrl = TextEditingController(text: '28');
    final weekdayCtrl = TextEditingController(text: 'Çarşamba');
    final detailsCtrl = TextEditingController(
      text: 'Tüm odalar için rezervasyon kabul ediliyor',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Takvime Gün Ekle',
          style: AppTypography.titleCard.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gün Numarası', style: AppTypography.caption),
              const SizedBox(height: 6),
              TextField(
                controller: dayCtrl,
                keyboardType: TextInputType.number,
                style: AppTypography.bodyDefault,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Gün Adı', style: AppTypography.caption),
              const SizedBox(height: 6),
              TextField(
                controller: weekdayCtrl,
                style: AppTypography.bodyDefault,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Durum Notu', style: AppTypography.caption),
              const SizedBox(height: 6),
              TextField(
                controller: detailsCtrl,
                style: AppTypography.bodyDefault,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'İptal',
              style: TextStyle(
                color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (dayCtrl.text.trim().isNotEmpty) {
                appState.addCalendarDay(
                  SitterCalendarDay(
                    id: 'cal_${DateTime.now().millisecondsSinceEpoch}',
                    day: dayCtrl.text.trim(),
                    month: 'Eki',
                    weekday: weekdayCtrl.text.trim(),
                    status: 'Tamamen Müsait',
                    statusType: CalendarDayStatusType.available,
                    details: detailsCtrl.text.trim(),
                  ),
                );
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${dayCtrl.text} Ekim (${weekdayCtrl.text}) takvime eklendi!',
                    ),
                    backgroundColor:
                        isDark ? AppColors.darkPrimary : AppColors.primary,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? AppColors.darkPrimary : AppColors.primary,
              foregroundColor:
                  isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showEditCapacityDialog(
    BuildContext context,
    AppState appState,
    bool isDark,
  ) {
    int total = appState.totalSuites;
    int occupied = appState.occupiedSuites;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final available = (total - occupied).clamp(0, total);
          return AlertDialog(
            backgroundColor: isDark
                ? AppColors.darkSurface
                : AppColors.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              'Oda Kontenjanını Güncelle',
              style: AppTypography.titleCard.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Toplam Süit Kapasitesi:',
                        style: AppTypography.bodyMedium),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: total > 1
                              ? () => setDialogState(() {
                                    total--;
                                    if (occupied > total) occupied = total;
                                  })
                              : null,
                        ),
                        Text('$total',
                            style: AppTypography.headlineSection
                                .copyWith(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setDialogState(() => total++),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dolu Süit Sayısı:',
                        style: AppTypography.bodyMedium),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: occupied > 0
                              ? () => setDialogState(() => occupied--)
                              : null,
                        ),
                        Text('$occupied',
                            style: AppTypography.headlineSection
                                .copyWith(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: occupied < total
                              ? () => setDialogState(() => occupied++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kalan Müsait Oda:',
                        style: AppTypography.bodyMedium
                            .copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      '$available Süit',
                      style: AppTypography.headlineSection.copyWith(
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'İptal',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkOnSurfaceVariant
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  appState.updateSuitesCapacity(
                    total: total,
                    occupied: occupied,
                    available: available,
                  );
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Oda kontenjanları güncellendi!'),
                      backgroundColor:
                          isDark ? AppColors.darkPrimary : AppColors.primary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? AppColors.darkPrimary : AppColors.primary,
                  foregroundColor:
                      isDark ? AppColors.darkOnPrimary : AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Güncelle'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Bakıcı — Değerlendirmeler & Puanlar Sekmesi
  Widget _buildSitterReviewsTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Başlık ve Rozetler
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Değerlendirmelerim',
                          style: AppTypography.headlineScreen,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '128 Köpek Sahibinin Gerçek Deneyimi',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const PawHeaderActions(),
                ],
              ),
              const SizedBox(height: 16),

              // Puan Özeti Kahraman Kartı
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceContainer
                      : AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: AppColors.cardShadow,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkOutlineVariant
                        : AppColors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          '4.9',
                          style: AppTypography.headlineHero.copyWith(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Color(0xFFF9A825),
                              size: 18,
                            ),
                            Icon(
                              Icons.star,
                              color: Color(0xFFF9A825),
                              size: 18,
                            ),
                            Icon(
                              Icons.star,
                              color: Color(0xFFF9A825),
                              size: 18,
                            ),
                            Icon(
                              Icons.star,
                              color: Color(0xFFF9A825),
                              size: 18,
                            ),
                            Icon(
                              Icons.star,
                              color: Color(0xFFF9A825),
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('128 Yorum', style: AppTypography.caption),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRatingBar('Güvenilirlik', 0.99, '5.0', isDark),
                          const SizedBox(height: 6),
                          _buildRatingBar(
                            'İletişim & Şeffaflık',
                            0.98,
                            '4.9',
                            isDark,
                          ),
                          const SizedBox(height: 6),
                          _buildRatingBar(
                            'Tesis & Temizlik',
                            0.96,
                            '4.9',
                            isDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Son Değerlendirmeler',
                style: AppTypography.headlineSection,
              ),
              const SizedBox(height: 12),

              _buildReviewCard(
                authorName: 'Aygen Yıldırım',
                dogName: 'Barley (Golden Retriever)',
                timeAgo: '2 gün önce',
                rating: 5.0,
                comment: 'Ayşe Hanım harika bir bakıcı! Barley oteldeyken her gün düzenli fotoğraf ve video paylaştı. Gözüm hiç arkada kalmadı, kesinlikle tavsiye ediyorum.',
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildReviewCard(
                authorName: 'Selin Aksoy',
                dogName: 'Maya (Toy Poodle)',
                timeAgo: '1 hafta önce',
                rating: 5.0,
                comment: 'Tertemiz bir ortam, geniş bahçe alanı ve çok ilgili yaklaşım. Maya eve dönerken neredeyse ayrılmak istemedi!',
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildReviewCard(
                authorName: 'Emre Kaya',
                dogName: 'Max (Beagle)',
                timeAgo: '2 hafta önce',
                rating: 4.8,
                comment: 'İletişim çok hızlı ve detaylıydı. Güler yüzlü ve işini severek yapan bir bakıcı. Teşekkürler Ayşe Hanım.',
                isDark: isDark,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBar(
    String label,
    double ratio,
    String score,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.caption.copyWith(fontSize: 11)),
            Text(
              score,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 3),
        LinearProgressIndicator(
          value: ratio,
          backgroundColor: isDark
              ? AppColors.darkSurfaceContainerLow
              : AppColors.surfaceContainerLow,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          borderRadius: BorderRadius.circular(4),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String authorName,
    required String dogName,
    required String timeAgo,
    required double rating,
    required String comment,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceContainer
            : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.cardShadow,
        border: Border.all(
          color: isDark
              ? AppColors.darkOutlineVariant
              : AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(authorName, style: AppTypography.titleCard),
                  const SizedBox(height: 2),
                  Text(
                    dogName,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFF9A825),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeAgo,
                    style: AppTypography.caption.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment, style: AppTypography.bodyDefault),
        ],
      ),
    );
  }
}
