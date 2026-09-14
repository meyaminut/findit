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

  factory Report.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type']?.toString().toLowerCase();
    final type = typeStr == 'found' ? ReportType.found : ReportType.lost;

    final statusStr = json['status']?.toString().toLowerCase();
    final status = switch (statusStr) {
      'dicocokkan' || 'matched' => ReportStatus.dicocokkan,
      'dikonfirmasi' || 'confirmed' || 'cancelled' => ReportStatus.dikonfirmasi,
      'dikembalikan' || 'resolved' => ReportStatus.dikembalikan,
      _ => ReportStatus.baru,
    };

    DateTime parsedDate;
    try {
      parsedDate = json['date'] != null ? DateTime.parse('${json['date']}') : DateTime.now();
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return Report(
      id: '${json['id'] ?? ''}',
      title: json['title'] ?? '',
      category: json['category'] ?? 'Others',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      date: parsedDate,
      type: type,
      status: status,
      photoPath: json['photoPath'] ?? json['photo_url'],
      activityNote: json['activityNote'] ?? json['activity_note'],
      handoverMethod: json['handoverMethod'] ?? json['handover_method'],
      reportIdentifier: json['reportIdentifier'] ?? json['report_identifier'],
      verifiedBy: json['verifiedBy'] ?? json['verified_by'],
      custodianName: json['custodianName'] ?? json['custodian_name'],
      custodianRole: json['custodianRole'] ?? json['custodian_role'],
      custodianPhone: json['custodianPhone'] ?? json['custodian_phone'],
      custodianEmail: json['custodianEmail'] ?? json['custodian_email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'description': description,
    'location': location,
    'date': date.toIso8601String(),
    'type': type.name,
    'status': status.name,
    'photoPath': photoPath,
    'activityNote': activityNote,
    'handoverMethod': handoverMethod,
    'reportIdentifier': reportIdentifier,
    'verifiedBy': verifiedBy,
    'custodianName': custodianName,
    'custodianRole': custodianRole,
    'custodianPhone': custodianPhone,
    'custodianEmail': custodianEmail,
  };
}