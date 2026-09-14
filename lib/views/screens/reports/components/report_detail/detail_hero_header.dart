import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../models/report.dart';

class DetailHeroHeader extends StatelessWidget {
  const DetailHeroHeader({
    super.key,
    required this.report,
    required this.stageIndex,
    required this.badgeColor,
  });

  final Report report;
  final int stageIndex;
  final Color badgeColor;

  static const navy = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    final badgeLabel = switch (report.status) {
      ReportStatus.baru => 'SEARCHING',
      ReportStatus.dicocokkan => 'MATCH FOUND',
      ReportStatus.dikonfirmasi => 'CONFIRMED MATCH',
      ReportStatus.dikembalikan => 'RETURNED',
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            report.photoPath != null
                ? Image.file(File(report.photoPath!), fit: BoxFit.cover)
                : Container(
                    color: navy.withValues(alpha: 0.85),
                    child: Icon(
                      report.type == ReportType.lost ? Icons.help_outline : Icons.inventory_2_outlined,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  badgeLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (stageIndex >= 2)
                    Row(
                      children: [
                        const Icon(Icons.verified, size: 14, color: Colors.greenAccent),
                        const SizedBox(width: 4),
                        Text(
                          'CASE REFERENCE VERIFIED',
                          style: TextStyle(
                            color: Colors.greenAccent.shade100,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Text(
                    report.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
