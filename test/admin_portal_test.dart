import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findit/controllers/admin_match_controller.dart';
import 'package:findit/models/match_candidate.dart';
import 'package:findit/models/user_profile.dart';
import 'package:findit/views/screens/admin/admin_match_review_screen.dart';

void main() {
  group('AdminMatchController Unit Tests', () {
    test('initializes with 4 candidates and selects first candidate #MTC-402', () {
      final controller = AdminMatchController();
      expect(controller.allCandidates.length, 4);
      expect(controller.selectedCandidate?.id, '#MTC-402');
      expect(controller.pendingCount, 4);
      expect(controller.thresholdFilter, ScoreThresholdFilter.all);
    });

    test('filters candidates by score threshold', () {
      final controller = AdminMatchController();

      // >90%
      controller.setThreshold(ScoreThresholdFilter.above90);
      expect(controller.filteredCandidates.every((c) => c.similarityScore > 90), isTrue);

      // 80-90%
      controller.setThreshold(ScoreThresholdFilter.range80to90);
      expect(
        controller.filteredCandidates.every((c) => c.similarityScore >= 80 && c.similarityScore <= 90),
        isTrue,
      );

      // <80%
      controller.setThreshold(ScoreThresholdFilter.below80);
      expect(controller.filteredCandidates.every((c) => c.similarityScore < 80), isTrue);
    });

    test('filters candidates by search query', () {
      final controller = AdminMatchController();
      controller.setSearchQuery('MacBook');
      expect(controller.filteredCandidates.length, 1);
      expect(controller.filteredCandidates.first.lostItemTitle, contains('MacBook'));

      controller.setSearchQuery('NonExistentQueryXYZ');
      expect(controller.filteredCandidates.isEmpty, isTrue);
    });

    test('adjudication updates match candidate status', () {
      final controller = AdminMatchController();

      // Confirm
      controller.confirmMatch('#MTC-402', 'Confirmed by Security Lead');
      expect(controller.allCandidates.firstWhere((c) => c.id == '#MTC-402').status, MatchStatus.confirmed);
      expect(controller.allCandidates.firstWhere((c) => c.id == '#MTC-402').internalAuditNote, 'Confirmed by Security Lead');

      // Reject
      controller.rejectMatch('#MTC-403', 'Mismatched serial number');
      expect(controller.allCandidates.firstWhere((c) => c.id == '#MTC-403').status, MatchStatus.rejected);

      // Request Info
      controller.requestInfo('#MTC-404');
      expect(controller.allCandidates.firstWhere((c) => c.id == '#MTC-404').status, MatchStatus.infoRequested);
    });

    test('selecting a candidate updates selectedCandidate and pending table', () {
      final controller = AdminMatchController();
      final candidate403 = controller.allCandidates.firstWhere((c) => c.id == '#MTC-403');
      controller.selectCandidate(candidate403);

      expect(controller.selectedCandidate?.id, '#MTC-403');
      expect(controller.pendingTableCandidates.any((c) => c.id == '#MTC-403'), isFalse);
    });
  });

  group('AdminMatchReviewScreen Widget Tests', () {
    testWidgets('renders full Admin Portal on desktop viewport (1280x900)', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final adminUser = UserProfile(
        name: 'Sarah Jenkins',
        email: 'sarah.j@campus.edu',
        phone: '',
        role: 'admin',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AdminMatchReviewScreen(userProfile: adminUser),
        ),
      );
      await tester.pumpAndSettle();

      // Header and Navigation
      expect(find.text('MATCH VERIFICATION CONSOLE', skipOffstage: false), findsOneWidget);
      expect(find.text('Admin Portal', skipOffstage: false), findsWidgets);
      expect(find.text('Desk Station: North Quad Center', skipOffstage: false), findsOneWidget);

      // Hero Review Card
      expect(find.text('96%', skipOffstage: false), findsWidgets);
      expect(find.text('Near Identical Signature', skipOffstage: false), findsOneWidget);
      expect(find.text('MULTI-MODAL MATCH BREAKDOWN', skipOffstage: false), findsOneWidget);
      expect(find.text('Item Model & Specs', skipOffstage: false), findsOneWidget);

      // Adjudication Bar
      expect(find.text('Confirm & Notify Both Parties', skipOffstage: false), findsOneWidget);
      expect(find.text('Reject Candidate', skipOffstage: false), findsOneWidget);

      // Pending Candidates Table
      expect(find.text('Other Pending Match Candidates', skipOffstage: false), findsOneWidget);
      expect(find.text('#MTC-403', skipOffstage: false), findsWidgets);
    });

    testWidgets('renders cleanly on mobile viewport (390x844)', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final adminUser = UserProfile(
        name: 'Sarah Jenkins',
        email: 'sarah.j@campus.edu',
        phone: '',
        role: 'admin',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AdminMatchReviewScreen(userProfile: adminUser),
        ),
      );
      await tester.pumpAndSettle();

      // Should find hamburger menu button
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.text('MATCH VERIFICATION CONSOLE', skipOffstage: false), findsOneWidget);
    });
  });
}
