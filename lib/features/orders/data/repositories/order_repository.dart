import 'package:dio/dio.dart';

import '../models/order.dart';

class OrderRepository {
  final Dio _dio;

  OrderRepository(this._dio);

  Future<List<Order>> getOrders({String? status}) async {
    final response = await _dio.get(
      '/orders',
      queryParameters: {
        if (status != null) 'status': status,
      },
    );
    final data = response.data['data'];
    if (data is List) {
      return data.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Order> getOrder(String orderId) async {
    final response = await _dio.get('/orders/$orderId');
    return Order.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> cancelOrder(String orderId, {String? reason}) async {
    await _dio.post(
      '/orders/$orderId/cancel',
      data: {
        if (reason != null) 'reason': reason,
      },
    );
  }

  Future<List<Order>> reorder(String orderId) async {
    await _dio.post('/orders/$orderId/reorder');
    return [];
  }
}
