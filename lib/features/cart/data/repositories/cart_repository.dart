import 'package:dio/dio.dart';
import '../models/cart.dart';

class CartRepository {
  final Dio _dio;

  CartRepository(this._dio);

  Future<Cart> getCart() async {
    final response = await _dio.get('/cart');
    return Cart.fromJson(response.data['data']);
  }

  Future<void> addItem({
    required String foodItemId,
    required int quantity,
    List<Map<String, dynamic>>? customizationItems,
    String? specialInstructions,
  }) async {
    await _dio.post('/cart/items', data: {
      'foodItemId': foodItemId,
      'quantity': quantity,
      if (customizationItems != null) 'customizationItems': customizationItems,
      if (specialInstructions != null) 'specialInstructions': specialInstructions,
    });
  }

  Future<void> updateItem(String itemId, int quantity) async {
    await _dio.patch('/cart/items/$itemId', data: {
      'quantity': quantity,
    });
  }

  Future<void> removeItem(String itemId) async {
    await _dio.delete('/cart/items/$itemId');
  }

  Future<void> clearCart() async {
    await _dio.delete('/cart');
  }

  Future<Map<String, dynamic>> validateCart() async {
    final response = await _dio.post('/cart/validate');
    return response.data['data'];
  }
}
