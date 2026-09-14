import 'package:flutter/material.dart';
import '../../../../models/user_profile.dart';

class AdminTopBar extends StatelessWidget {
  const AdminTopBar({
    super.key,
    required this.userProfile,
    required this.onSearchChanged,
    this.onMenuTap,
  });

  final UserProfile userProfile;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 20 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (onMenuTap != null) ...[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuTap,
            ),
            const SizedBox(width: 4),
          ],

          // Search Field
          Expanded(
            child: Container(
              height: 36,
              constraints: const BoxConstraints(maxWidth: 380),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.search, size: 16, color: Colors.black45),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: onSearchChanged,
                      style: const TextStyle(fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'Search lost & found...',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.black45),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (isDesktop)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        '⌘K',
                        style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (isDesktop) ...[
            const SizedBox(width: 16),
            // Station Location Status
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                const Text(
                  'Desk Station: North Quad Center',
                  style: TextStyle(fontSize: 11.5, color: Colors.black54, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const Spacer(),

            // Guide
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.help_outline, size: 15, color: Colors.black54),
                    SizedBox(width: 4),
                    Text('Guide', style: TextStyle(fontSize: 11.5, color: Colors.black54, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),
          ],

          const SizedBox(width: 8),

          // Bell notification
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, size: 20, color: Colors.black54),
                onPressed: () {},
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),

          // Profile User
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xFF1E3A8A),
                child: Text(
                  userProfile.name.isNotEmpty
                      ? userProfile.name.substring(0, userProfile.name.length >= 2 ? 2 : 1).toUpperCase()
                      : 'SJ',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              if (isDesktop) ...[
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.name.isNotEmpty ? userProfile.name : 'Sarah Jenkins',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Campus Member',
                      style: TextStyle(fontSize: 10, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
