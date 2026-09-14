import 'package:flutter/material.dart';

class CivicRadarBanner extends StatelessWidget {
  const CivicRadarBanner({
    super.key,
    required this.userName,
    required this.totalReports,
  });

  final String userName;
  final int totalReports;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'LIVE CIVIC RADAR',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome back, $userName',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.location_on, size: 14, color: Colors.black45),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Active scanning across $totalReports community reports',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
          ],
        ),
      ],
    );
  }
}
