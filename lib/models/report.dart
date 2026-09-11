enum ReportType { lost, found }

enum ReportStatus { baru, dicocokkan, dikonfirmasi, dikembalikan }

extension ReportStatusX on ReportStatus {
  String get label => switch (this) {
    ReportStatus.baru => 'Baru',
    ReportStatus.dicocokkan => 'Dicocokkan',
    ReportStatus.dikonfirmasi => 'Dikonfirmasi',
    ReportStatus.dikembalikan => 'Dikembalikan',
  };
}

class Report {
  Report({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.location,
    required this.date,
    required this.type,
    this.photoPath,
    this.status = ReportStatus.baru,
    this.activityNote,
    this.handoverMethod,
    this.reportIdentifier,
    this.verifiedBy,
    this.custodianName,
    this.custodianRole,
    this.custodianPhone,
    this.custodianEmail,
  });

  final String id;
  String title;
  String category;
  String description;
  String location;
  DateTime date;
  ReportType type;
  String? photoPath;
  ReportStatus status;
  /// Catatan singkat untuk kartu aktivitas di Home Dashboard,
  /// mis. "94% AI Match Found" atau "Reunited with owner".
  String? activityNote;
  /// Hanya untuk laporan barang temuan: 'holding' atau 'security'.
  String? handoverMethod;

  /// Nomor identifikasi resmi laporan, mis. "#LR-2024-8842".
  String? reportIdentifier;
  /// Nama admin yang mengonfirmasi kecocokan, mis. "Sarah K.".
  String? verifiedBy;
  /// Data penemu/pemegang barang (ditampilkan di Report Detail).
  String? custodianName;
  String? custodianRole;
  String? custodianPhone;
  String? custodianEmail;
}