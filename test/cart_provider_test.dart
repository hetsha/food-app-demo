import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parabdi/features/cart/data/models/cart.dart';
import 'package:parabdi/features/cart/data/repositories/cart_repository.dart';
import 'package:parabdi/features/cart/presentation/cart_provider.dart';

class FakeCartRepository extends CartRepository {
  FakeCartRepository() : super(Dio());

  final List<Map<String, dynamic>> stored = [];
  bool failNextAdd = false;
  int get addCallCount => _addCalls;
  int _addCalls = 0;

  @override
  Future<Cart> getCart() async {
    var total = 0.0;
    var count = 0;
    final items = <CartItem>[];
    for (final m in stored) {
      final qty = m['quantity'] as int;
      final unit = (m['price'] as double);
      total += unit * qty;
      count += qty;
      items.add(CartItem(
        id: m['id'] as String,
        foodItemId: m['foodItemId'] as String,
        quantity: qty,
        createdAt: DateTime(2026, 1, 1),
        foodItem: CartFoodItem(
          id: m['foodItemId'] as String,
          name: m['name'] as String,
          price: unit,
        ),
        unitPrice: unit,
        itemTotal: unit * qty,
      ));
    }
    return Cart(
      id: 'cart-1',
      items: items,
      itemTotal: total,
      itemCount: count,
    );
  }

  @override
  Future<void> addItem({
    required String foodItemId,
    required int quantity,
    List<Map<String, dynamic>>? customizationItems,
    String? specialInstructions,
  }) async {
    _addCalls++;
    if (failNextAdd) {
      failNextAdd = false;
      throw DioException(
        requestOptions: RequestOptions(path: '/cart/items'),
        response: Response(
          requestOptions: RequestOptions(path: '/cart/items'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );
    }
    final existing = stored.where((m) => m['foodItemId'] == foodItemId);
    if (existing.isNotEmpty) {
      existing.first['quantity'] =
          (existing.first['quantity'] as int) + quantity;
      return;
    }
    stored.add({
      'id': 'item-${stored.length + 1}',
      'foodItemId': foodItemId,
      'name': 'Food $foodItemId',
      'price': 150.0,
      'quantity': quantity,
    });
  }

  @override
  Future<void> updateItem(String itemId, int quantity) async {
    final m = stored.firstWhere((e) => e['id'] == itemId);
    if (quantity <= 0) {
      stored.remove(m);
    } else {
      m['quantity'] = quantity;
    }
  }

  @override
  Future<void> removeItem(String itemId) async {
    stored.removeWhere((e) => e['id'] == itemId);
  }

  @override
  Future<void> clearCart() async {
    stored.clear();
  }
}

Future<void> waitUntil(bool Function() condition,
    {int maxIterations = 100}) async {
  for (var i = 0; i < maxIterations; i++) {
    if (condition()) return;
    await Future<void>.delayed(Duration.zero);
  }
  fail('Condition not met within $maxIterations event-loop turns');
}

void main() {
  late FakeCartRepository repo;
  late CartNotifier notifier;

  setUp(() {
    repo = FakeCartRepository();
    notifier = CartNotifier(repo);
  });

  tearDown(() => notifier.dispose());

  test('addItem persists to the repository and updates count/total',
      () async {
    await notifier.addItem(foodItemId: 'f1', quantity: 1);

    expect(repo.addCallCount, 1);
    expect(repo.stored.length, 1);
    expect(notifier.state.itemCount, 1);
    expect(notifier.state.subtotal, 150.0);
    expect(notifier.state.items, isNotEmpty);
    expect(notifier.state.error, isNull);
    expect(notifier.state.isAdding, isFalse);
  });

  test('adding the same food again increments quantity and total', () async {
    await notifier.addItem(foodItemId: 'f1', quantity: 1);
    await notifier.addItem(foodItemId: 'f1', quantity: 2);

    expect(notifier.state.itemCount, 3);
    expect(notifier.state.subtotal, 450.0);
  });

  test('cart state survives multiple load cycles (persistence)', () async {
    await notifier.addItem(foodItemId: 'f1', quantity: 1);
    expect(notifier.state.itemCount, 1);

    // Simulate navigating away and back → loadCart again.
    await notifier.loadCart();
    expect(notifier.state.itemCount, 1);
    expect(notifier.state.subtotal, 150.0);
  });

  test('failed add surfaces a 401 login message and does not fake success',
      () async {
    repo.failNextAdd = true;
    await notifier.addItem(foodItemId: 'f1', quantity: 1);

    expect(notifier.state.isAdding, isFalse);
    expect(notifier.state.error, 'Please login to add items to your cart');
    expect(repo.stored, isEmpty);
    expect(notifier.state.itemCount, 0);
  });

  test('successful add after a failure clears the previous error', () async {
    repo.failNextAdd = true;
    await notifier.addItem(foodItemId: 'f1', quantity: 1);
    expect(notifier.state.error, isNotNull);

    await notifier.addItem(foodItemId: 'f1', quantity: 1);
    expect(notifier.state.error, isNull);
    expect(notifier.state.itemCount, 1);
  });

  test('removeItem updates count and total; empty cart hides bar data',
      () async {
    await notifier.addItem(foodItemId: 'f1', quantity: 2);
    final itemId = notifier.state.items.single.id;

    await notifier.removeItem(itemId);
    expect(notifier.state.itemCount, 0);
    expect(notifier.state.items, isEmpty);
    expect(notifier.state.subtotal, 0.0);
  });
}
