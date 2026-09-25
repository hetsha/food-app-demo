import 'package:dio/dio.dart';
import '../models/payment_order.dart';

class PaymentRepository {
  final Dio _dio;

  PaymentRepository(this._dio);

  Future<PaymentOrder> createOrder(String orderId, double amount) async {
    final response = await _dio.post('/payments/create', data: {
      'orderId': orderId,
      'amount': amount,
    });
    return PaymentOrder.fromJson(response.data['data']);
  }

  Future<bool> verifyPayment({
    required String orderId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    final response = await _dio.post('/payments/verify', data: {
      'orderId': orderId,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpaySignature': razorpaySignature,
    });
    return response.data['data']['verified'] ?? false;
  }
}
