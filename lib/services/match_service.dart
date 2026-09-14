import '../models/match_candidate.dart';

class MatchService {
  /// Mengambil daftar antrean kecocokan AI untuk ditinjau oleh Admin.
  List<MatchCandidate> getInitialCandidates() {
    return [
      // Hero Match dari Screenshot Referensi (#MTC-402)
      MatchCandidate(
        id: '#MTC-402',
        similarityScore: 96,
        isAutoPaired: true,
        priorityLabel: 'High Priority Property Match Review',
        similarityBadge: 'Near Identical Signature',
        lostReportId: '#REP-089',
        lostDate: 'Oct 23, 2024 • 2:30 PM',
        lostItemTitle: 'Apple MacBook Air 13" M2 Space Gray',
        lostItemCategory: 'Electronics',
        lostItemModel: 'Model: A2681',
        reporterName: 'Sarah Jenkins',
        reporterId: 'Student ID: 2021094',
        lostLocation: 'Library 2nd Floor East Wing',
        lostNotes:
            'Contains blue NASA insignia sticker on bottom-right of top lid. USB-C charger tucked in gray neoprene sleeve. Hardware serial ending in ...79X.',
        lostBadge1: 'Registered: 2 hrs post-loss',
        lostBadge2: 'Student Identity Confirmed',
        foundItemId: '#FND-114',
        foundDate: 'Oct 23, 2024 • 5:00 PM',
        foundItemTitle: 'Space Gray 13" Apple Laptop with Sticker',
        foundItemCategory: 'Electronics',
        foundVaultBin: 'Vault Bin: SEC-048',
        finderName: 'Campus Security (Officer Dave M.)',
        foundLocation: 'Library 2nd Floor Study Table 14',
        foundNotes:
            'Found unattended on table during sweep. Blue NASA sticker confirmed. Serial etched on bottom verified ending in ...79X.',
        custodyLocation: 'Custody: Security Lockbox #1',
        foundBadge2: 'Hardware In Custody',
        specsScore: 99,
        specsLabel: 'Exact Hardware',
        spatialScore: 98,
        spatialLabel: '< 15 Meters',
        timeGap: '2.5 hrs',
        timeGapLabel: 'Optimal Range',
        markingsLabel: 'Verified',
        markingsSubLabel: 'Sticker & Serial',
        internalAuditNote:
            'Serial verified by Officer Dave at desk. NASA sticker matches user submission photo exactly.',
        submittedTime: 'Today, 2:30 PM',
      ),

      // Kandidat Meja #MTC-403
      MatchCandidate(
        id: '#MTC-403',
        similarityScore: 91,
        lostReportId: '#REP-092',
        lostDate: 'Today • 9:00 AM',
        lostItemTitle: 'Set of 4 Dorm Keys',
        lostItemCategory: 'Keys & FOBs',
        reporterName: 'Michael C.',
        reporterId: 'South Tower',
        lostLocation: 'Near Dining Hall',
        lostNotes: '4 brass keys with a small blue tag on a ring.',
        foundItemId: '#FND-118',
        foundDate: 'Today • 9:15 AM',
        foundItemTitle: 'Dorm Keys w/ Green Carabiner',
        foundItemCategory: 'Keys & FOBs',
        finderName: 'Campus Dining Hall Staff',
        foundLocation: 'Campus Dining Hall',
        foundNotes: 'Set of dorm keys found near tray return counter with green carabiner.',
        submittedTime: 'Today, 9:15 AM',
      ),

      // Kandidat Meja #MTC-405
      MatchCandidate(
        id: '#MTC-405',
        similarityScore: 88,
        lostReportId: '#REP-078',
        lostDate: 'Yesterday • 5:00 PM',
        lostItemTitle: 'Sony WH-1000XM4',
        lostItemCategory: 'Audio / Tech',
        reporterName: 'Alex P.',
        reporterId: 'Student Center',
        lostLocation: '3rd Floor Lounge area',
        lostNotes: 'Black over-ear noise cancelling headphones in black zip case.',
        foundItemId: '#FND-110',
        foundDate: 'Yesterday • 6:40 PM',
        foundItemTitle: 'Sony Over-Ear Headphones',
        foundItemCategory: 'Audio / Tech',
        finderName: 'Janitorial Services',
        foundLocation: 'Found at 3rd Floor Lounge',
        foundNotes: 'Black Sony headphones found on sofa.',
        submittedTime: 'Yesterday, 6:40 PM',
      ),

      // Kandidat Meja #MTC-404
      MatchCandidate(
        id: '#MTC-404',
        similarityScore: 74,
        lostReportId: '#REP-065',
        lostDate: 'Oct 22 • 10:30 AM',
        lostItemTitle: 'Black Leather Fossil Wallet',
        lostItemCategory: 'Personal IDs',
        reporterName: 'Daniel W.',
        reporterId: 'Rec Gym',
        lostLocation: 'Gym Locker Room Bench',
        lostNotes: 'Black bi-fold wallet with student ID card and gym pass.',
        foundItemId: '#FND-098',
        foundDate: 'Oct 22 • 11:20 AM',
        foundItemTitle: 'Brown Bi-fold Wallet',
        foundItemCategory: 'Personal IDs',
        finderName: 'Gym Attendant',
        foundLocation: 'Found at Locker Room B',
        foundNotes: 'Leather wallet found inside locker B-12.',
        submittedTime: 'Oct 22, 11:20 AM',
      ),
    ];
  }
}
