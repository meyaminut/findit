import 'dart:io';
import 'package:flutter/material.dart';
import '../models/report.dart';
import '../widgets/status_badge.dart';
import 'report_lost_screen.dart';
import 'report_form_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'my_reports_screen.dart';
import '../models/user_profile.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key, this.userName = 'Sarah', this.initialProfile});
  final String userName;
  final UserProfile? initialProfile;

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  static const navy = Color(0xFF1E3A8A);

  // TODO(integrasi API): ganti data dummy ini dengan hasil GET /api/users/:id
  late UserProfile _profile =
      widget.initialProfile ?? UserProfile(name: widget.userName, email: 'sarah@example.com', phone: '');

  final List<Report> reports = [
    Report(
      id: '1',
      title: 'Midnight Blue MacBook Pro 14"',
      category: 'Electronics',
      description: '',
      location: 'Central Transit Station, Line 2',
      date: DateTime.now(),
      type: ReportType.lost,
      status: ReportStatus.dicocokkan,
      activityNote: '94% AI Match Found',
    ),
    Report(
      id: '2',
      title: 'Leather Bellroy Key Cover (Br...)',
      category: 'Accessories',
      description: '',
      location: 'Civic Plaza Coffeehouse',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: ReportType.found,
      status: ReportStatus.dikonfirmasi,
      activityNote: 'Claim verified by barista',
    ),
    Report(
      id: '3',
      title: 'Matte Black Tortoise Sunglas...',
      category: 'Personal Items',
      description: '',
      location: 'Riverfront Park Trail',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: ReportType.lost,
      status: ReportStatus.baru,
      activityNote: 'Scanning perimeter (2km)',
    ),
    Report(
      id: '4',
      title: 'Tan Leather Bi-Fold Wallet (Ini...)',
      category: 'Wallets',
      description: '',
      location: 'Metropolitan Library 2F',
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: ReportType.found,
      status: ReportStatus.dikembalikan,
      activityNote: 'Reunited with owner',
    ),
  ];

  Future<void> _openLostForm() async {
    final result = await Navigator.push<Report>(
      context,
      MaterialPageRoute(builder: (_) => const ReportLostScreen()),
    );
    if (result != null) setState(() => reports.insert(0, result));
  }

  Future<void> _openFoundForm() async {
    final result = await Navigator.push<Report>(
      context,
      MaterialPageRoute(builder: (_) => const ReportFormScreen(type: ReportType.found)),
    );
    if (result != null) setState(() => reports.insert(0, result));
  }

  void _openAlerts() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
  }

  Future<void> _openSearch() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen(reports: reports)));
  }

  Future<void> _openMyReports() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => MyReportsScreen(reports: reports)));
    // Reports dilewatkan sebagai referensi yang sama, jadi kita cukup
    // rebuild supaya perubahan status di My Reports langsung terlihat di Home.
    setState(() {});
  }

  Future<void> _openProfile() async {
    final result = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen(profile: _profile)),
    );
    if (result != null) setState(() => _profile = result);
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) {
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final period = date.hour >= 12 ? 'PM' : 'AM';
      final minute = date.minute.toString().padLeft(2, '0');
      return 'Today, $hour:$minute $period';
    }
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildWelcomeBlock(),
            const SizedBox(height: 16),
            _buildAiCrossCheckCard(),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 16),
            _buildStatsCard(),
            const SizedBox(height: 20),
            _buildActivityHeader(),
            const SizedBox(height: 12),
            ...reports.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ActivityCard(report: r, timeAgoText: _timeAgo(r.date)),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: navy,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.report_problem_outlined, color: Colors.orange),
                    title: const Text('Report Lost Item'),
                    onTap: () {
                      Navigator.pop(context);
                      _openLostForm();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.volunteer_activism_outlined, color: Colors.green),
                    title: const Text('Report Found Item'),
                    onTap: () {
                      Navigator.pop(context);
                      _openFoundForm();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_filled, label: 'Home', active: true),
              _NavItem(icon: Icons.search, label: 'Search', onTap: _openSearch),
              const SizedBox(width: 40),
              _NavItem(icon: Icons.assignment_outlined, label: 'My Reports', onTap: _openMyReports),
              _NavItem(icon: Icons.notifications_none, label: 'Alerts', onTap: _openAlerts),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.travel_explore, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FindIt!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Smart Lost & Found', style: TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: _openAlerts,
          customBorder: const CircleBorder(),
          child: Badge(
            label: const Text('3'),
            backgroundColor: Colors.orange,
            child: const Icon(Icons.notifications_none),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: _openProfile,
          customBorder: const CircleBorder(),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey,
            backgroundImage: _profile.photoPath != null ? FileImage(File(_profile.photoPath!)) : null,
            child: _profile.photoPath == null ? const Icon(Icons.person, size: 18, color: Colors.white) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('LIVE CIVIC RADAR', style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 4),
        Text('Welcome back, ${_profile.name}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.location_on, size: 14, color: Colors.black45),
            const SizedBox(width: 4),
            const Expanded(
              child: Text('Active scanning across 1,420 community reports', style: TextStyle(fontSize: 12, color: Colors.black54)),
            ),
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
          ],
        ),
      ],
    );
  }

  Widget _buildAiCrossCheckCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: navy.withOpacity(0.06), borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.shield_outlined, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('AI Smart Cross-Check Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Text('Real-time', style: TextStyle(fontSize: 10, color: navy, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Our matching engine continuously compares item descriptions, geo-coordinates, and timestamps across city channels in real-time.',
                  style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.report_problem_outlined,
            iconColor: Colors.orange,
            title: 'Report Lost',
            subtitle: 'Missing something? Flag it now',
            onTap: _openLostForm,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.volunteer_activism_outlined,
            iconColor: Colors.green,
            title: 'Report Found',
            subtitle: 'Found belongings? Help return it',
            onTap: _openFoundForm,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('92% Return Accuracy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('48 items reunited this week', style: TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          _Sparkline(data: const [2, 4, 3, 6, 5, 8, 7, 9], color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildActivityHeader() {
    return Row(
      children: [
        const Text('Recent Community Activity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
          child: Text('${reports.length}', style: const TextStyle(fontSize: 11)),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.filter_list, size: 16),
          label: const Text('Filter', style: TextStyle(fontSize: 12)),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
          child: const Text('View all', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 16, backgroundColor: iconColor.withOpacity(0.12), child: Icon(icon, color: iconColor, size: 16)),
                const Spacer(),
                const Icon(Icons.arrow_forward, size: 16, color: Colors.black38),
              ],
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.report, required this.timeAgoText});
  final Report report;
  final String timeAgoText;

  Color get _noteColor => switch (report.status) {
    ReportStatus.baru => Colors.black54,
    ReportStatus.dicocokkan => Colors.green,
    ReportStatus.dikonfirmasi => Colors.amber.shade800,
    ReportStatus.dikembalikan => Colors.green,
  };

  IconData get _noteIcon => switch (report.status) {
    ReportStatus.baru => Icons.search,
    ReportStatus.dicocokkan => Icons.check_circle_outline,
    ReportStatus.dikonfirmasi => Icons.verified_outlined,
    ReportStatus.dikembalikan => Icons.handshake_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final isLost = report.type == ReportType.lost;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isLost ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isLost ? 'LOST' : 'FOUND',
                  style: TextStyle(
                    color: isLost ? Colors.red.shade700 : Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(report.category, style: const TextStyle(fontSize: 11, color: Colors.black54)),
              const Spacer(),
              StatusBadge(status: report.status, showDot: true),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: report.photoPath != null
                    ? Image.file(File(report.photoPath!), width: 48, height: 48, fit: BoxFit.cover)
                    : Container(
                  width: 48,
                  height: 48,
                  color: Colors.grey.shade100,
                  child: Icon(isLost ? Icons.help_outline : Icons.inventory_2_outlined, color: Colors.black38),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 12, color: Colors.black38),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(report.location, style: const TextStyle(fontSize: 11, color: Colors.black54), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (report.activityNote != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(_noteIcon, size: 14, color: _noteColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(report.activityNote!, style: TextStyle(fontSize: 11, color: _noteColor, fontWeight: FontWeight.w600)),
                ),
                Text(timeAgoText, style: const TextStyle(fontSize: 10, color: Colors.black38)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, this.active = false, this.onTap});
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF1E3A8A) : Colors.black45;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: color, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _Sparkline extends StatelessWidget {
  const _Sparkline({required this.data, required this.color});
  final List<double> data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 70, height: 30, child: CustomPaint(painter: _SparklinePainter(data, color)));
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.data, this.color);
  final List<double> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
    final maxV = data.reduce((a, b) => a > b ? a : b);
    final minV = data.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV) == 0 ? 1 : (maxV - minV);
    final path = Path();
    for (var i = 0; i < data.length; i++) {
      final x = size.width * i / (data.length - 1);
      final y = size.height - ((data[i] - minV) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => false;
}