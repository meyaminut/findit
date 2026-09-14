import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/auth_controller.dart';
import '../../../models/user_profile.dart';
import '../../widgets/responsive_wrapper.dart';
import '../admin/admin_match_review_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.profile, this.authController});
  final UserProfile profile;
  final AuthController? authController;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const navy = Color(0xFF1E3A8A);

  late final AuthController _authController;
  late UserProfile _profile;
  bool _isEditing = false;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _authController = widget.authController ?? AuthController(initialProfile: widget.profile);
    _profile = widget.profile.copyWith();
    _nameController = TextEditingController(text: _profile.name);
    _phoneController = TextEditingController(text: _profile.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _changePhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Ambil Foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            if (_profile.photoPath != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Hapus Foto', style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context, null),
              ),
          ],
        ),
      ),
    );

    if (source == null && _profile.photoPath == null) return;

    if (source == null) {
      setState(() => _profile.photoPath = null);
      await _authController.updateProfile(photoPath: null);
      return;
    }

    final picked = await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setState(() => _profile.photoPath = picked.path);
      await _authController.updateProfile(photoPath: picked.path);
    }
  }

  Future<void> _saveChanges() async {
    final newName = _nameController.text.trim().isEmpty ? _profile.name : _nameController.text.trim();
    final newPhone = _phoneController.text.trim();

    setState(() {
      _profile.name = newName;
      _profile.phone = newPhone;
      _isEditing = false;
    });

    await _authController.updateProfile(name: newName, phone: newPhone);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar akun?'),
        content: const Text('Kamu perlu login lagi untuk mengakses FindIt!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Keluar')),
        ],
      ),
    );
    if (confirmed != true) return;

    await _authController.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen(authController: _authController)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F8FC),
          elevation: 0,
          foregroundColor: Colors.black87,
          title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _profile),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_isEditing) {
                  _saveChanges();
                } else {
                  setState(() => _isEditing = true);
                }
              },
              child: Text(_isEditing ? 'Simpan' : 'Edit'),
            ),
          ],
        ),
        body: ResponsiveContainer(
          maxWidth: 650,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: navy.withValues(alpha: 0.1),
                      backgroundImage: _profile.photoPath != null ? FileImage(File(_profile.photoPath!)) : null,
                      child: _profile.photoPath == null
                          ? Icon(Icons.person, size: 48, color: navy.withValues(alpha: 0.6))
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: _changePhoto,
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: navy,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: _changePhoto,
                  icon: const Icon(Icons.image_outlined, size: 16),
                  label: const Text('Ganti Foto Profil', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoCard(),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shield_outlined, color: navy, size: 20),
                  ),
                  title: const Text(
                    'Admin Portal',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Match Verification Console & Queue',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.black45),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminMatchReviewScreen(userProfile: _profile),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _logout,
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                icon: const Icon(Icons.logout),
                label: const Text('Keluar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldRow(
            icon: Icons.badge_outlined,
            label: 'Nama',
            editable: true,
            controller: _nameController,
            staticValue: _profile.name,
          ),
          const Divider(height: 24),
          _fieldRow(
            icon: Icons.email_outlined,
            label: 'Email',
            editable: false,
            staticValue: _profile.email,
          ),
          const Divider(height: 24),
          _fieldRow(
            icon: Icons.phone_outlined,
            label: 'No. HP',
            editable: true,
            controller: _phoneController,
            staticValue: _profile.phone.isEmpty ? '-' : _profile.phone,
          ),
        ],
      ),
    );
  }

  Widget _fieldRow({
    required IconData icon,
    required String label,
    required String staticValue,
    bool editable = false,
    TextEditingController? controller,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: navy),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
              const SizedBox(height: 2),
              if (_isEditing && editable && controller != null)
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(isDense: true, border: InputBorder.none, contentPadding: EdgeInsets.zero),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                )
              else
                Text(staticValue, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
