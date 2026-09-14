import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/report.dart';
import '../../widgets/responsive_wrapper.dart';
import 'components/forms/custody_option_tile.dart';
import 'components/forms/form_field_label.dart';
import 'components/forms/photo_icon_button.dart';

enum _CustodyType { holding, security }

class ReportFoundScreen extends StatefulWidget {
  const ReportFoundScreen({super.key});

  @override
  State<ReportFoundScreen> createState() => _ReportFoundScreenState();
}

class _ReportFoundScreenState extends State<ReportFoundScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _category;
  DateTime? _date;
  TimeOfDay? _time;
  XFile? _photo;
  _CustodyType _custody = _CustodyType.holding;

  static const _categories = [
    'Jewelry & Watches',
    'Wallets & Bags',
    'Electronics',
    'Keys',
    'Documents',
    'Others',
  ];

  static const navy = Color(0xFF1E3A8A);

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 85);
    if (picked != null) setState(() => _photo = picked);
  }

  Future<void> _pickFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) setState(() => _photo = picked);
  }

  void _removePhoto() => setState(() => _photo = null);

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    if (!mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    setState(() {
      _date = pickedDate;
      if (pickedTime != null) _time = pickedTime;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_photo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto barang wajib diambil dulu')),
      );
      return;
    }
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal & waktu ditemukan wajib diisi')),
      );
      return;
    }

    final combinedDate = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time?.hour ?? 0,
      _time?.minute ?? 0,
    );

    final report = Report(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      category: _category!,
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      date: combinedDate,
      type: ReportType.found,
      photoPath: _photo!.path,
      handoverMethod: _custody == _CustodyType.holding ? 'holding' : 'security',
      reportIdentifier: '#FR-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      activityNote: 'Laporan temuan baru dibuat',
    );
    Navigator.pop(context, report);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: const BackButton(),
        titleSpacing: 0,
        title: Row(
          children: const [
            Icon(Icons.location_on, color: Colors.deepPurple, size: 20),
            SizedBox(width: 6),
            Text('Report Found Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
      body: ResponsiveContainer(
        maxWidth: 750,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
            // --- Good Samaritan Shield info card ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.orange.shade600, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.volunteer_activism, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Good Samaritan Shield',
                              style: theme.textTheme.titleSmall?.copyWith(color: Colors.orange.shade800, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.verified, size: 14, color: Colors.orange.shade700),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Thank you for being a good Samaritan! Reporting found items safely reunites owners with peace of mind.',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Item Photography (required) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const FormFieldLabel(label: 'Item Photography', required: true),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(20)),
                  child: Text('REQUIRED', style: TextStyle(color: Colors.red.shade600, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _photo == null
                ? InkWell(
                    onTap: _takePhoto,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: navy.withValues(alpha: 0.08),
                            child: const Icon(Icons.camera_alt_outlined, color: navy),
                          ),
                          const SizedBox(height: 10),
                          const Text('Tap to take a photo', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          TextButton(onPressed: _pickFromGallery, child: const Text('or choose from gallery')),
                        ],
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 10,
                          child: Image.file(File(_photo!.path), fit: BoxFit.cover, width: double.infinity),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.auto_awesome, size: 12, color: navy),
                                SizedBox(width: 4),
                                Text('Smart-Match Ready', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: navy)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Row(
                            children: [
                              PhotoIconButton(icon: Icons.refresh, label: 'Retake', onTap: _takePhoto),
                              const SizedBox(width: 8),
                              PhotoIconButton(icon: Icons.delete_outline, color: Colors.red, onTap: _removePhoto),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_outlined, size: 14, color: Colors.black45),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'We use image matching to protect genuine owners and prevent unauthorized claims.',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Item Title ---
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormFieldLabel(label: 'Item Title', required: true),
                Text('Specific & concise', style: TextStyle(fontSize: 12, color: Colors.black45)),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'e.g., Silver Stainless Watch on Bench',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul barang wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // --- Category ---
            const FormFieldLabel(label: 'Category', required: true),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v),
              validator: (v) => v == null ? 'Pilih kategori barang' : null,
            ),
            const SizedBox(height: 16),

            // --- Where Did You Find It? ---
            const FormFieldLabel(label: 'Where Did You Find It?', required: true),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'e.g., Grand Central Atrium, 2nd Floor bench near North Pillar',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on_outlined, color: Colors.orange),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Lokasi penemuan wajib diisi' : null,
            ),
            const SizedBox(height: 4),
            Text(
              'Be as specific as possible (building, floor, landmark).',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45),
            ),
            if (_locationController.text.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: navy.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: const [
                    Icon(Icons.my_location, size: 14, color: navy),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pin matched: Grand Central Terminal Zone 4',
                        style: TextStyle(fontSize: 12, color: navy, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),

            // --- Safe Custody & Possession ---
            const FormFieldLabel(label: 'Safe Custody & Possession', required: true),
            const SizedBox(height: 8),
            CustodyOptionTile(
              icon: Icons.person_outline,
              title: 'I am holding the item',
              subtitle: 'I can safely hand this over when verified.',
              selected: _custody == _CustodyType.holding,
              onTap: () => setState(() => _custody = _CustodyType.holding),
            ),
            const SizedBox(height: 10),
            CustodyOptionTile(
              icon: Icons.local_police_outlined,
              title: 'Handed to Security / Front Desk',
              subtitle: 'Deposited with building personnel on-site.',
              selected: _custody == _CustodyType.security,
              onTap: () => setState(() => _custody = _CustodyType.security),
            ),
            const SizedBox(height: 20),

            // --- Description & Condition Details ---
            const FormFieldLabel(label: 'Description & Condition Details'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe the item\'s condition, brand, and any distinguishing details...',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Deskripsi wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // --- Date & Time Found ---
            const FormFieldLabel(label: 'Date & Time Found', required: true),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDateTime,
              child: InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder(), suffixIcon: Icon(Icons.access_time)),
                child: Text(_date == null ? 'Pilih tanggal & waktu' : _formatDateTime(_date!, _time)),
              ),
            ),
            const SizedBox(height: 24),

            // --- Submit ---
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: navy, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: _submit,
                icon: const Icon(Icons.send),
                label: const Text('Submit Found Report'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user_outlined, size: 14, color: Colors.black45),
                const SizedBox(width: 6),
                Text(
                  'Admin will verify before matching to lost reports.',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  String _formatDateTime(DateTime d, TimeOfDay? t) {
    final dateStr = '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';
    if (t == null) return dateStr;
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$dateStr, ${hour.toString().padLeft(2, '0')}:$minute $period';
  }
}
