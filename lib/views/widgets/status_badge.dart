import 'package:flutter/material.dart';
import '../../models/report.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, this.showDot = false});
  final ReportStatus status;
  final bool showDot;

  Color _color() => switch (status) {
        ReportStatus.baru => Colors.grey,
        ReportStatus.dicocokkan => Colors.blue,
        ReportStatus.dikonfirmasi => Colors.amber.shade700,
        ReportStatus.dikembalikan => Colors.green,
      };

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
          ],
          Text(
            status.label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
