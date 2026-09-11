enum NotificationType { match, statusUpdate, system }

extension NotificationTypeX on NotificationType {
  String get label => switch (this) {
    NotificationType.match => 'AI Match',
    NotificationType.statusUpdate => 'Status Update',
    NotificationType.system => 'Sistem',
  };
}

/// Model notifikasi di sisi Flutter.
///
/// Field `id`, `type`, `title`, `body`, `readAt`, `createdAt` dipetakan
/// langsung dari response backend (`GET /api/notifications/user/:userId`).
/// Backend menyimpan `title`/`body` di kolom `data` (JSON string) —
/// lihat [NotificationItem.fromApiJson] untuk cara parse-nya nanti saat
/// integrasi API dilakukan.
class NotificationItem {
  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.readAt,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  DateTime? readAt;

  bool get isRead => readAt != null;
}