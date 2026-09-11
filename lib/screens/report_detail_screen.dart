import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/report.dart';

/// Halaman Report Detail — menampilkan status verifikasi sebuah laporan
/// (Lost/Found), termasuk timeline 4 tahap, kartu konfirmasi admin,
/// data custodian/penemu, dan detail katalog barang.
class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({super.key, required this.report});
  final Report report;

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  static const navy = Color(0xFF1E3A8A);
  static const bg = Color(0xFFF7F8FC);

  static const _stageOrder = [
    ReportStatus.baru,
    ReportStatus.dicocokkan,
    ReportStatus.dikonfirmasi,
    ReportStatus.dikembalikan,
  ];

  static const _stageLabels = ['New', 'Matched', 'Confirmed', 'Returned'];

  late Report report;

  @override
  void initState() {
    super.initState();
    report = widget.report;
  }

  int get _stageIndex => _stageOrder.indexOf(report.status);

  bool get _hasCustodian => report.custodianName != null;
  bool get _isConfirmed => report.status == ReportStatus.dikonfirmasi;
  bool get _isReturned => report.status == ReportStatus.dikembalikan;

  Color _stageColor(int i) => switch (_stageOrder[i]) {
    ReportStatus.baru => Colors.grey,
    ReportStatus.dicocokkan => Colors.blue,
    ReportStatus.dikonfirmasi => Colors.amber.shade700,
    ReportStatus.dikembalikan => Colors.green,
  };

  void _markAsReturned() {
    setState(() => report.status = ReportStatus.dikembalikan);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barang ditandai sudah dikembalikan.')),
    );
  }

  void _copyIdentifier() {
    final id = report.reportIdentifier ?? '#${report.id}';
    Clipboard.setData(ClipboardData(text: id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report ID disalin')),
    );
  }

  void _callFinder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Menghubungi ${report.custodianName ?? 'finder'}'
              '${report.custodianPhone != null ? ' (${report.custodianPhone})' : ''}...',
        ),
      ),
    );
  }

  void _messageFinder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Membuka kotak pesan...')),
    );
  }

  void _reportIssue() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Laporan masalah telah dikirim ke admin.')),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final period = d.hour >= 12 ? 'PM' : 'AM';
    final minute = d.minute.toString().padLeft(2, '0');
    return '${months[d.month - 1]} ${d.day}, ${d.year} at $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: const BackButton(),
        titleSpacing: 0,
        title: Row(
          children: const [
            Icon(Icons.search, size: 18, color: Colors.black54),
            SizedBox(width: 6),
            Text('Report Detail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Badge(
              label: const Text('3'),
              backgroundColor: Colors.orange,
              child: const Icon(Icons.notifications_none),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(radius: 16, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 18, color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _buildCaseFileRow(),
          const SizedBox(height: 12),
          _buildHero(),
          const SizedBox(height: 20),
          _buildTimelineHeader(),
          const SizedBox(height: 14),
          _buildTimeline(),
          if (_isConfirmed) ...[
            const SizedBox(height: 16),
            _buildConfirmedCard(),
          ],
          if (_isReturned) ...[
            const SizedBox(height: 16),
            _buildReturnedCard(),
          ],
          if (_hasCustodian) ...[
            const SizedBox(height: 24),
            _buildCustodianHeader(),
            const SizedBox(height: 10),
            _buildCustodianCard(),
          ],
          const SizedBox(height: 24),
          _buildCatalogHeader(),
          const SizedBox(height: 10),
          _buildCatalogCard(),
          if (_isConfirmed && _hasCustodian) ...[
            const SizedBox(height: 20),
            _buildConfirmQuestion(),
            const SizedBox(height: 12),
            _buildMarkReturnedButton(),
            const SizedBox(height: 10),
            _buildReportIssueLink(),
          ],
        ],
      ),
    );
  }

  // --- Active case file row ---
  Widget _buildCaseFileRow() {
    final label = _isReturned ? 'CASE CLOSED' : 'ACTIVE CASE FILE';
    final color = _isReturned ? Colors.green.shade700 : Colors.orange.shade700;
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
        const Spacer(),
        _CircleIconButton(icon: Icons.ios_share, onTap: () {}),
        const SizedBox(width: 8),
        _CircleIconButton(icon: Icons.bookmark_border, onTap: () {}),
      ],
    );
  }

  // --- Hero photo ---
  Widget _buildHero() {
    final badgeLabel = switch (report.status) {
      ReportStatus.baru => 'SEARCHING',
      ReportStatus.dicocokkan => 'MATCH FOUND',
      ReportStatus.dikonfirmasi => 'CONFIRMED MATCH',
      ReportStatus.dikembalikan => 'RETURNED',
    };
    final badgeColor = _stageColor(_stageIndex);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            report.photoPath != null
                ? Image.file(File(report.photoPath!), fit: BoxFit.cover)
                : Container(
              color: navy.withValues(alpha: 0.85),
              child: Icon(
                report.type == ReportType.lost ? Icons.help_outline : Icons.inventory_2_outlined,
                size: 64,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            // gradient overlay so the title stays readable
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(20)),
                child: Text(badgeLabel, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_stageIndex >= 2)
                    Row(
                      children: [
                        const Icon(Icons.verified, size: 14, color: Colors.greenAccent),
                        const SizedBox(width: 4),
                        Text(
                          'CASE REFERENCE VERIFIED',
                          style: TextStyle(color: Colors.greenAccent.shade100, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.4),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Text(
                    report.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Verification timeline ---
  Widget _buildTimelineHeader() {
    return Row(
      children: [
        const Text('VERIFICATION TIMELINE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.4)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: navy.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
          child: Text('Stage ${_stageIndex + 1} of 4', style: TextStyle(color: navy, fontSize: 11, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Row(
              children: List.generate(_stageOrder.length - 1, (i) {
                final passed = i < _stageIndex;
                return Expanded(
                  child: Container(height: 2, color: passed ? navy : Colors.grey.shade300),
                );
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_stageOrder.length, (i) {
              return _TimelineDot(
                label: _stageLabels[i],
                done: i < _stageIndex,
                current: i == _stageIndex,
                color: _stageColor(i),
                icon: _stageOrder[i] == ReportStatus.dikonfirmasi ? Icons.lock_outline : null,
              );
            }),
          ),
        ],
      ),
    );
  }

  // --- Match confirmed / returned status cards ---
  Widget _buildConfirmedCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 16, backgroundColor: Colors.green.shade600, child: const Icon(Icons.check, color: Colors.white, size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Match Confirmed by Admin ${report.verifiedBy ?? 'Staff'}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(20)),
                      child: Text('Staff Verified', style: TextStyle(color: Colors.green.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Physical serialization & embedded ID cards checked against municipal records. Safe custodian handoff is unlocked.',
                  style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnedCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 16, backgroundColor: Colors.green.shade600, child: const Icon(Icons.handshake_outlined, color: Colors.white, size: 16)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Item returned to its owner. This case file is now closed.',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // --- Custodian details ---
  Widget _buildCustodianHeader() {
    return Row(
      children: [
        const Icon(Icons.lock_outline, size: 15, color: Colors.black87),
        const SizedBox(width: 6),
        const Text('CUSTODIAN DETAILS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.4)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
          child: Text('Encrypted Reveal', style: TextStyle(color: Colors.amber.shade800, fontSize: 11, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildCustodianCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 22, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CUSTODIAN / FINDER', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
                    const SizedBox(height: 2),
                    Text(report.custodianName ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    if (report.custodianRole != null)
                      Text(report.custodianRole!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (report.custodianPhone != null) ...[
            _ContactRow(icon: Icons.call_outlined, value: report.custodianPhone!),
            const SizedBox(height: 8),
          ],
          if (report.custodianEmail != null) _ContactRow(icon: Icons.mail_outline, value: report.custodianEmail!),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: navy, padding: const EdgeInsets.symmetric(vertical: 12)),
                  onPressed: report.custodianPhone != null ? _callFinder : null,
                  icon: const Icon(Icons.call, size: 16),
                  label: const Text('Call Finder'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: navy, side: BorderSide(color: navy), padding: const EdgeInsets.symmetric(vertical: 12)),
                  onPressed: _messageFinder,
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Message'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Catalog details ---
  Widget _buildCatalogHeader() {
    return Row(
      children: [
        const Text('Catalog Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const Spacer(),
        const Text('Official Registry Entry', style: TextStyle(fontSize: 11, color: Colors.black45)),
      ],
    );
  }

  Widget _buildCatalogCard() {
    final dateLabel = report.type == ReportType.lost ? 'LOST DATE & TIME' : 'FOUND DATE & TIME';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CatalogRow(
            label: 'REPORT IDENTIFIER',
            value: report.reportIdentifier ?? '#${report.id}',
            valueColor: navy,
            trailing: _CircleIconButton(icon: Icons.copy_outlined, small: true, onTap: _copyIdentifier),
          ),
          const _CatalogDivider(),
          _CatalogRow(label: 'CATEGORY', value: report.category),
          const _CatalogDivider(),
          _CatalogRow(label: dateLabel, value: _formatDate(report.date)),
          const _CatalogDivider(),
          _CatalogRow(label: 'REPORTED DISCOVERY LOCATION', value: report.location),
          if (report.description.trim().isNotEmpty) ...[
            const _CatalogDivider(),
            _CatalogRow(label: 'PHYSICAL DESCRIPTION', value: report.description),
          ],
          if (_hasCustodian) ...[
            const _CatalogDivider(),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('RECOVERY STATION VICINITY', style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
            ),
            _MapPlaceholder(locationLabel: report.location),
          ],
        ],
      ),
    );
  }

  // --- Confirm & mark returned ---
  Widget _buildConfirmQuestion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline, size: 14, color: Colors.black45),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'Did you retrieve this item safely from ${report.custodianName}?',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildMarkReturnedButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(backgroundColor: Colors.amber.shade700, padding: const EdgeInsets.symmetric(vertical: 14)),
        onPressed: _markAsReturned,
        icon: const Icon(Icons.check_box_outlined),
        label: const Text('Mark as Returned', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildReportIssueLink() {
    return Center(
      child: TextButton(
        onPressed: _reportIssue,
        child: const Text('Report an Issue with this Match', style: TextStyle(color: Colors.black45, fontSize: 12)),
      ),
    );
  }
}

// ===================== Small private helper widgets =====================

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap, this.small = false});
  final IconData icon;
  final VoidCallback onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 30.0 : 34.0;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
        child: Icon(icon, size: small ? 15 : 17, color: Colors.black87),
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.label, required this.done, required this.current, required this.color, this.icon});
  final String label;
  final bool done;
  final bool current;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final active = done || current;
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? color : Colors.white,
            border: Border.all(color: active ? color : Colors.grey.shade300, width: 2),
          ),
          child: Icon(
            done ? Icons.check : (current ? (icon ?? Icons.circle) : Icons.circle_outlined),
            size: done ? 16 : (current ? 14 : 10),
            color: active ? Colors.white : Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: active ? Colors.black87 : Colors.black38),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.value});
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF1E3A8A)),
        const SizedBox(width: 10),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _CatalogRow extends StatelessWidget {
  const _CatalogRow({required this.label, required this.value, this.valueColor, this.trailing});
  final String label;
  final String value;
  final Color? valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
                const SizedBox(height: 3),
                Text(value, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: valueColor ?? Colors.black87)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _CatalogDivider extends StatelessWidget {
  const _CatalogDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Colors.grey.shade100);
  }
}

/// Placeholder peta sederhana tanpa dependency google_maps — cukup untuk
/// menunjukkan lokasi kira-kira tempat pengembalian barang secara visual.
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.locationLabel});
  final String locationLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 110,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: const Color(0xFFE3E9F5)),
            CustomPaint(painter: _MapGridPainter()),
            const Center(
              child: Icon(Icons.location_on, color: Color(0xFF1E3A8A), size: 30),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  locationLabel,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E3A8A).withValues(alpha: 0.12)
      ..strokeWidth = 1;
    const step = 22.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) => false;
}