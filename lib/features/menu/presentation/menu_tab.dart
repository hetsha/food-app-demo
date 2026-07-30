import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../cart/presentation/cart_provider.dart';

class MenuTab extends ConsumerStatefulWidget {
  const MenuTab({super.key});

  @override
  ConsumerState<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends ConsumerState<MenuTab> {
  String _selectedCategory = 'all';
  bool _onlyVeg = false;
  String _sortBy = 'Popularity'; // Popularity, Price: Low to High, Price: High to Low
  final List<String> _wishlist = [];

  @override
  Widget build(BuildContext context) {
    var filteredMeals = mockMeals;
    
    // Filter by Category
    if (_selectedCategory != 'all') {
      filteredMeals = filteredMeals.where((m) => m.category == _selectedCategory).toList();
    }
    
    // Filter by Veg
    if (_onlyVeg) {
      filteredMeals = filteredMeals.where((m) => m.isVeg).toList();
    }
    
    // Sort
    if (_sortBy == 'Price: Low to High') {
      filteredMeals.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price: High to Low') {
      filteredMeals.sort((a, b) => b.price.compareTo(a.price));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildStickyHeader(context),
            _buildFiltersRow(context),
            Expanded(
              child: filteredMeals.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
                      itemCount: filteredMeals.length,
                      itemBuilder: (context, index) {
                        final meal = filteredMeals[index];
                        return _buildMealCard(context, meal)
                            .animate()
                            .fade(duration: 400.ms, delay: (index * 50).ms)
                            .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: (index * 50).ms);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ambo Menu',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const Icon(Icons.search_rounded, size: 28),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          // Category Scroll Row
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: mockCategories.length,
              itemBuilder: (context, index) {
                final category = mockCategories[index];
                final isSelected = _selectedCategory == category.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category.id;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).brightness == Brightness.light
                                ? AppColors.borderLight
                                : AppColors.borderDark,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(category.icon, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: 4),
      child: Row(
        children: [
          // Veg only toggle chip
          FilterChip(
            label: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1.5),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                ),
                const SizedBox(width: 6),
                const Text('Veg Only', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
            selected: _onlyVeg,
            onSelected: (val) {
              setState(() {
                _onlyVeg = val;
              });
            },
            selectedColor: AppColors.primary.withOpacity(0.1),
            checkmarkColor: AppColors.primary,
          ),
          const SizedBox(width: 8),
          
          // Sort Dropdown button chip
          PopupMenuButton<String>(
            onSelected: (val) {
              setState(() {
                _sortBy = val;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Popularity', child: Text('Popularity')),
              const PopupMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
              const PopupMenuItem(value: 'Price: High to Low', child: Text('Price: High to Low')),
            ],
            child: Chip(
              label: Row(
                children: [
                  Text('Sort: $_sortBy', style: const TextStyle(fontSize: 11)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant_rounded, size: 64, color: Colors.grey),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'No matching meals found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, Meal meal) {
    final isWishlisted = _wishlist.contains(meal.id);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s20),
      child: InkWell(
        onTap: () => context.push('/meal/${meal.id}'),
        borderRadius: BorderRadius.circular(AppRadius.r20),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    child: CachedNetworkImage(
                      imageUrl: meal.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[200]),
                      errorWidget: (context, url, error) => Container(color: Colors.grey[200]),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        border: Border.all(color: meal.isVeg ? Colors.green : Colors.red, width: 1.5),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: meal.isVeg ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            meal.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isWishlisted) {
                                _wishlist.remove(meal.id);
                              } else {
                                _wishlist.add(meal.id);
                              }
                            });
                          },
                          child: Icon(
                            isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isWishlisted ? Colors.red : Colors.grey,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('${meal.calories} kcal', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(width: 8),
                        const Icon(Icons.access_time_filled_rounded, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${meal.cookingTimeMinutes}m', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(width: 8),
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(meal.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '₹${meal.price.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.primary),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '₹${meal.originalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            ref.read(cartProvider.notifier).addItem(meal);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${meal.name} added to cart!'),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    final cart = ref.read(cartProvider);
                                    final matchingItem = cart.items.firstWhere((i) => i.meal.id == meal.id);
                                    ref.read(cartProvider.notifier).updateQuantity(matchingItem.id, matchingItem.quantity - 1);
                                  },
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(AppRadius.r12),
                            ),
                            child: const Text(
                              'ADD',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
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
