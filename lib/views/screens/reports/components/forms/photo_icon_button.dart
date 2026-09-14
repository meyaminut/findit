import 'package:flutter/material.dart';

class PhotoIconButton extends StatelessWidget {
  const PhotoIconButton({
    super.key,
    required this.icon,
    this.label,
    this.color,
    required this.onTap,
  });

  final IconData icon;
  final String? label;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: label != null ? 10 : 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color ?? Colors.black87),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(label!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color ?? Colors.black87)),
            ],
          ],
        ),
      ),
    );
  }
}
