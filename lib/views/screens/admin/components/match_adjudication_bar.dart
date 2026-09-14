import 'package:flutter/material.dart';
import '../../../../models/match_candidate.dart';

class MatchAdjudicationBar extends StatefulWidget {
  const MatchAdjudicationBar({
    super.key,
    required this.candidate,
    required this.onConfirm,
    required this.onReject,
    required this.onRequestInfo,
  });

  final MatchCandidate candidate;
  final ValueChanged<String> onConfirm;
  final ValueChanged<String> onReject;
  final VoidCallback onRequestInfo;

  @override
  State<MatchAdjudicationBar> createState() => _MatchAdjudicationBarState();
}

class _MatchAdjudicationBarState extends State<MatchAdjudicationBar> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.candidate.internalAuditNote);
  }

  @override
  void didUpdateWidget(covariant MatchAdjudicationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.candidate.id != widget.candidate.id) {
      _noteController.text = widget.candidate.internalAuditNote;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          if (isDesktop)
            Row(
              children: const [
                Icon(Icons.verified_user_outlined, size: 18, color: Color(0xFF1E3A8A)),
                SizedBox(width: 8),
                Text(
                  'Official Match Adjudication',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                Spacer(),
                Expanded(
                  child: Text(
                    'Approval dispatches pickup authorization code and notifies Sarah Jenkins via SMS/Email.',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.verified_user_outlined, size: 18, color: Color(0xFF1E3A8A)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Official Match Adjudication',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Approval dispatches pickup authorization code and notifies Sarah Jenkins via SMS/Email.',
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          const SizedBox(height: 12),

          const Text(
            'Internal Desk Audit Note',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 6),

          // Note Input + Actions Row/Column
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildTextField(),
                ),
                const SizedBox(width: 14),
                _buildRejectButton(),
                const SizedBox(width: 8),
                _buildInfoButton(),
                const SizedBox(width: 8),
                _buildConfirmButton(),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    _buildRejectButton(),
                    _buildInfoButton(),
                    _buildConfirmButton(),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _noteController,
        style: const TextStyle(fontSize: 11.5, color: Colors.black87),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          border: InputBorder.none,
          hintText: 'Enter internal desk audit note...',
        ),
      ),
    );
  }

  Widget _buildRejectButton() {
    return OutlinedButton.icon(
      onPressed: () => widget.onReject(_noteController.text),
      icon: const Icon(Icons.close, size: 14, color: Colors.red),
      label: const Text('Reject Candidate', style: TextStyle(color: Colors.red, fontSize: 11.5, fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFFCA5A5)),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildInfoButton() {
    return OutlinedButton.icon(
      onPressed: widget.onRequestInfo,
      icon: const Icon(Icons.help_outline, size: 14, color: Colors.black87),
      label: const Text('Request Info', style: TextStyle(color: Colors.black87, fontSize: 11.5, fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade300),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildConfirmButton() {
    final isConfirmed = widget.candidate.status == MatchStatus.confirmed;

    return ElevatedButton.icon(
      onPressed: isConfirmed ? null : () => widget.onConfirm(_noteController.text),
      icon: Icon(isConfirmed ? Icons.check_circle : Icons.check, size: 15, color: Colors.white),
      label: Text(
        isConfirmed ? 'Confirmed' : 'Confirm & Notify Both Parties',
        style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isConfirmed ? Colors.green : const Color(0xFFF59E0B),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }
}
