import 'package:flutter/foundation.dart';

/// Konfigurasi Server & Database untuk FindIt!
/// File ini dirancang agar kamu dan teman satu tim bisa berganti antara:
/// 1. Database Lokal Laptop (Laragon u278523899_findit)
/// 2. Database Server Asli / Deploy Production
class ApiConfig {
  /// =========================================================================
  /// 🎛️ SAKLAR SERVER (GANTI DI SINI SAJA):
  /// - Ubah ke `false` jika sedang menjalankan database lokal di laptop kamu.
  /// - Ubah ke `true` jika teman kamu ingin menghubungkan ke server asli / deploy.
  /// =========================================================================
  static const bool isProduction = false;

  /// 🌐 URL SERVER ASLI / DEPLOY (Milik teman kamu):
  /// Ganti URL di bawah ini dengan alamat domain / IP server deploy asli tim kamu.
  static const String productionUrl = 'https://api.findit.com/api';

  /// 🛠️ URL KHUSUS (Opsional):
  /// Jika ingin mencoba di HP fisik lewat jaringan WiFi yang sama,
  /// masukkan IP laptop kamu di sini (misal: 'http://192.168.1.15/findit_api/api.php').
  static String customUrl = '';

  /// Mengembalikan Base URL aktif sesuai dengan mode yang dipilih:
  static String get baseUrl {
    // 1. Jika mode Production aktif, gunakan URL server asli teman kamu
    if (isProduction) {
      return productionUrl;
    }

    // 2. Jika ada custom URL yang diset secara manual
    if (customUrl.isNotEmpty) {
      return customUrl;
    }

    // 3. Mode Database Lokal (Laptop kamu - Laragon MySQL u278523899_findit):
    // Chrome Web & Desktop Windows:
    if (kIsWeb) {
      return 'http://localhost/findit_api/api.php';
    }
    // Android Emulator (10.0.2.2 adalah alias emulator untuk localhost laptop):
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2/findit_api/api.php';
    }
    // Default fallback
    return 'http://localhost/findit_api/api.php';
  }

  /// Keterangan status server saat ini (bisa untuk pengecekan/debugging)
  static String get activeEnvironmentDescription {
    if (isProduction) {
      return 'Production / Live Server ($productionUrl)';
    }
    return 'Local Database (Laragon MySQL u278523899_findit)';
  }
}
