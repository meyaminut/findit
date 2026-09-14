import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/report.dart';
import '../../widgets/responsive_wrapper.dart';
import 'components/report_detail/catalog_details_card.dart';
import 'components/report_detail/custodian_info_card.dart';
import 'components/report_detail/detail_hero_header.dart';
import 'components/report_detail/verification_timeline.dart';

/// Halaman Report Detail — menampilkan status verifikasi sebuah laporan
/// (Lost/Found), termasuk timeline 4 tahap, kartu konfirmasi admin,
/// data custodian/penemu, dan detail katalog barang.
class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({super.key, required this.report, this.onStatusChanged});
  final Report report;
  final void Function(ReportStatus status)? onStatusChanged;

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
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
    widget.onStatusChanged?.call(ReportStatus.dikembalikan);
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
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, report),
        ),
        titleSpacing: 0,
        title: Row(
          children: const [
            Icon(Icons.search, size: 18, color: Colors.black54),
            SizedBox(width: 6),
            Text('Report Detail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
      body: ResponsiveContainer(
        maxWidth: 820,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
          _buildCaseFileRow(),
          const SizedBox(height: 12),
          DetailHeroHeader(
            report: report,
            stageIndex: _stageIndex,
            badgeColor: _stageColor(_stageIndex),
          ),
          const SizedBox(height: 20),
          VerificationTimeline(
            stageIndex: _stageIndex,
            stageOrder: _stageOrder,
            stageLabels: _stageLabels,
            stageColor: _stageColor,
          ),
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
            CustodianInfoCard(
              report: report,
              onCall: _callFinder,
              onMessage: _messageFinder,
            ),
          ],
          const SizedBox(height: 24),
          CatalogDetailsCard(
            report: report,
            hasCustodian: _hasCustodian,
            onCopyIdentifier: _copyIdentifier,
            formatDate: _formatDate,
          ),
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
    ),
  );
}

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

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
        child: Icon(icon, size: 17, color: Colors.black87),
      ),
    );
  }
}
