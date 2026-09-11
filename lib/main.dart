import 'package:flutter/material.dart';
import 'screens/home_dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}

/// Widget kecil yang mengecek dulu apakah ada sesi login tersimpan
/// (lihat [AuthService.loadSession]) sebelum menentukan halaman awal:
/// langsung ke Home kalau sudah pernah login, atau ke Login kalau belum.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.loadSession(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFFF7F8FC),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final session = snapshot.data;
        if (session != null) {
          return HomeDashboardScreen(initialProfile: session);
        }
        return const LoginScreen();
      },
    );
  }
}