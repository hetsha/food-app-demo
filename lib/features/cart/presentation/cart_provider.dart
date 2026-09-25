import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../data/models/cart.dart';
import '../data/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(ApiClient.instance);
});

class CartState {
  final Cart? cart;
  final bool isLoading;
  final String? error;
  final bool isAdding;
  final bool isUpdating;
  final bool isRemoving;
  final String? lastActionMessage;

  CartState({
    this.cart,
    this.isLoading = false,
    this.error,
    this.isAdding = false,
    this.isUpdating = false,
    this.isRemoving = false,
    this.lastActionMessage,
  });

  CartState copyWith({
    Cart? cart,
    bool? isLoading,
    String? error,
    bool? isAdding,
    bool? isUpdating,
    bool? isRemoving,
    String? lastActionMessage,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isAdding: isAdding ?? this.isAdding,
      isUpdating: isUpdating ?? this.isUpdating,
      isRemoving: isRemoving ?? this.isRemoving,
      lastActionMessage: clearMessage ? null : (lastActionMessage ?? this.lastActionMessage),
    );
  }

  int get itemCount => cart?.itemCount ?? 0;
  double get itemTotal => cart?.itemTotal ?? 0.0;
  double get subtotal => cart?.itemTotal ?? 0.0;
  double get deliveryFee => itemTotal >= 200 ? 0.0 : 30.0;
  double get platformFee => 2.0;
  double get gstTax => itemTotal * 0.05;
  double get grandTotal => itemTotal + deliveryFee + platformFee + gstTax;
  List<CartItem> get items => cart?.items ?? [];
  bool get isEmpty => items.isEmpty;
  bool get hasUnavailableItems => cart?.hasUnavailableItems ?? false;
  List<CartItem> get unavailableItems => cart?.unavailableItems ?? [];
}

String _errorMessage(Object e, String fallback) {
  if (e is DioException) {
    if (e.response?.statusCode == 401) {
      return 'Please login to add items to your cart';
    }
    final data = e.response?.data;
    if (data is Map) {
      final error = data['error'];
      if (error is Map && error['message'] != null) {
        return error['message'].toString();
      }
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }
    if (e.error is String && (e.error as String).isNotEmpty) {
      return e.error as String;
    }
    if (e.message != null && e.message!.isNotEmpty) {
      return e.message!;
    }
  }
  final text = e.toString();
  if (text.isNotEmpty && text != 'null') {
    return text;
  }
  return fallback;
}

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _repo;

  CartNotifier(this._repo) : super(CartState());

  Future<void> loadCart() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final cart = await _repo.getCart();
      state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _errorMessage(e, 'Failed to load cart'),
      );
    }
  }

  Future<void> addItem({
    required String foodItemId,
    required int quantity,
    List<Map<String, dynamic>>? customizationItems,
    String? specialInstructions,
  }) async {
    state = state.copyWith(isAdding: true, clearError: true, clearMessage: true);
    try {
      await _repo.addItem(
        foodItemId: foodItemId,
        quantity: quantity,
        customizationItems: customizationItems,
        specialInstructions: specialInstructions,
      );
      await loadCart();
      // The item WAS saved — never surface a stale error for a successful add.
      state = state.copyWith(
        isAdding: false,
        clearError: true,
        lastActionMessage: 'Item added to cart',
      );
    } catch (e) {
      state = state.copyWith(
        isAdding: false,
        error: _errorMessage(e, 'Failed to add item'),
      );
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    state = state.copyWith(isUpdating: true, clearError: true);
    try {
      await _repo.updateItem(itemId, quantity);
      await loadCart();
      state = state.copyWith(isUpdating: false);
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: _errorMessage(e, 'Failed to update quantity'),
      );
    }
  }

  Future<void> removeItem(String itemId) async {
    state = state.copyWith(isRemoving: true, clearError: true);
    try {
      await _repo.removeItem(itemId);
      await loadCart();
      state = state.copyWith(isRemoving: false, lastActionMessage: 'Item removed');
    } catch (e) {
      state = state.copyWith(
        isRemoving: false,
        error: _errorMessage(e, 'Failed to remove item'),
      );
    }
  }

  Future<void> clearCart() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repo.clearCart();
      await loadCart();
      state = state.copyWith(lastActionMessage: 'Cart cleared');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _errorMessage(e, 'Failed to clear cart'),
      );
    }
  }

  void clearMessage() {
    state = state.copyWith(clearMessage: true);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final repo = ref.read(cartRepositoryProvider);
  return CartNotifier(repo);
});
