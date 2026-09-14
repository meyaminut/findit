import 'package:flutter/material.dart';

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({
    super.key,
    required this.onSearchTap,
    required this.onMyReportsTap,
    required this.onAlertsTap,
  });

  final VoidCallback onSearchTap;
  final VoidCallback onMyReportsTap;
  final VoidCallback onAlertsTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: Colors.white,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const _NavItem(icon: Icons.home_filled, label: 'Home', active: true),
                _NavItem(icon: Icons.search, label: 'Search', onTap: onSearchTap),
                const SizedBox(width: 40),
                _NavItem(icon: Icons.assignment_outlined, label: 'My Reports', onTap: onMyReportsTap),
                _NavItem(icon: Icons.notifications_none, label: 'Alerts', onTap: onAlertsTap),
              ],
            ),
          ),
        ),
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
