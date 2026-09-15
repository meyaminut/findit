import 'dart:io';

import 'package:flutter/material.dart';

import '../models/found_item.dart';
import '../utils/formatters.dart';

class FoundItemStatusBadge extends StatelessWidget {
  const FoundItemStatusBadge({super.key, required this.status});

  final FoundItemStatus status;

  Color get _color => switch (status) {
        FoundItemStatus.baruDitemukan => Colors.orange.shade800,
        FoundItemStatus.disimpanLostFound => const Color(0xFF1E3A8A),
        FoundItemStatus.dikembalikan => Colors.green.shade700,
      };

  IconData get _icon => switch (status) {
        FoundItemStatus.baruDitemukan => Icons.new_releases_outlined,
        FoundItemStatus.disimpanLostFound => Icons.inventory_2_outlined,
        FoundItemStatus.dikembalikan => Icons.check_circle_outline,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 13, color: _color),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              color: _color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class FoundItemCard extends StatelessWidget {
  const FoundItemCard({super.key, required this.item});

  final FoundItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PhotoThumbnail(item: item),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.namaBarang,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _MetaChip(
                          icon: Icons.category_outlined,
                          label: item.category.label,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _MetaChip(
                            icon: Icons.palette_outlined,
                            label: item.warna,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.place_outlined, size: 13, color: Colors.black38),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.lokasi,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.schedule, size: 13, color: Colors.black38),
              const SizedBox(width: 4),
              Text(
                formatTanggalWaktu(item.ditemukanPada),
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: FoundItemStatusBadge(status: item.status),
          ),
        ],
      ),
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  const _PhotoThumbnail({required this.item});

  final FoundItem item;

  IconData get _placeholderIcon => switch (item.category) {
        FoundItemCategory.elektronik => Icons.devices_other,
        FoundItemCategory.pakaian => Icons.checkroom,
        FoundItemCategory.aksesoris => Icons.watch_outlined,
        FoundItemCategory.dokumen => Icons.description_outlined,
        FoundItemCategory.lainnya => Icons.inventory_2_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final path = item.photoPath;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 56,
        height: 56,
        child: path != null && File(path).existsSync()
            ? Image.file(File(path), fit: BoxFit.cover)
            : Container(
                color: const Color(0xFFEFF3FB),
                child: Icon(_placeholderIcon, color: const Color(0xFF1E3A8A)),
              ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.black45),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 10.5, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}