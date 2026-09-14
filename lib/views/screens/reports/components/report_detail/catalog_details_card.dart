import 'package:flutter/material.dart';
import '../../../../../models/report.dart';
import 'location_map_preview.dart';

class CatalogDetailsCard extends StatelessWidget {
  const CatalogDetailsCard({
    super.key,
    required this.report,
    required this.hasCustodian,
    required this.onCopyIdentifier,
    required this.formatDate,
  });

  final Report report;
  final bool hasCustodian;
  final VoidCallback onCopyIdentifier;
  final String Function(DateTime) formatDate;

  static const navy = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    final dateLabel = report.type == ReportType.lost ? 'LOST DATE & TIME' : 'FOUND DATE & TIME';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text('Catalog Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Spacer(),
            Text('Official Registry Entry', style: TextStyle(fontSize: 11, color: Colors.black45)),
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
              _CatalogRow(
                label: 'REPORT IDENTIFIER',
                value: report.reportIdentifier ?? '#${report.id}',
                valueColor: navy,
                trailing: _CircleIconButton(
                  icon: Icons.copy_outlined,
                  small: true,
                  onTap: onCopyIdentifier,
                ),
              ),
              const _CatalogDivider(),
              _CatalogRow(label: 'CATEGORY', value: report.category),
              const _CatalogDivider(),
              _CatalogRow(label: dateLabel, value: formatDate(report.date)),
              const _CatalogDivider(),
              _CatalogRow(label: 'REPORTED DISCOVERY LOCATION', value: report.location),
              if (report.description.trim().isNotEmpty) ...[
                const _CatalogDivider(),
                _CatalogRow(label: 'PHYSICAL DESCRIPTION', value: report.description),
              ],
              if (hasCustodian) ...[
                const _CatalogDivider(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'RECOVERY STATION VICINITY',
                    style: TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 0.4),
                  ),
                ),
                LocationMapPreview(locationLabel: report.location),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap, this.small = false});
  final IconData icon;
  final VoidCallback onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 30.0 : 34.0;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: small ? 15 : 17, color: Colors.black87),
      ),
    );
  }
}

class _CatalogRow extends StatelessWidget {
  const _CatalogRow({required this.label, required this.value, this.valueColor, this.trailing});
  final String label;
  final String value;
  final Color? valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600, letterSpacing: 0.4),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: valueColor ?? Colors.black87),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _CatalogDivider extends StatelessWidget {
  const _CatalogDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Colors.grey.shade100);
  }
}
