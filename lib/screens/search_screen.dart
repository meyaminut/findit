import 'package:flutter/material.dart';
import '../models/report.dart';
import '../widgets/activity_card.dart';

/// Tab Search di bottom nav — cari laporan berdasarkan nama barang atau
/// lokasi, dengan filter cepat Lost/Found.
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.reports,
    required this.timeAgo,
    required this.onOpenDetail,
  });

  final List<Report> reports;
  final String Function(DateTime) timeAgo;
  final void Function(Report) onOpenDetail;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const navy = Color(0xFF1E3A8A);

  final _controller = TextEditingController();
  ReportType? _typeFilter;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Report> get _results {
    final query = _controller.text.trim().toLowerCase();
    return widget.reports.where((r) {
      final matchesQuery = query.isEmpty ||
          r.title.toLowerCase().contains(query) ||
          r.location.toLowerCase().contains(query) ||
          r.category.toLowerCase().contains(query);
      final matchesType = _typeFilter == null || r.type == _typeFilter;
      return matchesQuery && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Search Reports', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 4),
            const Text('Find lost or found items by name or location', style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              autofocus: false,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by item name or location...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(_controller.clear),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: navy, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _FilterChip(label: 'All', selected: _typeFilter == null, onTap: () => setState(() => _typeFilter = null)),
                const SizedBox(width: 8),
                _FilterChip(label: 'Lost', selected: _typeFilter == ReportType.lost, onTap: () => setState(() => _typeFilter = ReportType.lost)),
                const SizedBox(width: 8),
                _FilterChip(label: 'Found', selected: _typeFilter == ReportType.found, onTap: () => setState(() => _typeFilter = ReportType.found)),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: results.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                padding: const EdgeInsets.only(bottom: 90),
                itemCount: results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final r = results[i];
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

  Widget _buildEmptyState() {
    final hasQuery = _controller.text.isNotEmpty;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            hasQuery ? 'No reports match "${_controller.text}"' : 'Start typing to search reports',
            style: const TextStyle(color: Colors.black54, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
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
          style: TextStyle(color: selected ? Colors.white : Colors.black87, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}