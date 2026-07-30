import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../cart/presentation/cart_provider.dart';

class MealDetailScreen extends ConsumerStatefulWidget {
  final String mealId;
  const MealDetailScreen({super.key, required this.mealId});

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  String _oilLevel = 'Normal'; // Less Oil, Normal, Extra Oil
  String _spiceLevel = 'Medium'; // Mild, Medium, Spicy
  String _portionSize = 'Normal'; // Less, Normal, Extra
  
  final List<String> _removedIngredients = [];
  final List<String> _addedExtras = [];
  final TextEditingController _notesController = TextEditingController();
  
  int _quantity = 1;

  final Map<String, double> _extraPrices = {
    'Extra Paneer': 30.0,
    'Cheese': 20.0,
    'Mushroom': 20.0,
    'Sweet Corn': 15.0,
  };

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double _calculateCurrentPrice(Meal meal) {
    double total = meal.price;
    for (var extra in _addedExtras) {
      total += _extraPrices[extra] ?? 0.0;
    }
    return total * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    final meal = mockMeals.firstWhere((m) => m.id == widget.mealId, orElse: () => mockMeals.first);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context, meal),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMealInfo(context, meal),
                      const Divider(height: 32),
                      _buildNutritionFacts(context, meal),
                      const Divider(height: 32),
                      _buildOilCustomizer(context),
                      const SizedBox(height: AppSpacing.s20),
                      _buildSpiceCustomizer(context),
                      const SizedBox(height: AppSpacing.s20),
                      _buildPortionCustomizer(context),
                      const Divider(height: 32),
                      _buildRemovalSelector(context, meal),
                      const Divider(height: 32),
                      _buildExtrasSelector(context),
                      const Divider(height: 32),
                      _buildSpecialNotes(context),
                      const SizedBox(height: 120), // spacer for bottom action bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomActionBar(context, meal),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Meal meal) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.4),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'meal_${meal.id}',
              child: CachedNetworkImage(
                imageUrl: meal.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[300]),
                errorWidget: (context, url, error) => Container(color: Colors.grey[300]),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent, Colors.black45],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealInfo(BuildContext context, Meal meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: meal.isVeg ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 10, color: meal.isVeg ? Colors.green : Colors.red),
                  const SizedBox(width: 4),
                  Text(
                    meal.isVeg ? 'VEG' : 'NON-VEG',
                    style: TextStyle(
                      color: meal.isVeg ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            if (meal.isBestSeller)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'BESTSELLER',
                  style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          meal.name,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.s8),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              meal.rating.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(width: 8),
            Text(
              '(${meal.reviewsCount} verified reviews)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          meal.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Widget _buildNutritionFacts(BuildContext context, Meal meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Nutrition Facts', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${meal.calories} kcal', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: meal.nutrition.entries.map((entry) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppRadius.r16),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.borderLight
                      : AppColors.borderDark,
                ),
              ),
              child: Column(
                children: [
                  Text(entry.key, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(entry.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOilCustomizer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Oil Level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: AppSpacing.s8),
        Row(
          children: ['Less Oil', 'Normal', 'Extra Oil'].map((level) {
            final isSel = _oilLevel == level;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _oilLevel = level),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    border: Border.all(color: isSel ? Colors.transparent : Colors.grey.withOpacity(0.3)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    level,
                    style: TextStyle(
                      color: isSel ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSpiceCustomizer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Spice Level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: AppSpacing.s8),
        Row(
          children: ['Mild', 'Medium', 'Spicy'].map((level) {
            final isSel = _spiceLevel == level;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _spiceLevel = level),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    border: Border.all(color: isSel ? Colors.transparent : Colors.grey.withOpacity(0.3)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    level,
                    style: TextStyle(
                      color: isSel ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPortionCustomizer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Portion Size', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: AppSpacing.s8),
        Row(
          children: ['Less', 'Normal', 'Extra'].map((size) {
            final isSel = _portionSize == size;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _portionSize = size),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    border: Border.all(color: isSel ? Colors.transparent : Colors.grey.withOpacity(0.3)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    size,
                    style: TextStyle(
                      color: isSel ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRemovalSelector(BuildContext context, Meal meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Remove Ingredients', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: AppSpacing.s8),
        ...meal.ingredients.take(4).map((ingredient) {
          final isRemoved = _removedIngredients.contains(ingredient);
          return CheckboxListTile(
            title: Text(ingredient, style: const TextStyle(fontSize: 14)),
            value: isRemoved,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _removedIngredients.add(ingredient);
                } else {
                  _removedIngredients.remove(ingredient);
                }
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildExtrasSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Add Extra Ingredients', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: AppSpacing.s8),
        ..._extraPrices.entries.map((entry) {
          final isAdded = _addedExtras.contains(entry.key);
          return CheckboxListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key, style: const TextStyle(fontSize: 14)),
                Text('+ ₹${entry.value.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
            value: isAdded,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _addedExtras.add(entry.key);
                } else {
                  _addedExtras.remove(entry.key);
                }
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildSpecialNotes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Special Instructions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: AppSpacing.s8),
        TextField(
          controller: _notesController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'e.g. No green chili, make it less spicy...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(BuildContext context, Meal meal) {
    final currentPrice = _calculateCurrentPrice(meal);
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.r24)),
          boxShadow: AppShadows.premiumShadow(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_quantity > 1) {
                      setState(() => _quantity--);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.remove, size: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _quantity.toString(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _quantity++);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.s16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addItem(
                    meal,
                    spiceLevel: _spiceLevel,
                    oilLevel: _oilLevel,
                    portionSize: _portionSize,
                    removedIngredients: _removedIngredients,
                    addedExtras: _addedExtras,
                    quantity: _quantity,
                  );
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added customized ${meal.name} to cart!')),
                  );
                },
                child: Text('Add to Cart  •  ₹${currentPrice.toStringAsFixed(0)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
