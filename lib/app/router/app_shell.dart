import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/paw_bottom_nav.dart';
import '../../data/models/models.dart';
import '../../core/utils/app_state.dart';
import '../../features/bookings/view/owner_bookings_screen.dart';
import '../../features/discovery/view/explore_screen.dart';
import '../../features/discovery/view/sitter_detail_screen.dart';
import '../../features/home/view/owner_home_screen.dart';
import '../../features/onboarding/view/welcome_screen.dart';
import '../../features/pets/view/dog_profile_screen.dart';
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

    // GoRouter tarafından iletilen bir child varsa doğrudan onu kullanır.
    Widget currentBody;
    if (widget.child != null) {
      currentBody = widget.child!;
    } else if (_showingWelcome) {
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
      currentBody = _buildSitterTab(state.sitterNavIndex);
    } else {
      currentBody = _buildOwnerTab(state.ownerNavIndex);
    }

    final showBottomNav =
        widget.child != null ||
        (!_showingWelcome && _activeDetailSitter == null);

    return Scaffold(
      backgroundColor: const Color(0xFFEFECE5),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              boxShadow: [
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
        return _buildOwnerProfileTab();
      default:
        return OwnerHomeScreen(
          onSitterSelected: (sitter) {
            setState(() => _activeDetailSitter = sitter);
          },
        );
    }
  }

  Widget _buildSitterTab(int index) {
    switch (index) {
      case 0:
        return const SitterDashboardScreen();
      case 1:
        return _buildPlaceholderTab(
          'İlanım & Fiyatlarım',
          'İlan fotoğrafları, gecelik ve saatlik fiyatlandırma ayarları.',
        );
      case 2:
        return _buildPlaceholderTab(
          'Müsaitlik Takvimi',
          'Müsait günler, oda kontenjanları ve tatil tarihleri.',
        );
      case 3:
        return _buildPlaceholderTab(
          'Değerlendirmeler',
          'Köpek sahiplerinin bıraktığı puanlar ve yorumlar.',
        );
      case 4:
        return _buildPlaceholderTab(
          'Hizmet Veren Profili',
          'Kimlik doğrulamaları, sertifikalar ve banka hesap bilgileri.',
        );
      default:
        return const SitterDashboardScreen();
    }
  }



  Widget _buildOwnerProfileTab() {
    final state = AppStateScope.of(context);
    final dog = state.currentDog;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hesap & Profil', style: AppTypography.headlineScreen),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.secondaryContainer,
                      child: Icon(
                        Icons.person,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aygen Y.',
                            style: AppTypography.headlineSection,
                          ),
                          Text(
                            'aygen@pawcare.com',
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Köpek Sahibi (1 Kayıtlı Köpek: ${dog.name})',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Ayarlar & Tercihler', style: AppTypography.headlineSection),
              const SizedBox(height: 12),
              _buildSettingTile(
                Icons.notifications_outlined,
                'Bildirim Tercihleri',
              ),
              const SizedBox(height: 8),
              _buildSettingTile(Icons.credit_card_outlined, 'Ödeme Yöntemleri'),
              const SizedBox(height: 8),
              _buildSettingTile(Icons.security_outlined, 'Gizlilik & Güvenlik'),
              const SizedBox(height: 8),
              _buildSettingTile(Icons.help_outline, 'Yardım & Destek'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _showingWelcome = true);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Çıkış Yap / Rol Değiştir',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTypography.bodyMedium)),
          const Icon(
            Icons.chevron_right,
            color: AppColors.onSurfaceVariant,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String title, String description) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.headlineScreen),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.tune, color: AppColors.primary, size: 40),
                    const SizedBox(height: 12),
                    Text(title, style: AppTypography.titleCard),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: AppTypography.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
