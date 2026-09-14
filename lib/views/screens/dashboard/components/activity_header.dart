import 'package:flutter/material.dart';

class ActivityHeader extends StatelessWidget {
  const ActivityHeader({
    super.key,
    required this.count,
    required this.onFilterTap,
    required this.onViewAllTap,
  });

  final int count;
  final VoidCallback onFilterTap;
  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Flexible(
                child: Text(
                  'Recent Activity',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                child: Text('$count', style: const TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onFilterTap,
          icon: const Icon(Icons.filter_list, size: 16),
          label: const Text('Filter', style: TextStyle(fontSize: 12)),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onViewAllTap,
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
          child: const Text('View all', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
