import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

/// Exception dengan pesan yang sudah dalam Bahasa Indonesia dari backend
/// (field `message` di ResponseFormat), siap ditampilkan langsung ke user.
class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class AuthService {
  /// Ganti sesuai environment kamu:
  /// - Emulator Android  -> http://10.0.2.2:8080/api
  /// - Web/desktop/simulator iOS -> http://localhost:8080/api
  /// - HP fisik -> http://[IP komputer kamu di wifi yang sama]:8080/api
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  static Future<UserProfile> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );
    return _handleUserResponse(res);
  }

  static Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleUserResponse(res);
  }

  static UserProfile _handleUserResponse(http.Response res) {
    late final Map<String, dynamic> body;
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Server memberikan respons yang tidak valid (${res.statusCode}).');
    }

    if (res.statusCode >= 200 && res.statusCode < 300 && body['data'] != null) {
      return UserProfile.fromJson(body['data'] as Map<String, dynamic>);
    }
    throw ApiException(body['message'] ?? 'Terjadi kesalahan (${res.statusCode}).');
  }

  // --- Sesi lokal, supaya user tidak perlu login ulang tiap buka app ---

  static const _sessionKey = 'findit_session_user';

  static Future<void> saveSession(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(profile.toJson()));
  }

  static Future<UserProfile?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw == null) return null;
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}