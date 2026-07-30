import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class OrdersTab extends ConsumerStatefulWidget {
  const OrdersTab({super.key});

  @override
  ConsumerState<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends ConsumerState<OrdersTab> {
  int _activeCategory = 0; // 0: Ongoing, 1: History

  final List<MockOrder> _ongoingOrders = [
    MockOrder(
      id: 'ORD12345',
      date: 'Today, 11:30 AM',
      items: 'Paneer Sabzi with Rice x 1, Gujarati Thali x 1',
      price: 320.0,
      status: 'Out for Delivery',
    ),
  ];

  final List<MockOrder> _historyOrders = [
    MockOrder(
      id: 'ORD12344',
      date: '20 May 2025, 1:00 PM',
      items: 'Rajma Chawal x 2, Dal Tadka x 1',
      price: 420.0,
      status: 'Delivered',
    ),
    MockOrder(
      id: 'ORD12343',
      date: '19 May 2025, 12:30 PM',
      items: 'Kadhi Chawal x 1, Roti (2) x 2',
      price: 260.0,
      status: 'Delivered',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final listToDisplay = _activeCategory == 0 ? _ongoingOrders : _historyOrders;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Orders'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildCategoryToggle(context),
          Expanded(
            child: listToDisplay.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.s24),
                    itemCount: listToDisplay.length,
                    itemBuilder: (context, index) {
                      final order = listToDisplay[index];
                      return _buildOrderCard(context, order);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryToggle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24, vertical: AppSpacing.s12),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeCategory = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _activeCategory == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  border: Border.all(
                    color: _activeCategory == 0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor.withOpacity(0.1),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Ongoing',
                  style: TextStyle(
                    color: _activeCategory == 0 ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeCategory = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _activeCategory == 1 ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  border: Border.all(
                    color: _activeCategory == 1
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor.withOpacity(0.1),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'History',
                  style: TextStyle(
                    color: _activeCategory == 1 ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
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
          const Icon(Icons.receipt_long_rounded, size: 64, color: Colors.grey),
          const SizedBox(height: AppSpacing.s16),
          Text(
            _activeCategory == 0 ? 'No active orders' : 'No order history yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, MockOrder order) {
    final isOngoing = order.status != 'Delivered';
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${order.id}',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOngoing ? AppColors.accent.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: isOngoing ? AppColors.accent : AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(order.date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const Divider(height: 24),
            Text(order.items, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount: ₹${order.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                if (isOngoing)
                  ElevatedButton(
                    onPressed: () => context.push('/track/${order.id}'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
                    ),
                    child: const Text('Track Order', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  )
                else
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Downloading invoice...')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
                        ),
                        child: const Text('Invoice', style: TextStyle(fontSize: 11)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Readded items to cart!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
                        ),
                        child: const Text('Reorder', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MockOrder {
  final String id;
  final String date;
  final String items;
  final double price;
  final String status;

  MockOrder({required this.id, required this.date, required this.items, required this.price, required this.status});
}
