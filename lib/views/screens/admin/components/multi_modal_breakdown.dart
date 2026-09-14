import 'package:flutter/material.dart';
import '../../../../models/match_candidate.dart';

class MultiModalBreakdownCard extends StatelessWidget {
  const MultiModalBreakdownCard({
    super.key,
    required this.candidate,
  });

  final MatchCandidate candidate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          LayoutBuilder(
            builder: (context, headerConstraints) {
              if (headerConstraints.maxWidth > 650) {
                return Row(
                  children: const [
                    Icon(Icons.auto_awesome_mosaic_outlined, size: 16, color: Color(0xFF1E3A8A)),
                    SizedBox(width: 8),
                    Text(
                      'MULTI-MODAL MATCH BREAKDOWN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Confidence Weighting: Vision 45% • Geolocation 30% • Temporal 25%',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 10, color: Colors.black45),
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome_mosaic_outlined, size: 16, color: Color(0xFF1E3A8A)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'MULTI-MODAL MATCH BREAKDOWN',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A8A),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Confidence Weighting: Vision 45% • Geolocation 30% • Temporal 25%',
                      style: TextStyle(fontSize: 10, color: Colors.black45),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 14),

          // 4 Metric Columns in Row (or responsive wrap)
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 650) {
                return Row(
                  children: [
                    Expanded(
                      child: _MetricItem(
                        label: 'Item Model & Specs',
                        value: '${candidate.specsScore}%',
                        subLabel: candidate.specsLabel,
                        barColor: const Color(0xFF10B981),
                        progress: candidate.specsScore / 100,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricItem(
                        label: 'Spatial Proximity',
                        value: '${candidate.spatialScore}%',
                        subLabel: candidate.spatialLabel,
                        barColor: const Color(0xFF0D9488),
                        progress: candidate.spatialScore / 100,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricItem(
                        label: 'Time Delta Gap',
                        value: candidate.timeGap,
                        subLabel: candidate.timeGapLabel,
                        barColor: const Color(0xFF2563EB),
                        progress: 0.85,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricItem(
                        label: 'Distinctive Markings',
                        value: candidate.markingsLabel,
                        subLabel: candidate.markingsSubLabel,
                        barColor: const Color(0xFFF59E0B),
                        progress: 1.0,
                        isAmber: true,
                      ),
                    ),
                  ],
                );
              } else if (constraints.maxWidth > 360) {
                final itemW = (constraints.maxWidth - 12) / 2;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: itemW,
                      child: _MetricItem(
                        label: 'Item Model & Specs',
                        value: '${candidate.specsScore}%',
                        subLabel: candidate.specsLabel,
                        barColor: const Color(0xFF10B981),
                        progress: candidate.specsScore / 100,
                      ),
                    ),
                    SizedBox(
                      width: itemW,
                      child: _MetricItem(
                        label: 'Spatial Proximity',
                        value: '${candidate.spatialScore}%',
                        subLabel: candidate.spatialLabel,
                        barColor: const Color(0xFF0D9488),
                        progress: candidate.spatialScore / 100,
                      ),
                    ),
                    SizedBox(
                      width: itemW,
                      child: _MetricItem(
                        label: 'Time Delta Gap',
                        value: candidate.timeGap,
                        subLabel: candidate.timeGapLabel,
                        barColor: const Color(0xFF2563EB),
                        progress: 0.85,
                      ),
                    ),
                    SizedBox(
                      width: itemW,
                      child: _MetricItem(
                        label: 'Distinctive Markings',
                        value: candidate.markingsLabel,
                        subLabel: candidate.markingsSubLabel,
                        barColor: const Color(0xFFF59E0B),
                        progress: 1.0,
                        isAmber: true,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _MetricItem(
                      label: 'Item Model & Specs',
                      value: '${candidate.specsScore}%',
                      subLabel: candidate.specsLabel,
                      barColor: const Color(0xFF10B981),
                      progress: candidate.specsScore / 100,
                    ),
                    const SizedBox(height: 8),
                    _MetricItem(
                      label: 'Spatial Proximity',
                      value: '${candidate.spatialScore}%',
                      subLabel: candidate.spatialLabel,
                      barColor: const Color(0xFF0D9488),
                      progress: candidate.spatialScore / 100,
                    ),
                    const SizedBox(height: 8),
                    _MetricItem(
                      label: 'Time Delta Gap',
                      value: candidate.timeGap,
                      subLabel: candidate.timeGapLabel,
                      barColor: const Color(0xFF2563EB),
                      progress: 0.85,
                    ),
                    const SizedBox(height: 8),
                    _MetricItem(
                      label: 'Distinctive Markings',
                      value: candidate.markingsLabel,
                      subLabel: candidate.markingsSubLabel,
                      barColor: const Color(0xFFF59E0B),
                      progress: 1.0,
                      isAmber: true,
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.subLabel,
    required this.barColor,
    required this.progress,
    this.isAmber = false,
  });

  final String label;
  final String value;
  final String subLabel;
  final Color barColor;
  final double progress;
  final bool isAmber;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 2,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isAmber ? const Color(0xFFD97706) : const Color(0xFF0F172A),
                ),
              ),
              Text(
                subLabel,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: barColor),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }
}
