import 'package:flutter/foundation.dart';
import '../models/match_candidate.dart';
import '../services/match_service.dart';

enum ScoreThresholdFilter {
  all,
  above90,
  range80to90,
  below80,
}

class AdminMatchController extends ChangeNotifier {
  AdminMatchController({MatchService? service}) : _service = service ?? MatchService() {
    _candidates = _service.getInitialCandidates();
    if (_candidates.isNotEmpty) {
      _selectedCandidate = _candidates.first;
    }
  }

  final MatchService _service;
  List<MatchCandidate> _candidates = [];
  MatchCandidate? _selectedCandidate;

  ScoreThresholdFilter _thresholdFilter = ScoreThresholdFilter.all;
  String _selectedCategory = 'All Categories (Electronics, IDs, Keys)';
  final String _dateRange = 'Last 48 Hours (Oct 22 - Oct 24)';
  String _searchQuery = '';

  List<MatchCandidate> get allCandidates => List.unmodifiable(_candidates);
  MatchCandidate? get selectedCandidate => _selectedCandidate;
  ScoreThresholdFilter get thresholdFilter => _thresholdFilter;
  String get selectedCategory => _selectedCategory;
  String get dateRange => _dateRange;
  String get searchQuery => _searchQuery;

  int get pendingCount => _candidates.where((c) => c.status == MatchStatus.pending).length;

  List<MatchCandidate> get filteredCandidates {
    return _candidates.where((c) {
      // Threshold
      if (_thresholdFilter == ScoreThresholdFilter.above90 && c.similarityScore <= 90) {
        return false;
      }
      if (_thresholdFilter == ScoreThresholdFilter.range80to90 &&
          (c.similarityScore < 80 || c.similarityScore > 90)) {
        return false;
      }
      if (_thresholdFilter == ScoreThresholdFilter.below80 && c.similarityScore >= 80) {
        return false;
      }

      // Search
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = c.lostItemTitle.toLowerCase().contains(q) ||
            c.foundItemTitle.toLowerCase().contains(q) ||
            c.id.toLowerCase().contains(q);
        if (!matchTitle) return false;
      }

      return true;
    }).toList();
  }

  List<MatchCandidate> get pendingTableCandidates {
    // Exclude selected hero candidate from the pending list table below
    return filteredCandidates.where((c) => c.id != _selectedCandidate?.id).toList();
  }

  void selectCandidate(MatchCandidate candidate) {
    _selectedCandidate = candidate;
    notifyListeners();
  }

  void setThreshold(ScoreThresholdFilter filter) {
    _thresholdFilter = filter;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void confirmMatch(String id, String auditNote) {
    final idx = _candidates.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _candidates[idx].status = MatchStatus.confirmed;
      _candidates[idx].internalAuditNote = auditNote;
      notifyListeners();
    }
  }

  void rejectMatch(String id, String reason) {
    final idx = _candidates.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _candidates[idx].status = MatchStatus.rejected;
      _candidates[idx].internalAuditNote = reason;
      notifyListeners();
    }
  }

  void requestInfo(String id) {
    final idx = _candidates.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _candidates[idx].status = MatchStatus.infoRequested;
      notifyListeners();
    }
  }

  void refreshQueue() {
    _candidates = _service.getInitialCandidates();
    if (_candidates.isNotEmpty) {
      _selectedCandidate = _candidates.first;
    }
    notifyListeners();
  }
}
