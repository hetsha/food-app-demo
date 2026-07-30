import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/cart_item.dart';
import '../../../core/constants/app_constants.dart';

class CartState {
  final List<CartItem> items;
  final String? appliedPromoCode;
  final double discountPercent;

  CartState({
    required this.items,
    this.appliedPromoCode,
    this.discountPercent = 0.0,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => subtotal > 200 ? 0.0 : 30.0;
  double get packagingCharge => items.isEmpty ? 0.0 : 10.0;
  double get gstTax => subtotal * 0.05; // 5% GST
  double get discountAmount => subtotal * (discountPercent / 100);
  double get total => (subtotal + deliveryFee + packagingCharge + gstTax) - discountAmount;

  CartState copyWith({
    List<CartItem>? items,
    String? appliedPromoCode,
    double? discountPercent,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedPromoCode: appliedPromoCode ?? this.appliedPromoCode,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: []));

  void addItem(Meal meal, {
    String spiceLevel = 'Medium',
    String oilLevel = 'Normal',
    String portionSize = 'Normal',
    List<String> removedIngredients = const [],
    List<String> addedExtras = const [],
    int quantity = 1,
  }) {
    // Generate a unique ID based on customization to distinguish between customized orders of the same meal
    final customId = '${meal.id}_${spiceLevel}_${oilLevel}_${portionSize}_${removedIngredients.join(",")}_${addedExtras.join(",")}';

    final existingIndex = state.items.indexWhere((item) => item.id == customId);
    if (existingIndex >= 0) {
      final updatedItems = List<CartItem>.from(state.items);
      final currentItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = currentItem.copyWith(
        quantity: currentItem.quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(
            id: customId,
            meal: meal,
            quantity: quantity,
            spiceLevel: spiceLevel,
            oilLevel: oilLevel,
            portionSize: portionSize,
            removedIngredients: removedIngredients,
            addedExtras: addedExtras,
          ),
        ],
      );
    }
  }

  void updateQuantity(String id, int newQty) {
    if (newQty <= 0) {
      removeItem(id);
      return;
    }
    state = state.copyWith(
      items: state.items.map((item) => item.id == id ? item.copyWith(quantity: newQty) : item).toList(),
    );
  }

  void removeItem(String id) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != id).toList(),
    );
  }

  bool applyPromoCode(String code) {
    if (code.toUpperCase() == 'HEALTH20') {
      state = state.copyWith(appliedPromoCode: 'HEALTH20', discountPercent: 20);
      return true;
    } else if (code.toUpperCase() == 'CHEF100') {
      state = state.copyWith(appliedPromoCode: 'CHEF100', discountPercent: 15);
      return true;
    }
    return false;
  }

  void removePromoCode() {
    state = state.copyWith(appliedPromoCode: null, discountPercent: 0.0);
  }

  void clearCart() {
    state = CartState(items: []);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
