import 'package:flutter/material.dart';
import '../models/report.dart';
import '../widgets/activity_card.dart';

/// Tab My Reports di bottom nav — daftar semua laporan milik user,
/// dengan ringkasan statistik dan filter status.
class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({
    super.key,
    required this.reports,
    required this.timeAgo,
    required this.onOpenDetail,
  });

  final List<Report> reports;
  final String Function(DateTime) timeAgo;
  final void Function(Report) onOpenDetail;

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  static const navy = Color(0xFF1E3A8A);

  ReportStatus? _statusFilter;

  List<Report> get _filtered {
    if (_statusFilter == null) return widget.reports;
    return widget.reports.where((r) => r.status == _statusFilter).toList();
  }

  Color _statusColor(ReportStatus s) => switch (s) {
    ReportStatus.baru => Colors.grey.shade600,
    ReportStatus.dicocokkan => Colors.blue,
    ReportStatus.dikonfirmasi => Colors.amber.shade700,
    ReportStatus.dikembalikan => Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final lostCount = widget.reports.where((r) => r.type == ReportType.lost).length;
    final foundCount = widget.reports.where((r) => r.type == ReportType.found).length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Reports', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 4),
            const Text('Everything you have reported, in one place', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _StatChip(label: 'Total', value: '${widget.reports.length}', color: navy)),
                const SizedBox(width: 8),
                Expanded(child: _StatChip(label: 'Lost', value: '$lostCount', color: Colors.red.shade400)),
                const SizedBox(width: 8),
                Expanded(child: _StatChip(label: 'Found', value: '$foundCount', color: Colors.green.shade600)),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _StatusChip(label: 'All', selected: _statusFilter == null, color: navy, onTap: () => setState(() => _statusFilter = null)),
                  ...ReportStatus.values.map(
                        (s) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _StatusChip(
                        label: s.label,
                        selected: _statusFilter == s,
                        color: _statusColor(s),
                        onTap: () => setState(() => _statusFilter = s),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                child: Text(
                  'No reports in this status yet.',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.only(bottom: 90),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final r = filtered[i];
                  return ActivityCard(
                    report: r,
                    timeAgoText: widget.timeAgo(r.date),
                    onTap: () => widget.onOpenDetail(r),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.selected, required this.color, required this.onTap});
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : Colors.black87, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}