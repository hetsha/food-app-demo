import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../data/repositories/chef_repository.dart';
import 'chef_provider.dart';

class ChefInventoryScreen extends ConsumerStatefulWidget {
  const ChefInventoryScreen({super.key});

  @override
  ConsumerState<ChefInventoryScreen> createState() => _ChefInventoryScreenState();
}

class _ChefInventoryScreenState extends ConsumerState<ChefInventoryScreen> {
  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(chefInventoryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(chefInventoryProvider);
          await ref.read(chefInventoryProvider.future);
        },
        child: inventoryAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: AppSpacing.s16),
                    Text(
                      'No food items found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.s16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _InventoryItem(
                  item: items[index],
                  onToggle: () async {
                    final repo = ref.read(chefRepositoryProvider);
                    await repo.toggleFoodStock(items[index]['id']);
                    ref.invalidate(chefInventoryProvider);
                    if (mounted) {
                      final isActive = items[index]['is_active'] ?? items[index]['in_stock'] ?? true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isActive ? 'Item deactivated' : 'Item activated',
                          ),
                        ),
                      );
                    }
                  },
                ).animate().fadeIn(delay: (index * 40).ms, duration: 300.ms).slideX(begin: 0.02);
              },
            );
          },
          loading: () => ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.s16),
            itemCount: 6,
            itemBuilder: (context, index) => Container(
              height: 80,
              margin: const EdgeInsets.only(bottom: AppSpacing.s12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
            ),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                const SizedBox(height: AppSpacing.s12),
                Text('Failed to load inventory', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.s12),
                ElevatedButton(
                  onPressed: () => ref.invalidate(chefInventoryProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InventoryItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onToggle;

  const _InventoryItem({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final name = item['name'] ?? 'Item';
    final price = item['price'] ?? 0;
    final imageUrl = item['image_url'] ?? item['image'] ?? '';
    final isActive = item['is_active'] ?? item['in_stock'] ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s12),
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
        boxShadow: AppShadows.premiumShadow(),
      ),
      child: Row(
        children: [
          // Food image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderImage(),
                  )
                : _placeholderImage(),
          ),
          const SizedBox(width: AppSpacing.s12),

          // Name & price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  '₹${(price is num ? price.toDouble() : 0.0).toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s8,
                    vertical: AppSpacing.s4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isActive ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Toggle
          Switch.adaptive(
            value: isActive,
            onChanged: (_) => onToggle(),
            activeColor: AppColors.success,
            inactiveTrackColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: const Icon(
        Icons.restaurant_rounded,
        color: AppColors.primary,
        size: 28,
      ),
    );
  }
}
