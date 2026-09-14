import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/report.dart';
import 'api_config.dart';

class ReportService {
  static String get baseUrl => ApiConfig.baseUrl;

  /// Mengambil daftar laporan dari database MySQL lokal (u278523899_findit).
  /// Otomatis fallback ke mock data jika koneksi belum tersambung agar aplikasi tidak crash.
  Future<List<Report>> getReports() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/reports')).timeout(const Duration(seconds: 4));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final list = body['data'] as List<dynamic>?;
        if (list != null && list.isNotEmpty) {
          return list.map((item) => Report.fromJson(item as Map<String, dynamic>)).toList();
        }
      }
    } catch (e) {
      debugPrint('ReportService.getReports (fallback to mock): $e');
    }
    return getInitialReports();
  }

  /// Menyimpan laporan baru ke database MySQL lokal (u278523899_findit).
  Future<Report?> createReport(Report report, {int? userId}) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/reports'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': report.title,
          'category': report.category,
          'description': report.description,
          'location': report.location,
          'type': report.type == ReportType.found ? 'found' : 'lost',
          'user_id': userId ?? 1,
          'photo_url': report.photoPath,
          'activity_note': report.activityNote,
          'report_identifier': report.reportIdentifier,
        }),
      ).timeout(const Duration(seconds: 5));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        if (body['data'] != null) {
          return Report.fromJson(body['data'] as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('ReportService.createReport error: $e');
    }
    return null;
  }

  /// Mengubah status laporan di database MySQL lokal (u278523899_findit).
  Future<bool> updateReportStatus(String id, ReportStatus status) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/update_status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'status': status.name,
        }),
      ).timeout(const Duration(seconds: 4));
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (e) {
      debugPrint('ReportService.updateReportStatus error: $e');
      return false;
    }
  }

  /// Data cadangan (mock data) jika koneksi ke database lokal belum berjalan.
  List<Report> getInitialReports() {
    return [
      Report(
        id: '1',
        title: 'Midnight Blue MacBook Pro 14"',
        category: 'Electronics',
        description: 'Sticker GitHub di cover belakang, charger MagSafe tertinggal.',
        location: 'Central Transit Station, Line 2',
        date: DateTime.now(),
        type: ReportType.lost,
        status: ReportStatus.dicocokkan,
        activityNote: '94% AI Match Found',
        reportIdentifier: '#LR-2024-8842',
        verifiedBy: 'Sarah K.',
        custodianName: 'Budi Santoso',
        custodianRole: 'Station Security Staff',
        custodianPhone: '0812-3456-7890',
        custodianEmail: 'budi.transit@station.id',
      ),
      Report(
        id: '2',
        title: 'Leather Bellroy Key Cover (Br...)',
        category: 'Accessories',
        description: 'Gantungan kunci kulit coklat berisi 3 kunci rumah dan 1 kontak motor.',
        location: 'Civic Plaza Coffeehouse',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: ReportType.found,
        status: ReportStatus.dikonfirmasi,
        activityNote: 'Claim verified by barista',
        reportIdentifier: '#FR-2024-5512',
        verifiedBy: 'Alex W.',
        custodianName: 'Dina Lestari',
        custodianRole: 'Coffeehouse Barista',
        custodianPhone: '0813-9876-5432',
        custodianEmail: 'dina@civicplaza.id',
      ),
      Report(
        id: '3',
        title: 'Matte Black Tortoise Sunglas...',
        category: 'Personal Items',
        description: 'Kacamata hitam frame motif penyu dengan kotak pelindung hitam.',
        location: 'Riverfront Park Trail',
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: ReportType.lost,
        status: ReportStatus.baru,
        activityNote: 'Scanning perimeter (2km)',
        reportIdentifier: '#LR-2024-9021',
      ),
      Report(
        id: '4',
        title: 'Tan Leather Bi-Fold Wallet (Ini...)',
        category: 'Wallets',
        description: 'Dompet kulit lipat coklat muda dengan inisial nama terukir di sudut kanan.',
        location: 'Metropolitan Library 2F',
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: ReportType.found,
        status: ReportStatus.dikembalikan,
        activityNote: 'Reunited with owner',
        reportIdentifier: '#FR-2024-4119',
        verifiedBy: 'Sarah K.',
        custodianName: 'Admin Perpustakaan',
        custodianRole: 'Staff Layanan Pengunjung',
        custodianPhone: '021-5551234',
      ),
    ];
  }
}
