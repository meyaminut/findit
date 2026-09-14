import 'package:flutter/material.dart';
import '../../../../models/user_profile.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.userProfile,
    required this.onBackToUserDashboard,
    required this.onLogout,
  });

  final UserProfile userProfile;
  final VoidCallback onBackToUserDashboard;
  final VoidCallback onLogout;

  static const navy = Color(0xFF1E3A8A);
  static const activeBlue = Color(0xFFE0E7FF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        width: 225,
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Menu Items
          _SidebarItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            onTap: onBackToUserDashboard,
          ),
          _SidebarItem(
            icon: Icons.add_circle_outline,
            label: 'Report Lost Item',
            onTap: onBackToUserDashboard,
          ),
          _SidebarItem(
            icon: Icons.auto_awesome_outlined,
            label: 'Report Found Item',
            onTap: onBackToUserDashboard,
          ),
          _SidebarItem(
            icon: Icons.search,
            label: 'Search & Browse',
            onTap: onBackToUserDashboard,
          ),
          _SidebarItem(
            icon: Icons.folder_open_outlined,
            label: 'My Reports',
            onTap: onBackToUserDashboard,
          ),
          _SidebarItem(
            icon: Icons.notifications_none,
            label: 'Notifications',
            badgeText: '3',
            onTap: onBackToUserDashboard,
          ),

          const Spacer(),

          // Bottom Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Material(
              color: activeBlue,
              borderRadius: BorderRadius.circular(10),
              child: const ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(Icons.shield_outlined, color: navy, size: 18),
                title: Text(
                  'Admin Portal',
                  style: TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          _SidebarItem(
            icon: Icons.help_outline,
            label: 'Help & Support',
            onTap: () {},
          ),

          const SizedBox(height: 8),
          const Divider(height: 1),

          // User Card Profile
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: navy,
                  child: Text(
                    userProfile.name.isNotEmpty
                        ? userProfile.name.substring(0, userProfile.name.length >= 2 ? 2 : 1).toUpperCase()
                        : 'SJ',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        userProfile.name.isNotEmpty ? userProfile.name : 'Sarah Jenkins',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'Campus Member',
                        style: TextStyle(fontSize: 10, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 16, color: Colors.black45),
                  onPressed: onLogout,
                  tooltip: 'Logout',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    this.badgeText,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? badgeText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(icon, color: Colors.black87, size: 18),
        title: Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        trailing: badgeText != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: Color(0xFFD97706),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
