import 'package:flutter/foundation.dart';
import '../models/notification_item.dart';
import '../services/notification_service.dart';

class NotificationController extends ChangeNotifier {
  NotificationController({NotificationService? service, List<NotificationItem>? initialNotifications})
      : _service = service ?? NotificationService() {
    _notifications = initialNotifications ?? _service.getInitialNotifications();
  }

  final NotificationService _service;
  List<NotificationItem> _notifications = [];
  NotificationType? _typeFilter;

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  NotificationType? get typeFilter => _typeFilter;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  List<NotificationItem> get filteredNotifications {
    if (_typeFilter == null) return _notifications;
    return _notifications.where((n) => n.type == _typeFilter).toList();
  }

  void setTypeFilter(NotificationType? type) {
    _typeFilter = type;
    notifyListeners();
  }

  void markAsRead(NotificationItem item) {
    if (item.isRead) return;
    item.readAt = DateTime.now();
    notifyListeners();
  }

  void markAllRead() {
    final now = DateTime.now();
    for (final item in _notifications) {
      item.readAt ??= now;
    }
    notifyListeners();
  }
}
