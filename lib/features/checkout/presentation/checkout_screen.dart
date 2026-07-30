import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../cart/presentation/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  Address _selectedAddress = mockAddresses.first;
  String _selectedSlot = 'Immediate (25-30 mins)';
  String _selectedPaymentMethod = 'UPI'; // UPI, Cards, Cash, Wallet
  bool _isProcessing = false;

  final List<String> _slots = [
    'Immediate (25-30 mins)',
    'Lunch Slot (12:00 PM - 1:00 PM)',
    'Lunch Slot (1:00 PM - 2:00 PM)',
    'Dinner Slot (7:30 PM - 8:30 PM)',
  ];

  final List<PaymentOption> _paymentMethods = [
    PaymentOption(name: 'UPI / GPay / Apple Pay', code: 'UPI', icon: Icons.bolt_rounded),
    PaymentOption(name: 'Credit or Debit Card', code: 'Cards', icon: Icons.credit_card_rounded),
    PaymentOption(name: 'Ambo Wallet Balance', code: 'Wallet', icon: Icons.account_balance_wallet_rounded),
    PaymentOption(name: 'Cash on Delivery (COD)', code: 'Cash', icon: Icons.payments_rounded),
  ];

  void _placeOrder(double total) async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate Payment gateway delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    
    // Clear shopping cart
    ref.read(cartProvider.notifier).clearCart();
    
    setState(() {
      _isProcessing = false;
    });

    // Route to order tracking page
    context.go('/track/ORD12345');
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isProcessing
          ? _buildProcessingLoader(context)
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddressSection(context),
                  const Divider(height: 40),
                  _buildDeliverySlotSection(context),
                  const Divider(height: 40),
                  _buildPaymentSection(context),
                  const Divider(height: 40),
                  _buildOrderSummarySection(context, cartState),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => _placeOrder(cartState.total),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 54),
                    ),
                    child: Text('Pay Securely  •  ₹${cartState.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProcessingLoader(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(strokeWidth: 3.5),
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'Securing payment...',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Please do not close the app or press back button.'),
        ],
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Delivery Address', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => _showAddressSelectionDialog(context),
              child: const Text('Change'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.location_on_rounded, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: AppSpacing.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedAddress.type,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_selectedAddress.addressLine1}, ${_selectedAddress.addressLine2}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Phone: ${_selectedAddress.phone}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliverySlotSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Slot', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.s12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSlot,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: _slots.map((slot) {
                return DropdownMenuItem<String>(
                  value: slot,
                  child: Text(slot, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedSlot = val;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.s12),
        Column(
          children: _paymentMethods.map((method) {
            final isSel = _selectedPaymentMethod == method.code;
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.s8),
              child: ListTile(
                leading: Icon(method.icon, color: isSel ? Theme.of(context).colorScheme.primary : Colors.grey),
                title: Text(method.name, style: TextStyle(fontWeight: isSel ? FontWeight.bold : FontWeight.normal, fontSize: 14)),
                trailing: Icon(
                  isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSel ? Theme.of(context).colorScheme.primary : Colors.grey,
                ),
                onTap: () => setState(() => _selectedPaymentMethod = method.code),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOrderSummarySection(BuildContext context, CartState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Summary', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.s12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Item Total'),
                    Text('₹${state.subtotal.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Delivery & Packaging'),
                    Text('₹${(state.deliveryFee + state.packagingCharge).toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Taxes (GST)'),
                    Text('₹${state.gstTax.toStringAsFixed(2)}'),
                  ],
                ),
                if (state.discountAmount > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Discount Applied', style: TextStyle(color: AppColors.success)),
                      Text('- ₹${state.discountAmount.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹${state.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddressSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Delivery Address'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: mockAddresses.map((addr) {
            return ListTile(
              title: Text(addr.type, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${addr.addressLine1}, ${addr.addressLine2}', maxLines: 2, overflow: TextOverflow.ellipsis),
              onTap: () {
                setState(() {
                  _selectedAddress = addr;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class PaymentOption {
  final String name;
  final String code;
  final IconData icon;

  PaymentOption({required this.name, required this.code, required this.icon});
}
