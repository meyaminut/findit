import 'package:flutter_test/flutter_test.dart';
import 'package:findit/models/report.dart';
import 'package:findit/services/api_config.dart';
import 'package:findit/services/report_service.dart';

void main() {
  test('ApiConfig baseUrl is configured for local Laragon database', () {
    expect(ApiConfig.baseUrl, contains('/findit_api/api.php'));
  });

  test('Report.fromJson parses MySQL database records accurately', () {
    final rawDbRecord = {
      'id': '10',
      'reportIdentifier': '#LR-2026-9999',
      'title': 'MacBook Pro M2',
      'category': 'Electronics',
      'description': 'Laptop warna space gray tertinggal di perpus',
      'location': 'Lantai 2 Perpus',
      'type': 'lost',
      'status': 'active',
      'activityNote': '98% AI Match Found',
      'date': '2026-09-14 07:00:00',
      'custodianName': 'Admin Perpustakaan',
      'custodianPhone': '0812345678',
      'custodianEmail': 'admin@campus.ac.id'
    };

    final report = Report.fromJson(rawDbRecord);

    expect(report.id, '10');
    expect(report.reportIdentifier, '#LR-2026-9999');
    expect(report.title, 'MacBook Pro M2');
    expect(report.type, ReportType.lost);
    expect(report.status, ReportStatus.baru);
    expect(report.custodianName, 'Admin Perpustakaan');
  });

  test('ReportService fetches data from local MySQL database u278523899_findit', () async {
    final service = ReportService();
    final reports = await service.getReports();

    expect(reports.isNotEmpty, true);
    expect(reports.first.title.isNotEmpty, true);
  });
}
