import '../models/notification_item.dart';

class NotificationService {
  /// Mengambil data notifikasi awal (mock data, siap dialihkan ke GET /api/notifications/user/:userId).
  List<NotificationItem> getInitialNotifications() {
    return [
      NotificationItem(
        id: '1',
        type: NotificationType.match,
        title: '94% AI Match Found',
        body: 'Laporan "Midnight Blue MacBook Pro 14"" cocok dengan temuan baru di Central Transit Station.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      NotificationItem(
        id: '2',
        type: NotificationType.statusUpdate,
        title: 'Klaim Diverifikasi',
        body: '"Leather Bellroy Key Cover" sudah dikonfirmasi oleh barista di Civic Plaza Coffeehouse.',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      NotificationItem(
        id: '3',
        type: NotificationType.statusUpdate,
        title: 'Barang Kembali ke Pemilik',
        body: '"Tan Leather Bi-Fold Wallet" berhasil dikembalikan. Terima kasih sudah membantu!',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        readAt: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      NotificationItem(
        id: '4',
        type: NotificationType.system,
        title: 'Selamat datang di FindIt!',
        body: 'Lengkapi profil kamu supaya laporan lebih mudah diverifikasi tim komunitas.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        readAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
