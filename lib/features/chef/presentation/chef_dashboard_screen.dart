import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import 'chef_provider.dart';

class ChefDashboardScreen extends ConsumerStatefulWidget {
  const ChefDashboardScreen({super.key});

  @override
  ConsumerState<ChefDashboardScreen> createState() => _ChefDashboardScreenState();
}

class _ChefDashboardScreenState extends ConsumerState<ChefDashboardScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.invalidate(chefDashboardProvider);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(chefAuthProvider);
    final dashboardAsync = ref.watch(chefDashboardProvider);

    if (!authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/chef/login');
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Chef Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              final notifier = ref.read(chefAuthProvider.notifier);
              await notifier.logout();
              if (mounted) context.go('/chef/login');
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(chefDashboardProvider);
          await ref.read(chefDashboardProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome header
              Text(
                'Welcome, ${authState.chefName ?? 'Chef'}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.s4),
              Text(
                'Here\'s your kitchen overview',
                style: Theme.of(context).textTheme.bodyMedium,
              ).animate().fadeIn(delay: 50.ms, duration: 300.ms),

              const SizedBox(height: AppSpacing.s24),

              // Stats cards
              dashboardAsync.when(
                data: (data) => Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Total Orders',
                        value: '${data.totalOrders}',
                        icon: Icons.receipt_long_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: _StatCard(
                        title: 'Preparing',
                        value: '${data.preparingOrders}',
                        icon: Icons.restaurant_rounded,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: _StatCard(
                        title: 'Ready',
                        value: '${data.readyOrders}',
                        icon: Icons.check_circle_outline_rounded,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                loading: () => Row(
                  children: List.generate(
                    3,
                    (_) => Expanded(
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppRadius.r16),
                        ),
                      ),
                    ),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: AppSpacing.s32),

              // Quick actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ).animate().fadeIn(delay: 150.ms, duration: 300.ms),
              const SizedBox(height: AppSpacing.s16),

              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      label: 'Incoming Orders',
                      icon: Icons.notifications_active_rounded,
                      color: AppColors.accent,
                      onTap: () => context.push('/chef/orders', extra: 0),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: _QuickAction(
                      label: 'Cooking',
                      icon: Icons.local_fire_department_rounded,
                      color: Colors.orange,
                      onTap: () => context.push('/chef/orders', extra: 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s12),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      label: 'Ready Queue',
                      icon: Icons.check_circle_rounded,
                      color: AppColors.success,
                      onTap: () => context.push('/chef/orders', extra: 2),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: _QuickAction(
                      label: 'Inventory',
                      icon: Icons.inventory_2_rounded,
                      color: AppColors.primary,
                      onTap: () => context.push('/chef/inventory'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
        boxShadow: AppShadows.premiumShadow(),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95));
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s20, horizontal: AppSpacing.s16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
          boxShadow: AppShadows.premiumShadow(),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms).scale(begin: const Offset(0.95, 0.95));
  }
}
