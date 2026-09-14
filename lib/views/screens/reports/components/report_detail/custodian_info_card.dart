import 'package:flutter/material.dart';
import '../../../../../models/report.dart';

class CustodianInfoCard extends StatelessWidget {
  const CustodianInfoCard({
    super.key,
    required this.report,
    required this.onCall,
    required this.onMessage,
  });

  final Report report;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  static const navy = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lock_outline, size: 15, color: Colors.black87),
            const SizedBox(width: 6),
            const Text(
              'CUSTODIAN DETAILS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.4),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
              child: Text(
                'Encrypted Reveal',
                style: TextStyle(color: Colors.amber.shade800, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
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
                  const CircleAvatar(radius: 22, backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CUSTODIAN / FINDER',
                          style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 0.4),
                        ),
                        const SizedBox(height: 2),
                        Text(report.custodianName ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        if (report.custodianRole != null)
                          Text(report.custodianRole!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (report.custodianPhone != null) ...[
                _ContactRow(icon: Icons.call_outlined, value: report.custodianPhone!),
                const SizedBox(height: 8),
              ],
              if (report.custodianEmail != null) _ContactRow(icon: Icons.mail_outline, value: report.custodianEmail!),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: navy, padding: const EdgeInsets.symmetric(vertical: 12)),
                      onPressed: report.custodianPhone != null ? onCall : null,
                      icon: const Icon(Icons.call, size: 16),
                      label: const Text('Call Finder'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: navy,
                        side: const BorderSide(color: navy),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: onMessage,
                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                      label: const Text('Message'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.value});
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF1E3A8A)),
        const SizedBox(width: 10),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
