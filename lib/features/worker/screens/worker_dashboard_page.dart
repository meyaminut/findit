import 'package:flutter/material.dart';

import '../data/found_item_data.dart';
import '../models/found_item.dart';
import '../widgets/found_item_card.dart';
import 'found_item_form_screen.dart';

class WorkerDashboardPage extends StatefulWidget {
  const WorkerDashboardPage({super.key, this.userName = 'Budi'});

  final String userName;

  @override
  State<WorkerDashboardPage> createState() => _WorkerDashboardPageState();
}

class _WorkerDashboardPageState extends State<WorkerDashboardPage> {
  static const navy = Color(0xFF1E3A8A);
  static const teal = Color(0xFF0F766E);

  final List<FoundItem> _items = [...mockFoundItems()];
  FoundItemStatus? _statusFilter;

  List<FoundItem> get _filtered => _statusFilter == null
      ? _items
      : _items.where((i) => i.status == _statusFilter).toList();

  int get _totalBaru =>
      _items.where((i) => i.status == FoundItemStatus.baruDitemukan).length;

  int get _totalLostFound =>
      _items.where((i) => i.status == FoundItemStatus.disimpanLostFound).length;

  Future<void> _openForm() async {
    final result = await Navigator.push<FoundItem>(
      context,
      MaterialPageRoute(builder: (_) => const FoundItemFormScreen()),
    );
    if (result != null) {
      setState(() => _items.insert(0, result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Dashboard Worker Hotel',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: navy,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: _openForm,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Lapor', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            _buildGreeting(),
            const SizedBox(height: 16),
            _buildStatsRow(),
            const SizedBox(height: 20),
            _buildSectionHeader(),
            const SizedBox(height: 12),
            _buildStatusFilter(),
            const SizedBox(height: 12),
            if (_filtered.isEmpty)
              _buildEmptyState()
            else
              ..._filtered.map(
                (item) => FoundItemCard(item: item),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        onPressed: _openForm,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Lapor Temuan', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildGreeting() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [navy, Color(0xFF2E5EC4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            child: Icon(Icons.badge_outlined, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${widget.userName}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Selamat bertugas. Catat dan amankan barang temuan hari ini.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _StatTile(icon: Icons.inventory_2_outlined, value: '${_items.length}', label: 'Total Temuan'),
        const SizedBox(width: 10),
        _StatTile(icon: Icons.new_releases_outlined, value: '$_totalBaru', label: 'Baru', iconColor: Colors.orange.shade800),
        const SizedBox(width: 10),
        _StatTile(icon: Icons.lock_clock_outlined, value: '$_totalLostFound', label: 'Di L&F', iconColor: teal),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        const Text('Barang Ditemukan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: navy.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('${_filtered.length}', style: const TextStyle(fontSize: 12, color: navy, fontWeight: FontWeight.w600)),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: _openForm,
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Lapor Baru', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    final filters = <(FoundItemStatus?, String)>[
      (null, 'Semua'),
      (FoundItemStatus.baruDitemukan, FoundItemStatus.baruDitemukan.label),
      (FoundItemStatus.disimpanLostFound, FoundItemStatus.disimpanLostFound.label),
      (FoundItemStatus.dikembalikan, FoundItemStatus.dikembalikan.label),
    ];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (value, label) = filters[index];
          final selected = _statusFilter == value;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            showCheckmark: false,
            selectedColor: navy,
            labelStyle: TextStyle(
              fontSize: 12,
              color: selected ? Colors.white : Colors.black54,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
            backgroundColor: Colors.white,
            side: BorderSide(color: selected ? navy : Colors.grey.shade300),
            onSelected: (_) => setState(() => _statusFilter = value),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 48, color: Colors.black26),
          const SizedBox(height: 12),
          const Text('Belum ada barang di filter ini', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            'Tekan tombol "Lapor Temuan" untuk mencatat barang baru.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? const Color(0xFF1E3A8A);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            Text(label, style: const TextStyle(fontSize: 10.5, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}