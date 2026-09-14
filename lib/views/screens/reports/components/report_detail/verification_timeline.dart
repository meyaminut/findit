import 'package:flutter/material.dart';
import '../../../../../models/report.dart';

class VerificationTimeline extends StatelessWidget {
  const VerificationTimeline({
    super.key,
    required this.stageIndex,
    required this.stageOrder,
    required this.stageLabels,
    required this.stageColor,
  });

  final int stageIndex;
  final List<ReportStatus> stageOrder;
  final List<String> stageLabels;
  final Color Function(int i) stageColor;

  static const navy = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'VERIFICATION TIMELINE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.4),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: navy.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
              child: Text(
                'Stage ${stageIndex + 1} of 4',
                style: const TextStyle(color: navy, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 60,
          child: Stack(
            children: [
              Positioned(
                top: 15,
                left: 15,
                right: 15,
                child: Row(
                  children: List.generate(stageOrder.length - 1, (i) {
                    final passed = i < stageIndex;
                    return Expanded(
                      child: Container(height: 2, color: passed ? navy : Colors.grey.shade300),
                    );
                  }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(stageOrder.length, (i) {
                  return _TimelineDot(
                    label: stageLabels[i],
                    done: i < stageIndex,
                    current: i == stageIndex,
                    color: stageColor(i),
                    icon: stageOrder[i] == ReportStatus.dikonfirmasi ? Icons.lock_outline : null,
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({
    required this.label,
    required this.done,
    required this.current,
    required this.color,
    this.icon,
  });

  final String label;
  final bool done;
  final bool current;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final active = done || current;
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? color : Colors.white,
            border: Border.all(color: active ? color : Colors.grey.shade300, width: 2),
          ),
          child: Icon(
            done ? Icons.check : (current ? (icon ?? Icons.circle) : Icons.circle_outlined),
            size: done ? 16 : (current ? 14 : 10),
            color: active ? Colors.white : Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? Colors.black87 : Colors.black38,
          ),
        ),
      ],
    );
  }
}
