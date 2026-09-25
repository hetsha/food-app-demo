import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart' hide SubscriptionPlan;
import '../../../core/theme/app_theme.dart';
import '../data/models/subscription.dart';
import 'subscription_provider.dart';

class SubscriptionDetailScreen extends ConsumerStatefulWidget {
  final SubscriptionPlan plan;

  const SubscriptionDetailScreen({super.key, required this.plan});

  @override
  ConsumerState<SubscriptionDetailScreen> createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState
    extends ConsumerState<SubscriptionDetailScreen> {
  bool _isSubscribing = false;

  Future<void> _handleSubscribe() async {
    setState(() => _isSubscribing = true);
    final success = await ref
        .read(subscriptionNotifierProvider.notifier)
        .subscribe(widget.plan.id);
    if (!mounted) return;
    setState(() => _isSubscribing = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subscribed successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    } else {
      final error = ref.read(subscriptionNotifierProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Subscription failed. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final state = ref.watch(subscriptionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.r16),
              child: Container(
                width: double.infinity,
                height: 200,
                color: AppColors.primary.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.restaurant_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(
              plan.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (plan.description != null) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                plan.description!,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
            const SizedBox(height: AppSpacing.s16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  children: [
                    _buildDetailRow(
                        'Price', '₹${plan.priceAsDouble.toStringAsFixed(0)}'),
                    const Divider(height: 24),
                    _buildDetailRow(
                        'Duration', '${plan.durationDays} days'),
                    const Divider(height: 24),
                    _buildDetailRow(
                        'Meals', '${plan.mealsCount} meals'),
                    if (plan.mealType != null) ...[
                      const Divider(height: 24),
                      _buildDetailRow(
                          'Meal Type', plan.mealType!.toUpperCase()),
                    ],
                    if (plan.pricePerMealAsDouble != null) ...[
                      const Divider(height: 24),
                      _buildDetailRow(
                        'Per Meal',
                        '₹${plan.pricePerMealAsDouble!.toStringAsFixed(0)}/meal',
                      ),
                    ],
                    if (plan.mealsCount > 0) ...[
                      const Divider(height: 24),
                      _buildDetailRow(
                        'Per Day',
                        '₹${(plan.priceAsDouble / plan.durationDays).toStringAsFixed(0)}/day',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: ElevatedButton(
          onPressed:
              (state.isLoading || _isSubscribing) ? null : _handleSubscribe,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
          ),
          child: (_isSubscribing || state.isLoading)
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Subscribe Now',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
