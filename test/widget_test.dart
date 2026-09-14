import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:findit/main.dart';
import 'package:findit/views/screens/auth/login_screen.dart';
import 'package:findit/views/screens/dashboard/home_dashboard_screen.dart';
import 'package:findit/models/user_profile.dart';

void main() {
  testWidgets('app loads with login screen and logo when no session', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    expect(find.text('Masuk'), findsOneWidget);
  });

  testWidgets('app loads with dashboard and logo when session exists', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final prefs = await SharedPreferences.getInstance();
    final mockUser = UserProfile(name: 'Test User', email: 'test@example.com', phone: '08123456789');
    await prefs.setString('findit_session_user', jsonEncode(mockUser.toJson()));

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeDashboardScreen), findsOneWidget);
    expect(find.byType(Image, skipOffstage: false), findsWidgets);
    expect(find.text('Report Lost', skipOffstage: false), findsOneWidget);
  });

  testWidgets('app adapts to mobile screen size', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final prefs = await SharedPreferences.getInstance();
    final mockUser = UserProfile(name: 'Mobile User', email: 'mobile@example.com', phone: '08123456789');
    await prefs.setString('findit_session_user', jsonEncode(mockUser.toJson()));

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeDashboardScreen), findsOneWidget);
    expect(find.byType(Image, skipOffstage: false), findsWidgets);
    expect(find.text('Report Lost', skipOffstage: false), findsOneWidget);
  });
}
