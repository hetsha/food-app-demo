import 'package:dio/dio.dart';

import '../models/subscription.dart';

class SubscriptionRepository {
  final Dio _dio;

  SubscriptionRepository(this._dio);

  Future<List<SubscriptionPlan>> getPlans() async {
    final response = await _dio.get('/subscriptions');
    final data = response.data['data'];
    if (data is List) {
      return data
          .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<UserSubscription>> getMySubscriptions() async {
    final response = await _dio.get('/subscriptions/my');
    final data = response.data['data'];
    if (data is List) {
      return data
          .map((e) => UserSubscription.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<UserSubscription> subscribe(String subscriptionId) async {
    final response = await _dio.post(
      '/subscriptions/subscribe',
      data: {'subscriptionId': subscriptionId},
    );
    return UserSubscription.fromJson(
        response.data['data'] as Map<String, dynamic>);
  }

  Future<void> pause(String id) async {
    await _dio.patch('/subscriptions/$id/pause');
  }

  Future<void> resume(String id) async {
    await _dio.patch('/subscriptions/$id/resume');
  }

  Future<void> skipDay(String id, String date) async {
    await _dio.post('/subscriptions/$id/skip', data: {'date': date});
  }
}
