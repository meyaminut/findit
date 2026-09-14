import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/report.dart';
import 'status_badge.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.report, this.onTap, this.onStatusTap});
  final Report report;
  final VoidCallback? onTap;
  final VoidCallback? onStatusTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: report.photoPath != null
                    ? Image.file(File(report.photoPath!), width: 64, height: 64, fit: BoxFit.cover)
                    : Container(
                        width: 64,
                        height: 64,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          report.type == ReportType.lost ? Icons.help_outline : Icons.inventory_2_outlined,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Chip(
                          label: Text(report.type == ReportType.lost ? 'Hilang' : 'Temuan'),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            report.category,
                            style: theme.textTheme.labelMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      report.location,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    if (onStatusTap != null)
                      GestureDetector(onTap: onStatusTap, child: StatusBadge(status: report.status))
                    else
                      StatusBadge(status: report.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
