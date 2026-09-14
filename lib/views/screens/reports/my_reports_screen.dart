import 'package:flutter/material.dart';
import '../../../controllers/report_controller.dart';
import '../../../models/report.dart';
import '../../../models/user_profile.dart';
import '../../widgets/desktop_navbar.dart';
import '../../widgets/report_card.dart';
import '../../widgets/responsive_wrapper.dart';
import '../../widgets/status_badge.dart';
import 'report_detail_screen.dart';
import 'report_found_screen.dart';
import 'report_lost_screen.dart';
import 'search_screen.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({
    super.key,
    required this.controller,
    this.userProfile,
  });

  final ReportController controller;
  final UserProfile? userProfile;

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  static const navy = Color(0xFF1E3A8A);

  ReportStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  UserProfile get _profile =>
      widget.userProfile ??
      UserProfile(name: 'Sarah Jenkins', email: 'sarah@findit.id', phone: '', role: 'user');

  List<Report> get _filtered {
    if (_statusFilter == null) return widget.controller.reports;
    return widget.controller.reports.where((r) => r.status == _statusFilter).toList();
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
      widget.controller.updateReportStatus(report.id, picked);
    }
  }

  void _openDetail(Report report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportDetailScreen(
          report: report,
          onStatusChanged: (newStatus) {
            widget.controller.updateReportStatus(report.id, newStatus);
          },
        ),
      ),
    );
  }

  Future<void> _openLostForm() async {
    final result = await Navigator.push<Report>(
      context,
      MaterialPageRoute(builder: (_) => const ReportLostScreen()),
    );
    if (result != null) {
      widget.controller.addReport(result);
    }
  }

  Future<void> _openFoundForm() async {
    final result = await Navigator.push<Report>(
      context,
      MaterialPageRoute(builder: (_) => const ReportFoundScreen()),
    );
    if (result != null) {
      widget.controller.addReport(result);
    }
  }

  void _openSearch() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(controller: widget.controller, userProfile: _profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktop(context);
    final allReports = widget.controller.reports;
    final inMatching = allReports.where((r) => r.status == ReportStatus.dicocokkan).length;
    final completed = allReports.where((r) => r.status == ReportStatus.dikembalikan).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: desktop
          ? null
          : AppBar(
              backgroundColor: const Color(0xFFF7F8FC),
              elevation: 0,
              foregroundColor: Colors.black87,
              title: const Text('My Reports', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
      body: SafeArea(
        child: Column(
          children: [
            if (desktop)
              DesktopNavbar(
                activeTab: DesktopNavTab.myReports,
                profile: _profile,
                onDashboardTap: () => Navigator.pop(context),
                onSearchTap: _openSearch,
                onMyReportsTap: () {},
                onAlertsTap: () => Navigator.pop(context),
                onLostTap: _openLostForm,
                onFoundTap: _openFoundForm,
                onProfileTap: () => Navigator.pop(context),
              ),
            Expanded(
              child: ResponsiveContainer(
                maxWidth: desktop ? 1240 : 850,
                padding: EdgeInsets.fromLTRB(16, desktop ? 24 : 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (desktop) ...[
                      // Desktop Header & Summary Metrics
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Laporan Aktivitas Saya',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: navy),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Pantau progres verifikasi laporan barang hilang dan temuan yang kamu buat.',
                                style: TextStyle(fontSize: 13, color: Colors.black54),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _MetricBadge(
                                label: 'Total Laporan',
                                count: allReports.length,
                                color: navy,
                              ),
                              const SizedBox(width: 12),
                              _MetricBadge(
                                label: 'Dicocokkan AI',
                                count: inMatching,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(width: 12),
                              _MetricBadge(
                                label: 'Selesai / Kembali',
                                count: completed,
                                color: Colors.green.shade700,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Filter chips row
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _StatusChip(
                            label: 'Semua Status (${allReports.length})',
                            selected: _statusFilter == null,
                            onTap: () => setState(() => _statusFilter = null),
                          ),
                          const SizedBox(width: 8),
                          for (final s in ReportStatus.values) ...[
                            _StatusChip(
                              label: s.label,
                              selected: _statusFilter == s,
                              onTap: () => setState(() => _statusFilter = s),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Reports Grid / List
                    Expanded(
                      child: _filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Belum ada laporan di kategori ini',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Buat laporan baru jika kamu kehilangan atau menemukan barang.',
                                    style: TextStyle(fontSize: 13, color: Colors.black45),
                                  ),
                                ],
                              ),
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                final crossAxisCount = desktop
                                    ? (constraints.maxWidth > 950 ? 3 : 2)
                                    : 1;

                                if (crossAxisCount == 1) {
                                  return ListView.builder(
                                    itemCount: _filtered.length,
                                    itemBuilder: (context, index) {
                                      final report = _filtered[index];
                                      return ReportCard(
                                        report: report,
                                        onTap: () => _openDetail(report),
                                        onStatusTap: () => _showStatusPicker(report),
                                      );
                                    },
                                  );
                                }

                                return GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                    mainAxisExtent: 134,
                                  ),
                                  itemCount: _filtered.length,
                                  itemBuilder: (context, index) {
                                    final report = _filtered[index];
                                    return ReportCard(
                                      report: report,
                                      onTap: () => _openDetail(report),
                                      onStatusTap: () => _showStatusPicker(report),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricBadge extends StatelessWidget {
  const _MetricBadge({required this.label, required this.count, required this.color});
  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$count', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
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
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
