import 'package:flutter/material.dart';
import '../../../controllers/report_controller.dart';
import '../../../models/report.dart';
import '../../widgets/responsive_wrapper.dart';
import '../../widgets/report_card.dart';
import 'report_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.controller});
  final ReportController controller;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final filtered = widget.controller.filteredReports;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('Cari Laporan', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ResponsiveContainer(
        maxWidth: 850,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Column(
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Cari nama barang, lokasi, atau kategori...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (val) => widget.controller.setSearchQuery(val),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _FilterChip(
                  label: 'Semua',
                  selected: widget.controller.typeFilter == null,
                  onTap: () => widget.controller.setTypeFilter(null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Hilang',
                  selected: widget.controller.typeFilter == ReportType.lost,
                  onTap: () => widget.controller.setTypeFilter(ReportType.lost),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Temuan',
                  selected: widget.controller.typeFilter == ReportType.found,
                  onTap: () => widget.controller.setTypeFilter(ReportType.found),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('Tidak ada laporan yang cocok.'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final report = filtered[index];
                        return ReportCard(
                          report: report,
                          onTap: () => _openDetail(report),
                        );
                      },
                    ),
            ),
          ],
        ),
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
