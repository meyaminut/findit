import 'package:flutter/material.dart';
import 'features/worker/screens/worker_dashboard_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FindIt!',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
      ),
      home: const WorkerDashboardPage(),
    );
  }
}