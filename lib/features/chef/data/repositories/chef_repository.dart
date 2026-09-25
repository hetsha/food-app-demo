import 'package:dio/dio.dart';

class ChefRepository {
  final Dio _dio;

  ChefRepository(this._dio);

  Future<Map<String, dynamic>> login(String phoneNumber, String pin) async {
    final response = await _dio.post('/auth/chef-login', data: {
      'phoneNumber': phoneNumber,
      'pin': pin,
    });
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _dio.get('/chefs/dashboard');
    return response.data['data'];
  }

  Future<List<dynamic>> getOrders({String? status}) async {
    final response = await _dio.get(
      '/chefs/orders',
      queryParameters: {if (status != null) 'status': status},
    );
    return response.data['data'] ?? [];
  }

  Future<void> acceptOrder(String orderId) async {
    await _dio.post('/chefs/orders/$orderId/accept');
  }

  Future<void> startPreparing(String orderId) async {
    await _dio.post('/chefs/orders/$orderId/start');
  }

  Future<void> markReady(String orderId) async {
    await _dio.post('/chefs/orders/$orderId/ready');
  }

  Future<List<dynamic>> getFoodItems() async {
    final response = await _dio.get('/chefs/foods');
    return response.data['data'] ?? [];
  }

  Future<void> toggleFoodStock(String foodItemId) async {
    await _dio.patch('/chefs/foods/$foodItemId/stock');
  }
}
