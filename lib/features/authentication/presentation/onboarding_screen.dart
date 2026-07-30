import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Gourmet Kitchen\nAt Your Fingertips',
      description: 'Experience premium meals crafted by master chefs using organic, locally sourced fresh ingredients.',
      icon: Icons.restaurant_menu_rounded,
      gradient: [Color(0xFF0E7A46), Color(0xFF0B5C34)],
    ),
    OnboardingData(
      title: 'Flexible Plans,\nNo Committment',
      description: 'Choose weekly or monthly meal subscription plans. Pause, skip, or modify deliveries with absolute freedom.',
      icon: Icons.calendar_today_rounded,
      gradient: [Color(0xFFFF7A00), Color(0xFFE05300)],
    ),
    OnboardingData(
      title: 'Express Hot Delivery\nIn Sustainable Packaging',
      description: 'Delivered in premium thermal-insulated glass & starch boxes to keep your meal fresh, hot, and environment safe.',
      icon: Icons.delivery_dining_rounded,
      gradient: [Color(0xFF22C55E), Color(0xFF0E7A46)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s8),
                child: TextButton(
                  onPressed: () => context.go('/auth'),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.s32),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: page.gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: AppShadows.premiumShadow(color: page.gradient.first.withOpacity(0.2)),
                            ),
                            child: Icon(
                              page.icon,
                              size: 100,
                              color: Colors.white,
                            ),
                          )
                          .animate()
                          .scale(duration: 600.ms, curve: Curves.easeOutBack)
                          .rotate(duration: 600.ms, curve: Curves.easeOut),
                          
                          const SizedBox(height: AppSpacing.s48),
                          
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          )
                          .animate()
                          .fade(duration: 400.ms)
                          .slideY(begin: 0.2, end: 0, duration: 400.ms),
                          
                          const SizedBox(height: AppSpacing.s16),
                          
                          Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                          )
                          .animate()
                          .fade(delay: 150.ms, duration: 400.ms)
                          .slideY(begin: 0.2, end: 0, delay: 150.ms, duration: 400.ms),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32, vertical: AppSpacing.s24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(_pages.length, (index) {
                      final isSelected = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 6,
                        width: isSelected ? 24 : 6,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_currentIndex == _pages.length - 1) {
                        context.go('/auth');
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubic,
                        );
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.premiumShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Icon(
                        _currentIndex == _pages.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.keyboard_arrow_right_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
