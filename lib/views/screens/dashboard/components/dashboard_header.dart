import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../models/user_profile.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.profile,
    required this.unreadAlerts,
    required this.onAlertsTap,
    required this.onProfileTap,
    this.onAdminTap,
  });

  final UserProfile profile;
  final int unreadAlerts;
  final VoidCallback onAlertsTap;
  final VoidCallback onProfileTap;
  final VoidCallback? onAdminTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 34,
          fit: BoxFit.contain,
        ),
        const Spacer(),
        if (profile.isAdmin && onAdminTap != null) ...[
          InkWell(
            onTap: onAdminTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E7FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFC7D2FE)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.shield_outlined, size: 13, color: Color(0xFF1E3A8A)),
                  SizedBox(width: 4),
                  Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        InkWell(
          onTap: onAlertsTap,
          customBorder: const CircleBorder(),
          child: unreadAlerts > 0
              ? Badge(
                  label: Text('$unreadAlerts'),
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.notifications_none),
                )
              : const Icon(Icons.notifications_none),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onProfileTap,
          customBorder: const CircleBorder(),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey,
            backgroundImage: profile.photoPath != null ? FileImage(File(profile.photoPath!)) : null,
            child: profile.photoPath == null ? const Icon(Icons.person, size: 18, color: Colors.white) : null,
          ),
        ),
      ],
    );
  }
}
