import 'package:dio/dio.dart';
import 'package:parabdi/features/cart/data/models/cart.dart';

class CheckoutRepository {
  final Dio _dio;

  CheckoutRepository(this._dio);

  Future<Cart> getCart() async {
    final response = await _dio.get('/cart');
    return Cart.fromJson(response.data['data']);
  }

  Future<Map<String, dynamic>> validateCart() async {
    final response = await _dio.post('/cart/validate');
    return response.data['data'];
  }

  Future<List<Map<String, dynamic>>> getAddresses() async {
    final response = await _dio.get('/addresses');
    final data = response.data['data'];
    if (data is List) return List<Map<String, dynamic>>.from(data);
    return [];
  }

  Future<Map<String, dynamic>> createOrder({
    required String addressId,
    required String deliverySlot,
    String? specialInstructions,
    String? couponCode,
    String paymentMethod = 'upi',
  }) async {
    final response = await _dio.post('/orders', data: {
      'addressId': addressId,
      'deliverySlot': deliverySlot,
      if (specialInstructions != null) 'specialInstructions': specialInstructions,
      if (couponCode != null) 'couponCode': couponCode,
      'paymentMethod': paymentMethod,
    });
    return response.data['data'];
  }
}
