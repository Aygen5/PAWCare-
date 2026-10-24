import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_state.dart';
import '../../../core/widgets/paw_header_actions.dart';
import '../../../data/models/models.dart';
import '../../auth/cubit/role_cubit.dart';
import '../../pets/widgets/health_card_modal.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/chat_modal.dart';
import '../widgets/live_tracking_modal.dart';

/// Köpek Sahibi Ana Sayfası — Clean Architecture ve HomeCubit ile beslenir.
class OwnerHomeScreen extends StatelessWidget {
  final Function(SitterListing) onSitterSelected;
  final HomeCubit? cubit;

  const OwnerHomeScreen({
    super.key,
    required this.onSitterSelected,
    this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(
        value: cubit!,
        child: _OwnerHomeView(onSitterSelected: onSitterSelected),
      );
    }
    return BlocProvider(
      create: (_) => HomeCubit()..loadHomeData(),
      child: _OwnerHomeView(onSitterSelected: onSitterSelected),
    );
  }
}

class _OwnerHomeView extends StatefulWidget {
  final Function(SitterListing) onSitterSelected;

  const _OwnerHomeView({required this.onSitterSelected});

  @override
  State<_OwnerHomeView> createState() => _OwnerHomeViewState();
}

class _OwnerHomeViewState extends State<_OwnerHomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // Canlı yürüyüş nabız (pulse) animasyonu başlatılır
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, homeState) {
        // Aktif veriler HomeCubit'ten alınır, henüz hazır değilse yedek kullanılır
        final dog = homeState.dog ?? appState.currentDog;
        final sitters = homeState.featuredSitters.isNotEmpty
            ? homeState.featuredSitters
            : appState.sitters;
        final activeBooking = homeState.activeBooking;
        final upcomingVaccine = homeState.upcomingVaccine;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refresh(),
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Üst Başlık ve Eylemler
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Merhaba, Aygen 👋',
                                style: AppTypography.headlineScreen,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Bugün ${dog.name} için her şey yolunda!',
                                style: AppTypography.bodyDefault,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Rol Değiştirme Butonu (Hizmet Veren Moduna Geçiş)
                            InkWell(
                              onTap: () {
                                context.read<RoleCubit?>()?.switchToSitter();
                                appState.setRole(UserRole.sitter);
                                appState.setSitterNavIndex(0);
                                context.go(RoutePaths.sitterDashboard);
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.swap_horiz,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Hizmet Veren',
                                      style: AppTypography.labelTag.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Standart Profil ve Bildirim Başlık Aksiyonları
                            const PawHeaderActions(),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Köpek Hızlı Profil Kartı
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: AppColors.cardShadow,
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              dog.photoPath,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 72,
                                height: 72,
                                color: AppColors.surfaceContainerLow,
                                child: const Icon(
                                  Icons.pets,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      dog.name,
                                      style: AppTypography.titleCard,
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryContainer,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${dog.ageYears} Yaş',
                                        style: AppTypography.labelTag.copyWith(
                                          color: AppColors.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${dog.breed} • ${dog.weightKg} kg',
                                  style: AppTypography.caption,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          HealthCardModal.show(context),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceContainerLow,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppColors.outlineVariant
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.medical_services_outlined,
                                              size: 14,
                                              color: AppColors.primary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Sağlık Kartı',
                                              style: AppTypography.labelTag
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        appState.setOwnerNavIndex(2);
                                        context.go(RoutePaths.pets);
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceContainerLow,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppColors.outlineVariant
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                        child: Text(
                                          'Profili Gör',
                                          style: AppTypography.labelTag
                                              .copyWith(
                                                color: AppColors.primary,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Arama Çubuğu
                    TextField(
                      onChanged: (val) => appState.setSearchQuery(val),
                      onSubmitted: (_) {
                        appState.setOwnerNavIndex(1);
                        context.go(RoutePaths.explore);
                      },
                      decoration: InputDecoration(
                        hintText: 'Bakıcı, otel veya gezdirici ara...',
                        hintStyle: AppTypography.bodyDefault,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.secondary,
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceContainerLowest,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Popüler Hizmetler Kategorileri
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Popüler Hizmetler',
                            style: AppTypography.headlineSection,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            appState.setOwnerNavIndex(1);
                            context.go(RoutePaths.explore);
                          },
                          child: Text(
                            'Tümünü Gör',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryPill('Tümü', Icons.apps, appState),
                          const SizedBox(width: 8),
                          _buildCategoryPill(
                            'Köpek Oteli',
                            Icons.home_work_outlined,
                            appState,
                          ),
                          const SizedBox(width: 8),
                          _buildCategoryPill(
                            'Köpek Gezdirme',
                            Icons.directions_walk,
                            appState,
                          ),
                          const SizedBox(width: 8),
                          _buildCategoryPill(
                            'Gündüz Bakımı',
                            Icons.wb_sunny_outlined,
                            appState,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Yaklaşan Aşı Uyarısı Kartı
                    if (upcomingVaccine != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryFixed,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.accentWarm),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: AppColors.tertiaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.vaccines,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    spacing: 8,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        '${upcomingVaccine.title.split(' ').first} Aşı Zamanı!',
                                        style: AppTypography.titleCard.copyWith(
                                          color: AppColors.tertiary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.tertiaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '3 Gün Kaldı',
                                          style: AppTypography.labelTag
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${upcomingVaccine.dueDate} • ${upcomingVaccine.vetName} randevusu',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => HealthCardModal.show(context),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                              child: Text(
                                'Aşı Kartı',
                                style: AppTypography.labelTag.copyWith(
                                  color: AppColors.tertiary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                    ],

                    // Günün Rezervasyonu Kartı ve Nabız (Pulse) Animasyonu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Günün Rezervasyonu',
                            style: AppTypography.headlineSection,
                          ),
                        ),
                        if (activeBooking != null)
                          FadeTransition(
                            opacity: _pulseController,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    activeBooking.status ==
                                        BookingStatus.confirmed
                                    ? AppColors.successContainer
                                    : AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          activeBooking.status ==
                                              BookingStatus.confirmed
                                          ? AppColors.success
                                          : AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    activeBooking.status ==
                                            BookingStatus.confirmed
                                        ? 'Yürüyüşte • Canlı'
                                        : 'Onay Bekliyor',
                                    style: AppTypography.labelTag.copyWith(
                                      color:
                                          activeBooking.status ==
                                              BookingStatus.confirmed
                                          ? AppColors.success
                                          : AppColors.primary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Günün Rezervasyonu Kart Detayı
                    if (activeBooking != null) ...[
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: AppColors.cardShadow,
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: AssetImage(
                                    activeBooking.sitterPhoto,
                                  ),
                                  onBackgroundImageError: (_, _) {},
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              activeBooking.sitterName,
                                              style: AppTypography.titleCard,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Color(0xFFE5A823),
                                          ),
                                          Text(
                                            ' 5.0',
                                            style: AppTypography.labelTag,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        activeBooking.serviceTitle,
                                        style: AppTypography.caption,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${activeBooking.startDate.hour.toString().padLeft(2, '0')}:${activeBooking.startDate.minute.toString().padLeft(2, '0')} - ${activeBooking.endDate.hour.toString().padLeft(2, '0')}:${activeBooking.endDate.minute.toString().padLeft(2, '0')}',
                                    style: AppTypography.labelTag.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        LiveTrackingModal.show(context),
                                    icon: const Icon(
                                      Icons.navigation_outlined,
                                      size: 18,
                                    ),
                                    label: const Text('Canlı Takip'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.onPrimary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => ChatModal.show(
                                      context,
                                      sitterName: activeBooking.sitterName,
                                      avatarPath: activeBooking.sitterPhoto,
                                    ),
                                    icon: const Icon(
                                      Icons.chat_bubble_outline,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    label: Text(
                                      'Sohbet',
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Aktif rezervasyon yoksa gösterilecek zarif bilgilendirme kartı
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.event_available,
                              color: AppColors.primary,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Bugün için planlanmış bir rezervasyonunuz yok.',
                                style: AppTypography.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Öne Çıkan Hizmetler Listesi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Öne Çıkan Hizmetler',
                            style: AppTypography.headlineSection,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            appState.setOwnerNavIndex(1);
                            context.go(RoutePaths.explore);
                          },
                          child: Text(
                            'Hepsi',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sitters.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final s = sitters[index];
                        return InkWell(
                          onTap: () {
                            appState.selectSitter(s);
                            widget.onSitterSelected(s);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppColors.cardShadow,
                              border: Border.all(
                                color: AppColors.outlineVariant.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    s.imagePath,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      width: 80,
                                      height: 80,
                                      color: AppColors.surfaceContainerLow,
                                      child: const Icon(
                                        Icons.storefront,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              s.facilityTitle,
                                              style: AppTypography.titleCard,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.verified,
                                            size: 16,
                                            color: AppColors.primary,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${s.name} • ${s.location}',
                                        style: AppTypography.caption,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                size: 14,
                                                color: Color(0xFFE5A823),
                                              ),
                                              Text(
                                                ' ${s.rating} (${s.reviewsCount})',
                                                style: AppTypography.labelTag,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '₺${s.pricePerUnit.toInt()}/${s.unitLabel}',
                                            style: AppTypography.bodyMedium
                                                .copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryPill(String title, IconData icon, AppState state) {
    final isSelected = state.selectedCategory == title;
    return InkWell(
      onTap: () {
        state.setSelectedCategory(title);
        state.setOwnerNavIndex(1);
        context.go(RoutePaths.explore);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.secondary,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
