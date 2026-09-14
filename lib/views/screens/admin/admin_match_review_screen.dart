import 'package:flutter/material.dart';
import '../../../controllers/admin_match_controller.dart';
import '../../../models/user_profile.dart';
import '../auth/login_screen.dart';
import '../dashboard/home_dashboard_screen.dart';
import 'components/admin_sidebar.dart';
import 'components/admin_top_bar.dart';
import 'components/hero_match_card.dart';
import 'components/match_adjudication_bar.dart';
import 'components/match_filter_bar.dart';
import 'components/multi_modal_breakdown.dart';
import 'components/pending_matches_table.dart';

class AdminMatchReviewScreen extends StatefulWidget {
  const AdminMatchReviewScreen({
    super.key,
    this.userProfile,
  });

  final UserProfile? userProfile;

  @override
  State<AdminMatchReviewScreen> createState() => _AdminMatchReviewScreenState();
}

class _AdminMatchReviewScreenState extends State<AdminMatchReviewScreen> {
  late final AdminMatchController _controller;
  late final UserProfile _profile;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AdminMatchController();
    _profile = widget.userProfile ??
        UserProfile(
          name: 'Sarah Jenkins',
          email: 'sarah.j@campus.edu',
          phone: '',
          role: 'admin',
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onConfirm(String note) {
    final candidate = _controller.selectedCandidate;
    if (candidate == null) return;
    _controller.confirmMatch(candidate.id, note);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Match ${candidate.id} confirmed! Notifications dispatched to reporter and finder.',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onReject(String note) {
    final candidate = _controller.selectedCandidate;
    if (candidate == null) return;
    _controller.rejectMatch(candidate.id, note);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cancel, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Match ${candidate.id} rejected and logged in desk audit.',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onRequestInfo() {
    final candidate = _controller.selectedCandidate;
    if (candidate == null) return;
    _controller.requestInfo(candidate.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.help_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Request for additional item details sent to reporter.',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onBackToUserDashboard() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeDashboardScreen(
            initialProfile: _profile,
          ),
        ),
      );
    }
  }

  void _onLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to sign out from the Admin Portal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBody(BuildContext context, bool isDesktop) {
    final candidate = _controller.selectedCandidate;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 28 : 16,
        vertical: isDesktop ? 20 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter & Queue Header
          MatchFilterBar(
            controller: _controller,
            onRefresh: () {
              _controller.refreshQueue();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Match Queue refreshed with latest detections'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 18),

          // Hero Match Review Section
          if (candidate != null) ...[
            HeroMatchCard(candidate: candidate),
            const SizedBox(height: 14),
            MultiModalBreakdownCard(candidate: candidate),
            const SizedBox(height: 14),
            MatchAdjudicationBar(
              candidate: candidate,
              onConfirm: _onConfirm,
              onReject: _onReject,
              onRequestInfo: _onRequestInfo,
            ),
          ] else
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                child: Text(
                  'No match candidate selected or matching criteria.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ),
            ),
          const SizedBox(height: 24),

          // Pending Candidates Table
          PendingMatchesTable(controller: _controller),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;

        if (isDesktop) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            body: Row(
              children: [
                // Left Permanent Sidebar
                AdminSidebar(
                  userProfile: _profile,
                  onBackToUserDashboard: _onBackToUserDashboard,
                  onLogout: _onLogout,
                ),
                // Main Workspace
                Expanded(
                  child: Column(
                    children: [
                      AdminTopBar(
                        userProfile: _profile,
                        onSearchChanged: (val) => _controller.setSearchQuery(val),
                      ),
                      Expanded(
                        child: ListenableBuilder(
                          listenable: _controller,
                          builder: (context, _) => _buildContentBody(context, true),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Tablet & Mobile View with Drawer
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF8FAFC),
          drawer: Drawer(
            child: AdminSidebar(
              userProfile: _profile,
              onBackToUserDashboard: () {
                Navigator.pop(context);
                _onBackToUserDashboard();
              },
              onLogout: _onLogout,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                AdminTopBar(
                  userProfile: _profile,
                  onSearchChanged: (val) => _controller.setSearchQuery(val),
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                Expanded(
                  child: ListenableBuilder(
                    listenable: _controller,
                    builder: (context, _) => _buildContentBody(context, false),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
