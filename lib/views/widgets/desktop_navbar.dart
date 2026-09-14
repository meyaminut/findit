import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

enum DesktopNavTab {
  dashboard,
  search,
  myReports,
  notifications,
}

class DesktopNavbar extends StatelessWidget {
  const DesktopNavbar({
    super.key,
    required this.activeTab,
    required this.profile,
    this.unreadAlerts = 0,
    required this.onDashboardTap,
    required this.onSearchTap,
    required this.onMyReportsTap,
    required this.onAlertsTap,
    required this.onLostTap,
    required this.onFoundTap,
    this.onAdminTap,
    this.onProfileTap,
  });

  final DesktopNavTab activeTab;
  final UserProfile profile;
  final int unreadAlerts;
  final VoidCallback onDashboardTap;
  final VoidCallback onSearchTap;
  final VoidCallback onMyReportsTap;
  final VoidCallback onAlertsTap;
  final VoidCallback onLostTap;
  final VoidCallback onFoundTap;
  final VoidCallback? onAdminTap;
  final VoidCallback? onProfileTap;

  static const navy = Color(0xFF1E3A8A);

  void _showReportChoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.add_circle_outline, color: navy),
            SizedBox(width: 8),
            Text('Buat Laporan Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: const Color(0xFFFEF2F2),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFEE2E2),
                child: Icon(Icons.report_problem_outlined, color: Colors.red),
              ),
              title: const Text('Lapor Barang Hilang (Lost)', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Kehilangan barang di lingkungan kampus atau area publik.'),
              onTap: () {
                Navigator.pop(ctx);
                onLostTap();
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: const Color(0xFFF0FDF4),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFDCFCE7),
                child: Icon(Icons.volunteer_activism_outlined, color: Colors.green),
              ),
              title: const Text('Lapor Barang Temuan (Found)', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Menemukan barang dan ingin mengamankan atau menyerahkannya.'),
              onTap: () {
                Navigator.pop(ctx);
                onFoundTap();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final showSearchPill = w >= 1250;
              final showProfileName = w >= 1150;
              final showBrandSubtitle = w >= 1000;

              return Row(
                children: [
                  // Logo & Brand Name
                  InkWell(
                    onTap: onDashboardTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 32,
                          width: 85,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'FindIt!',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: navy,
                                letterSpacing: -0.3,
                              ),
                            ),
                            if (showBrandSubtitle)
                              const Text(
                                'Smart Campus Radar',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Navigation Links
                  _NavLink(
                    label: 'Dashboard',
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard,
                    active: activeTab == DesktopNavTab.dashboard,
                    onTap: onDashboardTap,
                  ),
                  const SizedBox(width: 4),
                  _NavLink(
                    label: 'Cari',
                    icon: Icons.search,
                    activeIcon: Icons.search,
                    active: activeTab == DesktopNavTab.search,
                    onTap: onSearchTap,
                  ),
                  const SizedBox(width: 4),
                  _NavLink(
                    label: 'Laporan Saya',
                    icon: Icons.assignment_outlined,
                    activeIcon: Icons.assignment,
                    active: activeTab == DesktopNavTab.myReports,
                    onTap: onMyReportsTap,
                  ),

                  const Spacer(),

                  // Quick Search Pill or Icon Button
                  if (showSearchPill)
                    InkWell(
                      onTap: onSearchTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 36,
                        width: 170,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 15, color: Colors.black45),
                            const SizedBox(width: 6),
                            const Expanded(
                              child: Text(
                                'Cari barang...',
                                style: TextStyle(fontSize: 11, color: Colors.black45),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              child: const Text(
                                '⌘K',
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black45),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black54, size: 20),
                      tooltip: 'Cari barang',
                      onPressed: onSearchTap,
                    ),

                  const SizedBox(width: 8),

                  // Action Button: + Lapor
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => _showReportChoiceDialog(context),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Lapor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),

                  const SizedBox(width: 8),

                  // Notifications
                  InkWell(
                    onTap: onAlertsTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: activeTab == DesktopNavTab.notifications ? const Color(0xFFEFF6FF) : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: unreadAlerts > 0
                            ? Badge(
                                label: Text('$unreadAlerts'),
                                backgroundColor: Colors.orange,
                                child: const Icon(Icons.notifications_none, color: Colors.black87, size: 19),
                              )
                            : const Icon(Icons.notifications_none, color: Colors.black87, size: 19),
                      ),
                    ),
                  ),

                  // Admin Portal Pill
                  if (profile.isAdmin && onAdminTap != null) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: onAdminTap,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E7FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFC7D2FE)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.shield_outlined, size: 13, color: navy),
                            SizedBox(width: 4),
                            Text(
                              'Admin',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: navy),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(width: 8),

                  // Profile Avatar & Name
                  InkWell(
                    onTap: onProfileTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: navy.withValues(alpha: 0.1),
                          backgroundImage: profile.photoPath != null ? FileImage(File(profile.photoPath!)) : null,
                          child: profile.photoPath == null
                              ? Text(
                                  profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 12),
                                )
                              : null,
                        ),
                        if (showProfileName) ...[
                          const SizedBox(width: 6),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              Text(
                                profile.isAdmin ? 'Campus Admin' : 'Member',
                                style: const TextStyle(fontSize: 9, color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool active;
  final VoidCallback onTap;

  static const navy = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEFF6FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? activeIcon : icon,
              size: 16,
              color: active ? navy : Colors.black54,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
                color: active ? navy : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
