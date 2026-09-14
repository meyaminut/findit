import 'package:flutter/material.dart';
import '../../../controllers/report_controller.dart';
import '../../../models/report.dart';
import '../../../models/user_profile.dart';
import '../../widgets/desktop_navbar.dart';
import '../../widgets/report_card.dart';
import '../../widgets/responsive_wrapper.dart';
import 'my_reports_screen.dart';
import 'report_detail_screen.dart';
import 'report_found_screen.dart';
import 'report_lost_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.controller,
    this.userProfile,
  });

  final ReportController controller;
  final UserProfile? userProfile;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  static const navy = Color(0xFF1E3A8A);

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.controller.searchQuery;
    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _searchController.dispose();
    super.dispose();
  }

  UserProfile get _profile =>
      widget.userProfile ??
      UserProfile(name: 'Sarah Jenkins', email: 'sarah@findit.id', phone: '', role: 'user');

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

  void _openMyReports() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MyReportsScreen(controller: widget.controller, userProfile: _profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.controller.filteredReports;
    final desktop = isDesktop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: desktop
          ? null
          : AppBar(
              backgroundColor: const Color(0xFFF7F8FC),
              elevation: 0,
              foregroundColor: Colors.black87,
              title: const Text('Cari Laporan', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
      body: SafeArea(
        child: Column(
          children: [
            if (desktop)
              DesktopNavbar(
                activeTab: DesktopNavTab.search,
                profile: _profile,
                onDashboardTap: () => Navigator.pop(context),
                onSearchTap: () {},
                onMyReportsTap: _openMyReports,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Cari & Telusuri Laporan',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: navy),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Temukan barang yang hilang atau laporkan penemuan di seluruh area kampus.',
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Text(
                              '${filtered.length} Laporan Ditemukan',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                    ],

                    // Search input
                    TextField(
                      controller: _searchController,
                      autofocus: !desktop,
                      decoration: InputDecoration(
                        hintText: 'Cari nama barang, lokasi, merk, atau kata kunci...',
                        prefixIcon: const Icon(Icons.search, color: navy),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  widget.controller.setSearchQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: navy, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      ),
                      onChanged: (val) => widget.controller.setSearchQuery(val),
                    ),

                    const SizedBox(height: 14),

                    // Filter chips
                    Row(
                      children: [
                        _FilterChip(
                          label: 'Semua',
                          selected: widget.controller.typeFilter == null,
                          onTap: () => widget.controller.setTypeFilter(null),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Barang Hilang',
                          selected: widget.controller.typeFilter == ReportType.lost,
                          onTap: () => widget.controller.setTypeFilter(ReportType.lost),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Barang Temuan',
                          selected: widget.controller.typeFilter == ReportType.found,
                          onTap: () => widget.controller.setTypeFilter(ReportType.found),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Reports Grid / List
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off_outlined, size: 64, color: Colors.grey.shade400),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Tidak ada laporan yang cocok',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Coba kata kunci lain atau ubah filter tipe laporan di atas.',
                                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
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
                                    itemCount: filtered.length,
                                    itemBuilder: (context, index) {
                                      final report = filtered[index];
                                      return ReportCard(
                                        report: report,
                                        onTap: () => _openDetail(report),
                                      );
                                    },
                                  );
                                }

                                return GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                    mainAxisExtent: 130,
                                  ),
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    final report = filtered[index];
                                    return ReportCard(
                                      report: report,
                                      onTap: () => _openDetail(report),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
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
