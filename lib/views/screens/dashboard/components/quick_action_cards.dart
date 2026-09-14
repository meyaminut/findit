import 'package:flutter/material.dart';

class QuickActionCards extends StatelessWidget {
  const QuickActionCards({
    super.key,
    required this.onLostTap,
    required this.onFoundTap,
  });

  final VoidCallback onLostTap;
  final VoidCallback onFoundTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.report_problem_outlined,
            iconColor: Colors.orange,
            title: 'Report Lost',
            subtitle: 'Missing something? Flag it now',
            onTap: onLostTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.volunteer_activism_outlined,
            iconColor: Colors.green,
            title: 'Report Found',
            subtitle: 'Found belongings? Help return it',
            onTap: onFoundTap,
          ),
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: iconColor.withValues(alpha: 0.12),
                  child: Icon(icon, color: iconColor, size: 16),
                ),
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
