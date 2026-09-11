import 'package:flutter/material.dart';
import '../models/report.dart';
import '../widgets/report_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.reports});
  final List<Report> reports;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const navy = Color(0xFF1E3A8A);

  String _query = '';
  ReportType? _typeFilter; // null = semua

  List<Report> get _filtered {
    return widget.reports.where((r) {
      final matchesType = _typeFilter == null || r.type == _typeFilter;
      if (!matchesType) return false;
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return r.title.toLowerCase().contains(q) ||
          r.location.toLowerCase().contains(q) ||
          r.category.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('Cari Laporan', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Cari nama barang, lokasi, atau kategori...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (val) => setState(() => _query = val),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _FilterChip(label: 'Semua', selected: _typeFilter == null, onTap: () => setState(() => _typeFilter = null)),
                const SizedBox(width: 8),
                _FilterChip(label: 'Hilang', selected: _typeFilter == ReportType.lost, onTap: () => setState(() => _typeFilter = ReportType.lost)),
                const SizedBox(width: 8),
                _FilterChip(label: 'Temuan', selected: _typeFilter == ReportType.found, onTap: () => setState(() => _typeFilter = ReportType.found)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('Tidak ada laporan yang cocok.'))
                  : ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (context, index) => ReportCard(report: _filtered[index]),
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
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}