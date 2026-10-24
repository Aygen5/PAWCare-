import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../cubit/splash_cubit.dart';

/// Ölçülü büyüme ve parıltı animasyonuna sahip PawCare karşılama ekranı.
class SplashPage extends StatefulWidget {
  final void Function(bool hasSeenOnboarding)? onReady;

  const SplashPage({super.key, this.onReady});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Giriş ve parıltı animasyon kontrolcüsü
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _controller.forward();

    // Başlangıç verilerini hazırlama sürecini başlatır
    context.read<SplashCubit>().initializeApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashReady) {
          widget.onReady?.call(state.hasSeenOnboarding);
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Parıltılı pati logosu alanı
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Arka plandaki ölçülü parıltı halkası
                          Transform.scale(
                            scale: _glowAnimation.value,
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    (isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.secondaryContainer)
                                        .withValues(alpha: 0.25),
                              ),
                            ),
                          ),
                          // Ana pati logo kartı
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkPrimaryContainer
                                  : AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: isDark
                                  ? AppColors.darkCardShadow
                                  : AppColors.cardShadow,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.pets,
                                size: 44,
                                color: AppColors.accentWarm,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),

              // PawCare tipografik marka başlığı
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'PawCare',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Evcil Hayvan Bakımında Güven & Sevgi',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Minimal yükleme göstergesi
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? AppColors.darkPrimary : AppColors.primary,
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
}
