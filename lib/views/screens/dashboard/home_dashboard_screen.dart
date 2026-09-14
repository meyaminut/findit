import 'package:flutter/material.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/notification_controller.dart';
import '../../../controllers/report_controller.dart';
import '../../../models/report.dart';
import '../../../models/user_profile.dart';
import '../../widgets/activity_card.dart';
import '../../widgets/desktop_navbar.dart';
import '../../widgets/responsive_wrapper.dart';
import '../notifications/notifications_screen.dart';
import '../admin/admin_match_review_screen.dart';
import '../profile/profile_screen.dart';
import '../reports/my_reports_screen.dart';
import '../reports/report_detail_screen.dart';
import '../reports/report_found_screen.dart';
import '../reports/report_lost_screen.dart';
import '../reports/search_screen.dart';
import 'components/activity_header.dart';
import 'components/ai_cross_check_banner.dart';
import 'components/civic_radar_banner.dart';
import 'components/dashboard_bottom_nav.dart';
import 'components/dashboard_header.dart';
import 'components/dashboard_stats_card.dart';
import 'components/quick_action_cards.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({
    super.key,
    this.userName = 'Sarah',
    this.initialProfile,
    this.authController,
    this.reportController,
    this.notificationController,
  });

  final String userName;
  final UserProfile? initialProfile;
  final AuthController? authController;
  final ReportController? reportController;
  final NotificationController? notificationController;

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  static const navy = Color(0xFF1E3A8A);

  late final AuthController _authController;
  late final ReportController _reportController;
  late final NotificationController _notificationController;

  @override
  void initState() {
    super.initState();
    _authController = widget.authController ??
        AuthController(
          initialProfile: widget.initialProfile ??
              UserProfile(name: widget.userName, email: 'sarah@example.com', phone: ''),
        );
    _reportController = widget.reportController ?? ReportController();
    _notificationController = widget.notificationController ?? NotificationController();

    _authController.addListener(_onStateChanged);
    _reportController.addListener(_onStateChanged);
    _notificationController.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _authController.removeListener(_onStateChanged);
    _reportController.removeListener(_onStateChanged);
    _notificationController.removeListener(_onStateChanged);
    super.dispose();
  }

  UserProfile get _profile =>
      _authController.currentUser ??
      widget.initialProfile ??
      UserProfile(name: widget.userName, email: 'sarah@example.com', phone: '');

  Future<void> _openLostForm() async {
    final result = await Navigator.push<Report>(
      context,
      MaterialPageRoute(builder: (_) => const ReportLostScreen()),
    );
    if (result != null) {
      _reportController.addReport(result);
    }
  }

  Future<void> _openFoundForm() async {
    final result = await Navigator.push<Report>(
      context,
      MaterialPageRoute(builder: (_) => const ReportFoundScreen()),
    );
    if (result != null) {
      _reportController.addReport(result);
    }
  }

  void _openAlerts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationsScreen(controller: _notificationController),
      ),
    );
  }

  Future<void> _openSearch() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(controller: _reportController),
      ),
    );
  }

  Future<void> _openMyReports() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyReportsScreen(controller: _reportController),
      ),
    );
  }

  Future<void> _openProfile() async {
    final result = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          profile: _profile,
          authController: _authController,
        ),
      ),
    );
    if (result != null) {
      _authController.setProfile(result);
    }
  }

  void _openAdminPortal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminMatchReviewScreen(userProfile: _profile),
      ),
    );
  }

  void _openReportDetail(Report r) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportDetailScreen(
          report: r,
          onStatusChanged: (newStatus) {
            _reportController.updateReportStatus(r.id, newStatus);
          },
        ),
      ),
    );
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
    final reports = _reportController.reports;
    final desktop = isDesktop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Column(
          children: [
            if (desktop)
              DesktopNavbar(
                activeTab: DesktopNavTab.dashboard,
                profile: _profile,
                unreadAlerts: _notificationController.unreadCount,
                onDashboardTap: () {},
                onSearchTap: _openSearch,
                onMyReportsTap: _openMyReports,
                onAlertsTap: _openAlerts,
                onLostTap: _openLostForm,
                onFoundTap: _openFoundForm,
                onAdminTap: _profile.isAdmin ? _openAdminPortal : null,
                onProfileTap: _openProfile,
              ),
            Expanded(
              child: ResponsiveContainer(
                maxWidth: desktop ? 1240 : 1060,
                padding: EdgeInsets.fromLTRB(16, desktop ? 24 : 12, 16, desktop ? 40 : 90),
                child: ListView(
                  children: [
                    if (!desktop) ...[
                      DashboardHeader(
                        profile: _profile,
                        unreadAlerts: _notificationController.unreadCount,
                        onAlertsTap: _openAlerts,
                        onProfileTap: _openProfile,
                        onAdminTap: _profile.isAdmin ? _openAdminPortal : null,
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (desktop)
                      // Layout 2 Kolom untuk Desktop / Layar Lebar
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kolom Kiri: Konten Utama (Civic Radar, Aksi Cepat, Feed Laporan Grid)
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CivicRadarBanner(
                                  userName: _profile.name,
                                  totalReports: _reportController.totalReports,
                                ),
                                const SizedBox(height: 16),
                                QuickActionCards(
                                  onLostTap: _openLostForm,
                                  onFoundTap: _openFoundForm,
                                ),
                                const SizedBox(height: 24),
                                ActivityHeader(
                                  count: _reportController.totalReports,
                                  onFilterTap: _openSearch,
                                  onViewAllTap: _openMyReports,
                                ),
                                const SizedBox(height: 12),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final crossCount = constraints.maxWidth > 580 ? 2 : 1;
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossCount,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        mainAxisExtent: 155,
                                      ),
                                      itemCount: reports.length,
                                      itemBuilder: (context, index) {
                                        final r = reports[index];
                                        return ActivityCard(
                                          report: r,
                                          timeAgoText: _timeAgo(r.date),
                                          onTap: () => _openReportDetail(r),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Kolom Kanan: Sidebar (AI Smart Check, Statistik & Panduan)
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                const AiCrossCheckBanner(),
                                const SizedBox(height: 16),
                                DashboardStatsCard(
                                  matchedCount: _reportController.matchedReports,
                                  returnedCount: _reportController.returnedReports,
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.verified_user_outlined, size: 18, color: navy),
                                          SizedBox(width: 8),
                                          Text(
                                            'Panduan Keamanan Kampus',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: navy),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Barang berharga (laptop, dompet, kunci) yang ditemukan wajib diserahkan ke Desk Station terdekat dalam 24 jam untuk verifikasi sistem AI.',
                                        style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: const [
                                          Icon(Icons.location_on_outlined, size: 14, color: Colors.black45),
                                          SizedBox(width: 4),
                                          Text('Station Utama: Gedung Pusat Lt. 1', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
              else
                // Layout 1 Kolom Vertikal untuk Mobile
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CivicRadarBanner(
                      userName: _profile.name,
                      totalReports: _reportController.totalReports,
                    ),
                    const SizedBox(height: 16),
                    const AiCrossCheckBanner(),
                    const SizedBox(height: 16),
                    QuickActionCards(
                      onLostTap: _openLostForm,
                      onFoundTap: _openFoundForm,
                    ),
                    const SizedBox(height: 16),
                    DashboardStatsCard(
                      matchedCount: _reportController.matchedReports,
                      returnedCount: _reportController.returnedReports,
                    ),
                    const SizedBox(height: 20),
                    ActivityHeader(
                      count: _reportController.totalReports,
                      onFilterTap: _openSearch,
                      onViewAllTap: _openMyReports,
                    ),
                    const SizedBox(height: 12),
                    ...reports.map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ActivityCard(
                            report: r,
                            timeAgoText: _timeAgo(r.date),
                            onTap: () => _openReportDetail(r),
                          ),
                        )),
                  ],
                ),
            ],
          ),
        ),
      ),
    ],
  ),
),
      floatingActionButton: desktop
          ? null
          : FloatingActionButton(
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
      floatingActionButtonLocation: desktop ? null : FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: desktop
          ? null
          : DashboardBottomNav(
              onSearchTap: _openSearch,
              onMyReportsTap: _openMyReports,
              onAlertsTap: _openAlerts,
            ),
    );
  }
}
