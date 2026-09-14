import 'package:flutter/material.dart';

class AiCrossCheckBanner extends StatelessWidget {
  const AiCrossCheckBanner({super.key});

  static const navy = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: navy.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14)),
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
                      child: const Text('Real-time', style: TextStyle(fontSize: 10, color: navy, fontWeight: FontWeight.w600)),
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
}
