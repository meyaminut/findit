import 'package:flutter/material.dart';
import '../models/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const navy = Color(0xFF1E3A8A);

  // TODO(integrasi API): ganti data dummy ini dengan hasil
  // GET /api/notifications/user/:userId dari branch `api`.
  final List<NotificationItem> _notifications = [
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

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAsRead(NotificationItem item) {
    if (item.isRead) return;
    // TODO(integrasi API): panggil PUT /api/notifications/:id/read juga di sini.
    setState(() => item.readAt = DateTime.now());
  }

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.readAt ??= DateTime.now();
      }
    });
  }

  IconData _iconFor(NotificationType type) => switch (type) {
    NotificationType.match => Icons.auto_awesome,
    NotificationType.statusUpdate => Icons.verified_outlined,
    NotificationType.system => Icons.campaign_outlined,
  };

  Color _colorFor(NotificationType type) => switch (type) {
    NotificationType.match => Colors.blue,
    NotificationType.statusUpdate => Colors.green,
    NotificationType.system => navy,
  };

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays == 1) return 'Kemarin';
    return '${diff.inDays} hari lalu';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Alerts', style: TextStyle(fontWeight: FontWeight.bold)),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
                child: Text('$_unreadCount', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Tandai semua dibaca', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text('Belum ada notifikasi.'))
          : ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = _notifications[index];
          final color = _colorFor(item.type);
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _markAsRead(item),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item.isRead ? Colors.white : color.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: item.isRead ? Colors.grey.shade200 : color.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                    child: Icon(_iconFor(item.type), color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            if (!item.isRead)
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(item.body, style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.3)),
                        const SizedBox(height: 6),
                        Text(_timeAgo(item.createdAt), style: const TextStyle(fontSize: 10, color: Colors.black38)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}