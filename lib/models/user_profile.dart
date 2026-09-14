/// Model profil user di sisi Flutter.
///
/// Field `name`, `email`, `phone` dipetakan dari `GET /api/users/:id`
/// (branch `api`). `photoPath` untuk foto profil BELUM ada kolomnya di
/// backend (model `User` di Go belum punya `photo_url`) — jadi untuk
/// sekarang foto disimpan lokal saja di device. Kalau backend-nya nanti
/// ditambah kolom foto, tinggal upload `photoPath` lalu simpan URL-nya
/// di sini.
class UserProfile {
  UserProfile({
    this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.photoPath,
    this.role = 'user',
  });

  /// ID user dari database (kolom `id` di tabel `users`).
  int? id;
  String name;
  String email;
  String phone;
  String? photoPath;
  String role;

  bool get isAdmin =>
      role.toLowerCase() == 'admin' ||
      email.toLowerCase().contains('admin') ||
      email.toLowerCase() == 'sarah@findit.id';

  UserProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? photoPath,
    String? role,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoPath: photoPath ?? this.photoPath,
      role: role ?? this.role,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
  };
}