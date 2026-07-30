import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../cart/presentation/cart_provider.dart';
import 'home_tab.dart';
import '../../menu/presentation/menu_tab.dart';
import '../../subscription/presentation/subscription_tab.dart';
import '../../orders/presentation/orders_tab.dart';
import '../../profile/presentation/profile_tab.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const MenuTab(),
    const SubscriptionTab(),
    const OrdersTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _tabs,
          ),
          
          // Floating Cart Banner when items exist
          if (cartState.items.isNotEmpty)
            Positioned(
              left: AppSpacing.s16,
              right: AppSpacing.s16,
              bottom: kBottomNavigationBarHeight + AppSpacing.s32,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.r16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      boxShadow: AppShadows.premiumShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${cartState.items.fold(0, (sum, i) => sum + i.quantity)} Items • ₹${cartState.subtotal.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Text(
                              'Gourmet meals selected',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () => context.push('/cart'),
                          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                          label: const Text(
                            'View Cart',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.r12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .animate()
            .slideY(begin: 0.5, end: 0, duration: 400.ms, curve: Curves.easeOutBack)
            .fade(duration: 300.ms),
        ],
      ),
      
      // Bottom Glassmorphic Navigation Bar
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight + 16,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.borderLight
                  : AppColors.borderDark,
              width: 0.5,
            ),
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey,
              elevation: 0,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              unselectedLabelStyle: const TextStyle(fontSize: 11),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_outlined),
                  activeIcon: Icon(Icons.restaurant_rounded),
                  label: 'Menu',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_membership_outlined),
                  activeIcon: Icon(Icons.card_membership_rounded),
                  label: 'Subscription',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  activeIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
