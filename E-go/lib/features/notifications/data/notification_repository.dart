// E-GO mock notification repository.

import 'package:flutter/material.dart';

class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.iconData,
    this.isRead = false,
    this.type = NotificationType.info,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final IconData iconData;
  bool isRead;
  final NotificationType type;
}

enum NotificationType { info, booking, promo, system }

class MockNotificationRepository {
  final List<AppNotification> _notifications = _seedNotifications();

  List<AppNotification> getAll() => List.unmodifiable(_notifications);

  void markRead(String id) {
    final n = _notifications.firstWhere(
      (n) => n.id == id,
      orElse: () => _notifications.first,
    );
    n.isRead = true;
  }

  void markAllRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
  }

  void clearAll() => _notifications.clear();

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  static List<AppNotification> _seedNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'n1',
        title: 'Welcome to E-GO! 🎉',
        body: 'Book your first ride and move your way.',
        createdAt: now.subtract(const Duration(hours: 1)),
        iconData: Icons.waving_hand,
        type: NotificationType.info,
      ),
      AppNotification(
        id: 'n2',
        title: 'E-GO is now in Jhargram',
        body: 'Book bike and Toto rides across Jhargram anytime.',
        createdAt: now.subtract(const Duration(hours: 2)),
        iconData: Icons.location_on,
        type: NotificationType.info,
      ),
    ];
  }
}
