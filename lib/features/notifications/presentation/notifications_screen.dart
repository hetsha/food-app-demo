import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/notification_item.dart';
import '../data/repositories/notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository(ApiClient.instance);
});

final notificationsFutureProvider = FutureProvider<List<NotificationItem>>((ref) async {
  final repo = ref.read(notificationsRepositoryProvider);
  return repo.getNotifications();
});

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(notificationsRepositoryProvider).markAllAsRead();
              ref.invalidate(notificationsFutureProvider);
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: AppSpacing.s16),
              const Text('Failed to load notifications', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.s8),
              TextButton(
                onPressed: () => ref.invalidate(notificationsFutureProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: AppSpacing.s16),
                  const Text('No notifications yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: AppSpacing.s8),
                  const Text('Order updates and offers will appear here', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return _NotificationTile(
                notification: notif,
                onTap: () => _markRead(ref, notif),
              );
            },
          );
        },
      ),
    );
  }

  void _markRead(WidgetRef ref, NotificationItem notif) async {
    if (!notif.isRead) {
      await ref.read(notificationsRepositoryProvider).markAsRead(notif.id);
      ref.invalidate(notificationsFutureProvider);
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final notif = notification;
    final icon = notif.type == 'order'
        ? Icons.receipt_long_rounded
        : notif.type == 'subscription'
            ? Icons.card_membership_rounded
            : notif.type == 'offer'
                ? Icons.local_offer_rounded
                : Icons.notifications_rounded;

    final color = notif.type == 'order'
        ? AppColors.primary
        : notif.type == 'subscription'
            ? AppColors.accent
            : notif.type == 'offer'
                ? Colors.deepPurple
                : Colors.grey;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        notif.title,
        style: TextStyle(
          fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(notif.body, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: Text(
        _timeAgo(notif.createdAt),
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
