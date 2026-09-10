import 'package:flutter/material.dart';
import '../models/report.dart';
import '../widgets/report_card.dart';
import 'report_form_screen.dart';
import 'report_lost_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  ReportStatus? statusFilter;
  ReportType? typeFilter;

  final List<Report> reports = [
    Report(
      id: '1',
      title: 'Dompet coklat',
      category: 'Dompet',
      description: 'Dompet kulit warna coklat, ada KTP di dalamnya',
      location: 'Kantin Fakultas Teknik',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: ReportType.lost,
      status: ReportStatus.baru,
    ),
    Report(
      id: '2',
      title: 'Kunci motor',
      category: 'Kunci',
      description: 'Kunci motor Honda dengan gantungan warna biru',
      location: 'Parkiran Gedung B',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: ReportType.found,
      status: ReportStatus.dicocokkan,
    ),
  ];

  List<Report> get _filtered {
    final query = searchController.text.toLowerCase();
    return reports.where((r) {
      final matchesQuery = query.isEmpty ||
          r.title.toLowerCase().contains(query) ||
          r.category.toLowerCase().contains(query);
      final matchesStatus = statusFilter == null || r.status == statusFilter;
      final matchesType = typeFilter == null || r.type == typeFilter;
      return matchesQuery && matchesStatus && matchesType;
    }).toList();
  }

  Future<void> _openForm(ReportType type) async {
    // Untuk tipe Hilang pakai screen desain baru (ReportLostScreen);
    // tipe Temuan masih pakai ReportFormScreen sampai desainnya tersedia.
    final result = await Navigator.push<Report>(
      context,
      MaterialPageRoute(
        builder: (_) => type == ReportType.lost
            ? const ReportLostScreen()
            : ReportFormScreen(type: type),
      ),
    );
    if (result != null) {
      setState(() => reports.insert(0, result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FindIt!')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Smart Lost & Found', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text('Lapor barang hilang/temuan, matching, status return'),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _openForm(ReportType.lost),
                  icon: const Icon(Icons.search_off),
                  label: const Text('Lapor Hilang'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _openForm(ReportType.found),
                  icon: const Icon(Icons.inventory_2),
                  label: const Text('Lapor Temuan'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Cari',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<ReportType?>(
                  value: typeFilter,
                  decoration: const InputDecoration(labelText: 'Tipe', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Semua')),
                    DropdownMenuItem(value: ReportType.lost, child: Text('Hilang')),
                    DropdownMenuItem(value: ReportType.found, child: Text('Temuan')),
                  ],
                  onChanged: (v) => setState(() => typeFilter = v),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<ReportStatus?>(
                  value: statusFilter,
                  decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Semua')),
                    ...ReportStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))),
                  ],
                  onChanged: (v) => setState(() => statusFilter = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('Belum ada laporan yang cocok.')),
            )
          else
            // TODO: onTap masih kosong — akan diisi navigasi ke screen Detail Laporan (belum dibuat).
            ..._filtered.map((r) => ReportCard(report: r, onTap: () {})),
        ],
      ),
    );
  }
}
