import 'package:flutter/material.dart';
import '../models/report.dart';
import '../widgets/report_card.dart';
import '../widgets/status_badge.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key, required this.reports});
  final List<Report> reports;

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  static const navy = Color(0xFF1E3A8A);

  ReportStatus? _statusFilter; // null = semua

  List<Report> get _filtered {
    if (_statusFilter == null) return widget.reports;
    return widget.reports.where((r) => r.status == _statusFilter).toList();
  }

  Future<void> _showStatusPicker(Report report) async {
    final picked = await showModalBottomSheet<ReportStatus>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: ReportStatus.values.map((s) {
            return ListTile(
              leading: StatusBadge(status: s),
              title: Text(s.label),
              trailing: report.status == s ? const Icon(Icons.check, color: navy) : null,
              onTap: () => Navigator.pop(context, s),
            );
          }).toList(),
        ),
      ),
    );
    if (picked != null) {
      setState(() => report.status = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('My Reports', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _StatusChip(label: 'Semua', selected: _statusFilter == null, onTap: () => setState(() => _statusFilter = null)),
                const SizedBox(width: 8),
                for (final s in ReportStatus.values) ...[
                  _StatusChip(label: s.label, selected: _statusFilter == s, onTap: () => setState(() => _statusFilter = s)),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('Belum ada laporan di kategori ini.'))
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final report = _filtered[index];
                return ReportCard(report: report, onTap: () => _showStatusPicker(report));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const navy = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? navy : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? navy : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}