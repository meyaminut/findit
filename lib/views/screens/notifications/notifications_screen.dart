import 'package:flutter/material.dart';
import '../../../controllers/notification_controller.dart';
import '../../../models/notification_item.dart';
import '../../widgets/responsive_wrapper.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.controller});
  final NotificationController? controller;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const navy = Color(0xFF1E3A8A);

  late final NotificationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? NotificationController();
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    super.dispose();
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
    final notifications = _controller.filteredNotifications;
    final unreadCount = _controller.unreadCount;

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
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
                child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _controller.markAllRead,
              child: const Text('Tandai semua dibaca', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
      body: ResponsiveContainer(
        maxWidth: 800,
        child: notifications.isEmpty
            ? const Center(child: Text('Belum ada notifikasi.'))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  final color = _colorFor(item.type);
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _controller.markAsRead(item),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.isRead ? Colors.white : color.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: item.isRead ? Colors.grey.shade200 : color.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
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
      ),
    );
  }
}
