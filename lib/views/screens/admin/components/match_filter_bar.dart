import 'package:flutter/material.dart';
import '../../../../controllers/admin_match_controller.dart';

class MatchFilterBar extends StatelessWidget {
  const MatchFilterBar({
    super.key,
    required this.controller,
    required this.onRefresh,
  });

  final AdminMatchController controller;
  final VoidCallback onRefresh;

  static const navy = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    final threshold = controller.thresholdFilter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const [
            Text(
              'ADMIN PORTAL',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black45, letterSpacing: 0.5),
            ),
            Text(
              '  /  ',
              style: TextStyle(fontSize: 10, color: Colors.black38),
            ),
            Text(
              'MATCH VERIFICATION CONSOLE',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: navy, letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Title and Status Badges
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 8,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 4,
              children: [
                const Text(
                  'Match Review Queue',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF78350F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${controller.pendingCount} Pending Decisions',
                    style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _StatusBadge(
                  dotColor: Colors.green,
                  label: 'Auto-Match Model v2.4 Active',
                ),
                _StatusBadge(
                  icon: Icons.verified_user_outlined,
                  iconColor: Colors.amber.shade800,
                  label: 'Desk Supervisor: Officer Dave M.',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Filter Controls Bar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Icon(Icons.tune, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              const Text(
                'THRESHOLD:',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.black45, letterSpacing: 0.5),
              ),
              const SizedBox(width: 8),

              // Threshold pills
              _FilterPill(
                label: '> 90% (High Confidence)',
                isSelected: threshold == ScoreThresholdFilter.above90,
                onTap: () => controller.setThreshold(
                  threshold == ScoreThresholdFilter.above90 ? ScoreThresholdFilter.all : ScoreThresholdFilter.above90,
                ),
              ),
              const SizedBox(width: 6),
              _FilterPill(
                label: '80-90%',
                isSelected: threshold == ScoreThresholdFilter.range80to90,
                onTap: () => controller.setThreshold(
                  threshold == ScoreThresholdFilter.range80to90 ? ScoreThresholdFilter.all : ScoreThresholdFilter.range80to90,
                ),
              ),
              const SizedBox(width: 6),
              _FilterPill(
                label: '< 80%',
                isSelected: threshold == ScoreThresholdFilter.below80,
                onTap: () => controller.setThreshold(
                  threshold == ScoreThresholdFilter.below80 ? ScoreThresholdFilter.all : ScoreThresholdFilter.below80,
                ),
              ),

              const SizedBox(width: 14),

              // Category dropdown button
              _ActionButton(
                icon: Icons.category_outlined,
                label: controller.selectedCategory,
                onTap: () {},
              ),

              const SizedBox(width: 8),

              // Date range button
              _ActionButton(
                icon: Icons.calendar_today_outlined,
                label: controller.dateRange,
                onTap: () {},
              ),

              const SizedBox(width: 8),

              // Refresh button
              _ActionButton(
                icon: Icons.refresh,
                label: 'Refresh (${controller.allCandidates.length})',
                onTap: onRefresh,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({this.dotColor, this.icon, this.iconColor, required this.label});
  final Color? dotColor;
  final IconData? icon;
  final Color? iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            const SizedBox(width: 6),
          ] else if (icon != null) ...[
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.isSelected, required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static const navy = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? navy : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? navy : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: Colors.black54),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
