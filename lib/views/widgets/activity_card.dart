import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/report.dart';
import 'status_badge.dart';

/// Kartu aktivitas ringkas untuk satu laporan (dipakai di Dashboard, Search, dan My Reports).
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.report,
    required this.timeAgoText,
    this.onTap,
  });

  final Report report;
  final String timeAgoText;
  final VoidCallback? onTap;

  Color get _noteColor => switch (report.status) {
    ReportStatus.baru => Colors.black54,
    ReportStatus.dicocokkan => Colors.green,
    ReportStatus.dikonfirmasi => Colors.amber.shade800,
    ReportStatus.dikembalikan => Colors.green,
  };

  IconData get _noteIcon => switch (report.status) {
    ReportStatus.baru => Icons.search,
    ReportStatus.dicocokkan => Icons.check_circle_outline,
    ReportStatus.dikonfirmasi => Icons.verified_outlined,
    ReportStatus.dikembalikan => Icons.handshake_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final isLost = report.type == ReportType.lost;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isLost ? Colors.red.shade50 : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isLost ? 'LOST' : 'FOUND',
                    style: TextStyle(
                      color: isLost ? Colors.red.shade700 : Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    report.category,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: report.status, showDot: true),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: report.photoPath != null
                      ? Image.file(File(report.photoPath!), width: 48, height: 48, fit: BoxFit.cover)
                      : Container(
                          width: 48,
                          height: 48,
                          color: Colors.grey.shade100,
                          child: Icon(
                            isLost ? Icons.help_outline : Icons.inventory_2_outlined,
                            color: Colors.black38,
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.place_outlined, size: 12, color: Colors.black38),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              report.location,
                              style: const TextStyle(fontSize: 11, color: Colors.black54),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (report.activityNote != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(_noteIcon, size: 14, color: _noteColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      report.activityNote!,
                      style: TextStyle(fontSize: 11, color: _noteColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(timeAgoText, style: const TextStyle(fontSize: 10, color: Colors.black38)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
