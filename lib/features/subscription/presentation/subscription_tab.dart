import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class SubscriptionTab extends ConsumerStatefulWidget {
  const SubscriptionTab({super.key});

  @override
  ConsumerState<SubscriptionTab> createState() => _SubscriptionTabState();
}

class _SubscriptionTabState extends ConsumerState<SubscriptionTab> {
  SubscriptionPlan? _activePlan = mockSubscriptionPlans.first;
  int _daysRemaining = 18;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ambo Subscriptions'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_activePlan != null) ...[
              _buildActivePlanCard(context),
              const SizedBox(height: AppSpacing.s32),
            ],
            Text(
              'Explore Subscription Plans',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              'Enjoy luxury home-cooked style meals daily with zero hassle and free priority delivery.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.s24),
            ...mockSubscriptionPlans.map((plan) => _buildPlanCard(context, plan)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlanCard(BuildContext context) {
    final progress = _daysRemaining / 30;
    return Card(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r20),
        side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      child: const Text('ACTIVE PLAN', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Text(_activePlan!.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
                Text('₹${_activePlan!.price.toStringAsFixed(0)}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900, fontSize: 20)),
              ],
            ),
            const SizedBox(height: AppSpacing.s20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Plan Progress', style: Theme.of(context).textTheme.bodySmall),
                Text('$_daysRemaining days remaining', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                color: Theme.of(context).colorScheme.primary,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: AppSpacing.s20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Plan Paused. You can resume anytime!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
                    ),
                    child: const Text('Pause Plan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Skipped tomorrow\'s delivery!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
                    ),
                    child: const Text('Skip Next Meal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, SubscriptionPlan plan) {
    final isActive = _activePlan?.id == plan.id;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s20),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(plan.description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppSpacing.s16),
            ...plan.benefits.map((benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Text(benefit, style: const TextStyle(fontSize: 13)),
                ],
              ),
            )),
            const SizedBox(height: AppSpacing.s20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₹${plan.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primary)),
                    Text('for ${plan.durationDays} Days', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                ElevatedButton(
                  onPressed: isActive ? null : () {
                    setState(() {
                      _activePlan = plan;
                      _daysRemaining = plan.durationDays;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully subscribed to ${plan.name}!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive ? Colors.grey : Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(isActive ? 'Subscribed' : 'Subscribe Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
