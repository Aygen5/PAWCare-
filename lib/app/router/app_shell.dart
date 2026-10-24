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
        return ProfileScreen(
          onLogout: () => setState(() => _showingWelcome = true),
        );
      default:
        return const SitterDashboardScreen();
    }
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
