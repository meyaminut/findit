/// Model representasi data kecocokan AI (AI Match Verification Candidate)
/// untuk Admin Portal / Match Verification Console.
class MatchCandidate {
  MatchCandidate({
    required this.id,
    required this.similarityScore,
    this.status = MatchStatus.pending,
    this.isAutoPaired = true,
    this.priorityLabel = 'High Priority Property Match Review',
    this.similarityBadge = 'Near Identical Signature',
    // Lost Report
    required this.lostReportId,
    required this.lostDate,
    required this.lostItemTitle,
    required this.lostItemCategory,
    this.lostItemModel,
    required this.reporterName,
    this.reporterId,
    required this.lostLocation,
    required this.lostNotes,
    this.lostBadge1 = 'Registered: 2 hrs post-loss',
    this.lostBadge2 = 'Student Identity Confirmed',
    this.lostPhotoUrl,
    // Found Item
    required this.foundItemId,
    required this.foundDate,
    required this.foundItemTitle,
    required this.foundItemCategory,
    this.foundVaultBin,
    required this.finderName,
    required this.foundLocation,
    required this.foundNotes,
    this.custodyLocation = 'Custody: Security Lockbox #1',
    this.foundBadge2 = 'Hardware In Custody',
    this.foundPhotoUrl,
    // Multi-modal breakdown
    this.specsScore = 99,
    this.specsLabel = 'Exact Hardware',
    this.spatialScore = 98,
    this.spatialLabel = '< 15 Meters',
    this.timeGap = '2.5 hrs',
    this.timeGapLabel = 'Optimal Range',
    this.markingsLabel = 'Verified',
    this.markingsSubLabel = 'Sticker & Serial',
    // Audit & Adjudication
    this.internalAuditNote =
        'Serial verified by Officer Dave at desk. NASA sticker matches user submission photo exactly.',
    this.submittedTime = 'Today, 9:15 AM',
  });

  final String id;
  int similarityScore;
  MatchStatus status;
  final bool isAutoPaired;
  final String priorityLabel;
  final String similarityBadge;

  // Lost
  final String lostReportId;
  final String lostDate;
  final String lostItemTitle;
  final String lostItemCategory;
  final String? lostItemModel;
  final String reporterName;
  final String? reporterId;
  final String lostLocation;
  final String lostNotes;
  final String lostBadge1;
  final String lostBadge2;
  final String? lostPhotoUrl;

  // Found
  final String foundItemId;
  final String foundDate;
  final String foundItemTitle;
  final String foundItemCategory;
  final String? foundVaultBin;
  final String finderName;
  final String foundLocation;
  final String foundNotes;
  final String custodyLocation;
  final String foundBadge2;
  final String? foundPhotoUrl;

  // Multi-modal
  final int specsScore;
  final String specsLabel;
  final int spatialScore;
  final String spatialLabel;
  final String timeGap;
  final String timeGapLabel;
  final String markingsLabel;
  final String markingsSubLabel;

  // Audit
  String internalAuditNote;
  final String submittedTime;
}

enum MatchStatus {
  pending,
  confirmed,
  rejected,
  infoRequested,
}

extension MatchStatusX on MatchStatus {
  String get label => switch (this) {
    MatchStatus.pending => 'Pending Decision',
    MatchStatus.confirmed => 'Confirmed & Notified',
    MatchStatus.rejected => 'Rejected',
    MatchStatus.infoRequested => 'Info Requested',
  };
}
