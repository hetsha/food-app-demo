import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/cart.dart';
import 'cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${cartState.itemCount})'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!cartState.isEmpty)
            TextButton(
              onPressed: () => _confirmClearCart(context),
              child: const Text('Clear All', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: cartState.isLoading && cartState.cart == null
          ? const Center(child: CircularProgressIndicator())
          : cartState.isEmpty
              ? _buildEmptyCart(context)
              : _buildCartContent(context, cartState),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: AppSpacing.s16),
          const Text('Your cart is empty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: AppSpacing.s8),
          const Text('Add some delicious meals to get started', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: AppSpacing.s24),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Explore Menu', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartState cartState) {
    return Column(
      children: [
        if (cartState.hasUnavailableItems)
          _buildUnavailableBanner(cartState),

        if (cartState.error != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(cartState.error!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13)),
                ),
              ],
            ),
          ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s8),
            itemCount: cartState.items.length,
            itemBuilder: (context, index) {
              final item = cartState.items[index];
              return _buildCartItem(context, item, cartState);
            },
          ),
        ),

        if (!cartState.isEmpty)
          _buildBottomSummary(context, cartState),
      ],
    );
  }

  Widget _buildUnavailableBanner(CartState cartState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.orange.shade50,
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${cartState.unavailableItems.length} item(s) unavailable. Remove them to proceed.',
              style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item, CartState cartState) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.r12),
              child: CachedNetworkImage(
                imageUrl: item.foodItem.imageUrls.isNotEmpty
                    ? item.foodItem.imageUrls.first
                    : 'https://via.placeholder.com/100',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.restaurant, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (item.foodItem.isVeg)
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.success, width: 1.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Icon(Icons.circle, size: 8, color: AppColors.success),
                        ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.foodItem.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (item.customizationItems.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: item.customizationItems.map((c) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(c.name, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary)),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '₹${item.unitPrice.toStringAsFixed(0)} each',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${item.itemTotal.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      _buildQuantityControls(context, item, cartState),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, CartItem item, CartState cartState) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQtyButton(
            icon: item.quantity == 1 ? Icons.delete_outline_rounded : Icons.remove_rounded,
            onTap: () {
              if (item.quantity == 1) {
                ref.read(cartProvider.notifier).removeItem(item.id);
              } else {
                ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity - 1);
              }
            },
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 36),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          _buildQtyButton(
            icon: Icons.add_rounded,
            onTap: () {
              ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildBottomSummary(BuildContext context, CartState cartState) {
    final itemTotal = cartState.itemTotal;
    final deliveryFee = itemTotal >= 200 ? 0.0 : 30.0;
    final platformFee = 2.0;
    final taxAmount = itemTotal * 0.05;
    final grandTotal = itemTotal + deliveryFee + platformFee + taxAmount;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPriceRow('Item Total', '₹${itemTotal.toStringAsFixed(0)}'),
            const SizedBox(height: 4),
            _buildPriceRow('Delivery Fee', deliveryFee == 0 ? 'FREE' : '₹${deliveryFee.toStringAsFixed(0)}',
                isFree: deliveryFee == 0),
            const SizedBox(height: 4),
            _buildPriceRow('Platform Fee', '₹${platformFee.toStringAsFixed(0)}'),
            const SizedBox(height: 4),
            _buildPriceRow('GST (5%)', '₹${taxAmount.toStringAsFixed(0)}'),
            const Divider(height: 20),
            _buildPriceRow(
              'Grand Total',
              '₹${grandTotal.toStringAsFixed(0)}',
              isBold: true,
            ),
            const SizedBox(height: AppSpacing.s12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cartState.hasUnavailableItems
                    ? null
                    : () => context.push('/checkout'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                ),
                child: Text(
                  'Proceed to Checkout  •  ₹${grandTotal.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false, bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: isBold ? 16 : 14)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
            color: isFree ? AppColors.success : null,
          ),
        ),
      ],
    );
  }

  void _confirmClearCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(cartProvider.notifier).clearCart();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
