import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/dashboard_provider.dart';
import 'screens/dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ReiterDashboardApp());
}

class ReiterDashboardApp extends StatelessWidget {
  const ReiterDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider()..initialize(),
      child: MaterialApp(
        title: 'Reiter USA — Logistics Dashboard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const DashboardScreen(),
      ),
    );
  }
}
