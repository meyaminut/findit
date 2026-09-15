import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/found_item.dart';

class FoundItemFormScreen extends StatefulWidget {
  const FoundItemFormScreen({super.key});

  @override
  State<FoundItemFormScreen> createState() => _FoundItemFormScreenState();
}

class _FoundItemFormScreenState extends State<FoundItemFormScreen> {
  static const navy = Color(0xFF1E3A8A);

  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _warnaController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _deskripsiController = TextEditingController();

  FoundItemCategory? _category;
  XFile? _photo;

  @override
  void dispose() {
    _namaController.dispose();
    _warnaController.dispose();
    _lokasiController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto({required bool fromCamera}) async {
    final source = fromCamera ? ImageSource.camera : ImageSource.gallery;
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (picked != null) setState(() => _photo = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kategori barang terlebih dahulu')),
      );
      return;
    }
    if (_photo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto barang wajib dilampirkan')),
      );
      return;
    }

    final item = FoundItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      namaBarang: _namaController.text.trim(),
      category: _category!,
      warna: _warnaController.text.trim(),
      lokasi: _lokasiController.text.trim(),
      deskripsi: _deskripsiController.text.trim(),
      ditemukanPada: DateTime.now(),
      status: FoundItemStatus.baruDitemukan,
      photoPath: _photo!.path,
    );
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text(
          'Lapor Barang Ditemukan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _PhotoPicker(
              photoPath: _photo?.path,
              onTapGallery: () => _pickPhoto(fromCamera: false),
              onTapCamera: () => _pickPhoto(fromCamera: true),
            ),
            const SizedBox(height: 20),
            _FieldLabel(label: 'Nama Barang', required: true),
            const SizedBox(height: 8),
            TextFormField(
              controller: _namaController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'contoh: Jam Tangan Silver',
                prefixIcon: Icon(Icons.inventory_2_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama barang wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            _FieldLabel(label: 'Kategori', required: true),
            const SizedBox(height: 8),
            DropdownButtonFormField<FoundItemCategory>(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(),
              ),
              items: FoundItemCategory.values
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v),
              validator: (v) => v == null ? 'Pilih kategori barang' : null,
            ),
            const SizedBox(height: 16),
            _FieldLabel(label: 'Warna Barang', required: true),
            const SizedBox(height: 8),
            TextFormField(
              controller: _warnaController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'contoh: Hitam/Perak',
                prefixIcon: Icon(Icons.palette_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Warna barang wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            const _FieldLabel(label: 'Lokasi / Area Hotel'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _lokasiController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'contoh: Kamar 1204, Lobby Utama',
                prefixIcon: Icon(Icons.place_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const _FieldLabel(label: 'Deskripsi', required: true),
            const SizedBox(height: 8),
            TextFormField(
              controller: _deskripsiController,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Catat detail lokasi & kondisi barang saat ditemukan...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Deskripsi wajib diisi' : null,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: navy,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _submit,
              icon: const Icon(Icons.send_outlined),
              label: const Text('Submit Report', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.photoPath,
    required this.onTapGallery,
    required this.onTapCamera,
  });

  final String? photoPath;
  final VoidCallback onTapGallery;
  final VoidCallback onTapCamera;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Foto Barang',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Foto membantu mencocokkan barang dengan pemiliknya.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 10),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: photoPath != null
              ? Image.file(File(photoPath!), fit: BoxFit.cover)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
                      child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF1E3A8A), size: 26),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ambil foto atau unggah dari galeri',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: onTapCamera,
                          icon: const Icon(Icons.photo_camera_outlined, size: 16),
                          label: const Text('Kamera'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: onTapGallery,
                          icon: const Icon(Icons.photo_library_outlined, size: 16),
                          label: const Text('Galeri'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, this.required = false});
  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        if (required) const Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}