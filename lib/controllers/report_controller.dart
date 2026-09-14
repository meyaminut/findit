import 'package:flutter/foundation.dart';
import '../models/report.dart';
import '../services/report_service.dart';

class ReportController extends ChangeNotifier {
  ReportController({ReportService? service, List<Report>? initialReports, bool autoFetch = true})
      : _service = service ?? ReportService() {
    _reports = initialReports ?? _service.getInitialReports();
    if (autoFetch && initialReports == null) {
      loadReportsFromDb();
    }
  }

  final ReportService _service;
  List<Report> _reports = [];
  bool _isLoading = false;

  String _searchQuery = '';
  ReportType? _typeFilter;
  ReportStatus? _statusFilter;

  List<Report> get reports => List.unmodifiable(_reports);
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  ReportType? get typeFilter => _typeFilter;
  ReportStatus? get statusFilter => _statusFilter;

  int get totalReports => _reports.length;
  int get activeReports => _reports.where((r) => r.status != ReportStatus.dikembalikan).length;
  int get matchedReports => _reports.where((r) => r.status == ReportStatus.dicocokkan).length;
  int get confirmedReports => _reports.where((r) => r.status == ReportStatus.dikonfirmasi).length;
  int get returnedReports => _reports.where((r) => r.status == ReportStatus.dikembalikan).length;

  List<Report> get filteredReports {
    return _reports.where((r) {
      final matchesType = _typeFilter == null || r.type == _typeFilter;
      final matchesStatus = _statusFilter == null || r.status == _statusFilter;

      if (!matchesType || !matchesStatus) return false;
      if (_searchQuery.trim().isEmpty) return true;

      final q = _searchQuery.toLowerCase();
      return r.title.toLowerCase().contains(q) ||
          r.location.toLowerCase().contains(q) ||
          r.category.toLowerCase().contains(q);
    }).toList();
  }

  /// Mengambil data laporan terbaru dari database MySQL lokal (u278523899_findit).
  Future<void> loadReportsFromDb() async {
    _isLoading = true;
    notifyListeners();
    try {
      final dbReports = await _service.getReports();
      if (dbReports.isNotEmpty) {
        _reports = dbReports;
      }
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Menambahkan laporan baru, menyimpannya ke MySQL, dan memperbarui UI secara real-time.
  Future<void> addReport(Report report, {int? userId}) async {
    _reports.insert(0, report);
    notifyListeners();

    final saved = await _service.createReport(report, userId: userId);
    if (saved != null) {
      final idx = _reports.indexWhere((r) => r.id == report.id);
      if (idx != -1) {
        _reports[idx] = saved;
        notifyListeners();
      }
    }
  }

  /// Mengubah status laporan di UI dan memperbaruinya di MySQL.
  Future<void> updateReportStatus(String id, ReportStatus newStatus) async {
    final index = _reports.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reports[index].status = newStatus;
      notifyListeners();
      await _service.updateReportStatus(id, newStatus);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setTypeFilter(ReportType? type) {
    _typeFilter = type;
    notifyListeners();
  }

  void setStatusFilter(ReportStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _typeFilter = null;
    _statusFilter = null;
    notifyListeners();
  }
}
