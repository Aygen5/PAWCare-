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
                          'Mutlu Patiler Butik Köpek Oteli • Kadıköy',
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

              // Tesis Tanıtım Kartı
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
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
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
                    Text(
                      'Tesis Bilgisi',
                      style: AppTypography.titleCard.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '600 m² geniş çim bahçe, klimalı süit odalar, 7/24 kamera takibi ve veteriner anlaşmalı güvenli butik köpek oteli.',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Fiyatlandırma Tablosu
              Text(
                'Hizmet Fiyatlandırması',
                style: AppTypography.headlineSection,
              ),
              const SizedBox(height: 12),
              _buildPriceCard(
                title: 'Butik Köpek Oteli Konaklama',
                price: '₺450',
                unit: '/ gece',
                description:
                    'Özel süit oda, günde 3 yürüyüş, 7/24 kamera takibi',
                icon: Icons.hotel_outlined,
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildPriceCard(
                title: 'Gündüz Kreşi & Sosyalleşme',
                price: '₺300',
                unit: '/ gün',
                description: 'Sabah 08:30 - Akşam 19:00 arası bahçe oyunları',
                icon: Icons.wb_sunny_outlined,
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildPriceCard(
                title: 'Bireysel Yürüyüş & Egzersiz',
                price: '₺180',
                unit: '/ saat',
                description: 'Sahil parkı tempolu yürüyüş ve su molası',
                icon: Icons.directions_walk_outlined,
                isDark: isDark,
              ),
              const SizedBox(height: 20),

              // Olanaklar Listesi
              Text('Tesis Olanakları', style: AppTypography.headlineSection),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildAmenityChip('600 m² Çitli Bahçe', isDark),
                  _buildAmenityChip('7/24 Kamera İzleme', isDark),
                  _buildAmenityChip('Acil Veteriner Protokolü', isDark),
                  _buildAmenityChip('Klimalı Süit Odalar', isDark),
                  _buildAmenityChip('Özel Diyet & Alerji Yönetimi', isDark),
                  _buildAmenityChip('Günlük Foto & Video Paylaşımı', isDark),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceCard({
    required String title,
    required String price,
    required String unit,
    required String description,
    required IconData icon,
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
              icon,
              color: isDark ? AppColors.darkPrimary : AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleCard),
                const SizedBox(height: 2),
                Text(description, style: AppTypography.caption),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: AppTypography.titleCard.copyWith(
                  color: isDark ? AppColors.darkPrimary : AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(unit, style: AppTypography.caption.copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(String label, bool isDark) {
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
          const Icon(Icons.check_circle, color: AppColors.primary, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// Bakıcı — Müsaitlik Takvimi Sekmesi
  Widget _buildSitterCalendarTab(BuildContext context) {
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

              // İstatistik Kartları
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Toplam Kapasite',
                      value: '6 Süit',
                      icon: Icons.domain,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Dolu Oda',
                      value: '5 Süit',
                      icon: Icons.pets,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Müsait',
                      value: '1 Süit',
                      icon: Icons.check_circle_outline,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                'Günlük Doluluk Durumu',
                style: AppTypography.headlineSection,
              ),
              const SizedBox(height: 12),

              _buildCalendarDayTile(
                day: '24',
                month: 'Eki',
                weekday: 'Bugün',
                status: 'Dolu (3 Misafir)',
                badgeColor: AppColors.error,
                details: 'Barley (Süit 3) • Luna (Süit 1) • Çakıl (Süit 2)',
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildCalendarDayTile(
                day: '25',
                month: 'Eki',
                weekday: 'Pazar',
                status: '1 Oda Müsait',
                badgeColor: const Color(0xFFF9A825),
                details: 'Barley (Konaklama devam) • Luna (Süit 1)',
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildCalendarDayTile(
                day: '26',
                month: 'Eki',
                weekday: 'Pazartesi',
                status: '3 Oda Müsait',
                badgeColor: AppColors.primary,
                details: 'Luna öğleden sonra çıkış yapacak',
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildCalendarDayTile(
                day: '27',
                month: 'Eki',
                weekday: 'Salı',
                status: 'Tamamen Müsait',
                badgeColor: AppColors.primary,
                details: 'Tüm süitler için rezervasyon kabul ediliyor',
                isDark: isDark,
              ),
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
  }) {
    return Container(
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
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.titleCard.copyWith(fontSize: 16)),
          const SizedBox(height: 2),
          Text(title, style: AppTypography.caption.copyWith(fontSize: 11)),
        ],
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
  }) {
    return Container(
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
