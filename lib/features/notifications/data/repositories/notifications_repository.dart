import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/notification_item.dart';

class NotificationsRepository {
  final Dio _dio;

  NotificationsRepository(this._dio);

  Future<List<NotificationItem>> getNotifications() async {
    final response = await _dio.get(ApiConstants.notifications);
    final data = response.data['data'];
    final list = data is List ? data : data['notifications'] ?? [];
    return (list as List)
        .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAsRead(String id) async {
    await _dio.patch('${ApiConstants.notifications}/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _dio.patch(ApiConstants.notificationsReadAll);
  }
}
