import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../presentation/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom drawn premium logo to avoid asset dependency
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            )
            .animate()
            .fade(duration: 800.ms)
            .scale(delay: 200.ms, duration: 800.ms, curve: Curves.easeOutBack),
            
            const SizedBox(height: AppSpacing.s24),
            
            Text(
              'Parabdi',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            )
            .animate()
            .fade(delay: 600.ms, duration: 800.ms)
            .slideY(begin: 0.3, end: 0, delay: 600.ms, curve: Curves.easeOutQuad),
            
            const SizedBox(height: AppSpacing.s8),
            
            Text(
              'PURE • FRESH • PREMIUM',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                letterSpacing: 4.0,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            )
            .animate()
            .fade(delay: 1000.ms, duration: 800.ms),
            
            const SizedBox(height: AppSpacing.s48),
            
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
              ),
            )
            .animate()
            .fade(delay: 1200.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
