import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/report.dart';
import '../../widgets/responsive_wrapper.dart';
import 'components/forms/form_field_label.dart';
import 'components/forms/notify_switch_tile.dart';

class ReportLostScreen extends StatefulWidget {
  const ReportLostScreen({super.key});

  @override
  State<ReportLostScreen> createState() => _ReportLostScreenState();
}

class _ReportLostScreenState extends State<ReportLostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _featuresController = TextEditingController();
  final _locationController = TextEditingController();

  String? _category;
  DateTime? _date;
  TimeOfDay? _time;
  final List<XFile> _referenceImages = [];
  bool _notifyEmail = true;
  bool _notifySms = true;

  static const _categories = [
    'Wallets & Bags',
    'Electronics',
    'Keys',
    'Documents',
    'Jewelry',
    'Others',
  ];

  static const navy = Color(0xFF1E3A8A);

  @override
  void dispose() {
    _itemNameController.dispose();
    _featuresController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _addPhotos() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      setState(() => _referenceImages.addAll(picked));
    }
  }

  void _useCurrentLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur lokasi GPS belum terhubung — isi manual dulu ya.')),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal dan waktu kehilangan wajib diisi')),
      );
      return;
    }

    final combinedDate = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _time!.hour,
      _time!.minute,
    );

    final report = Report(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _itemNameController.text.trim(),
      category: _category!,
      description: _featuresController.text.trim(),
      location: _locationController.text.trim(),
      date: combinedDate,
      type: ReportType.lost,
      photoPath: _referenceImages.isNotEmpty ? _referenceImages.first.path : null,
      reportIdentifier: '#LR-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      activityNote: 'Laporan baru dibuat',
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
            Text('Report Lost Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            // --- AI Smart Matching info card ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: navy.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Smart Matching',
                          style: theme.textTheme.titleSmall?.copyWith(color: navy, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Provide distinctive clues below. Our automated system continually cross-checks newly cataloged community turn-ins.',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Item Name & Model ---
            const FormFieldLabel(label: 'Item Name & Model', required: true, hint: 'Be specific'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _itemNameController,
              decoration: const InputDecoration(
                hintText: 'e.g., Midnight Blue iPhone 14 Pro',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.edit_outlined),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama & model barang wajib diisi' : null,
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

            // --- Distinctive Features & Content ---
            const FormFieldLabel(label: 'Distinctive Features & Content', hint: '4 rows'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _featuresController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe distinctive marks, brand, color, stickers, contents, or serial numbers...',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ciri khas barang wajib diisi' : null,
            ),
            const SizedBox(height: 6),
            Text(
              'Example: "Brown leather bi-fold with a faint water ring mark on back and a transit card inside."',
              style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // --- Location Lost ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const FormFieldLabel(label: 'Location Lost', required: true),
                TextButton.icon(
                  onPressed: _useCurrentLocation,
                  style: TextButton.styleFrom(
                    backgroundColor: navy.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  icon: const Icon(Icons.my_location, size: 16, color: navy),
                  label: const Text('Use current location', style: TextStyle(color: navy, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'e.g., Downtown Station or specific venue',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on_outlined, color: Colors.orange),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Lokasi wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // --- When was it lost ---
            const FormFieldLabel(label: 'When was it lost?', required: true),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today_outlined)),
                      child: Text(_date == null ? 'Pilih tanggal' : _formatDate(_date!)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pickTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(border: OutlineInputBorder(), suffixIcon: Icon(Icons.access_time)),
                      child: Text(_time == null ? 'Pilih waktu' : 'Approx. ${_time!.format(context)}'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Photo Verification ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Photo Verification (Optional)', style: theme.textTheme.titleSmall),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.bolt, size: 14, color: Colors.green),
                      SizedBox(width: 4),
                      Text('+75% match rate', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _addPhotos,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
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
                    const Text('Upload reference images', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      'Original receipt photos, past snapshots, or serial stickers',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _addPhotos,
                      icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                      label: Text(_referenceImages.isEmpty ? '+ Add photo' : '${_referenceImages.length} foto dipilih'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Instant Match Notifications ---
            Text('Instant Match Notifications', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            NotifySwitchTile(
              icon: Icons.email_outlined,
              title: 'Notify via Email',
              subtitle: 'j.doe@example.com',
              value: _notifyEmail,
              onChanged: (v) => setState(() => _notifyEmail = v),
            ),
            const SizedBox(height: 8),
            NotifySwitchTile(
              icon: Icons.sms_outlined,
              title: 'Notify via SMS',
              subtitle: '+1 (555) •••-8921',
              value: _notifySms,
              onChanged: (v) => setState(() => _notifySms = v),
            ),
            const SizedBox(height: 24),

            // --- Submit ---
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: navy, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: _submit,
                icon: const Icon(Icons.send),
                label: const Text('Submit Lost Report'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(
                  'Your personal contact details stay private until verified.',
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

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}
