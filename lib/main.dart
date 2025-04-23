import 'package:flutter/material.dart';
import 'package:power_grid_04/core/constants/colors.dart';
import 'package:power_grid_04/core/providers/auth_provider.dart';
import 'package:power_grid_04/core/providers/nav_provider.dart';
import 'package:power_grid_04/core/providers/substation_provider.dart';
import 'package:power_grid_04/core/providers/theme_provider.dart';
import 'package:power_grid_04/core/widgets/custom_bottom_nav.dart';
import 'package:power_grid_04/features/alerts/presentation/alerts_screen.dart';
import 'package:power_grid_04/features/dashboard/presentation/dashboard_screen.dart';
import 'package:power_grid_04/features/history/presentation/history_screen.dart';
import 'package:power_grid_04/features/map/presentation/map_screen.dart';
import 'package:provider/provider.dart';
import 'package:power_grid_04/features/auth/presentation/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Added
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SubstationProvider()), // Added
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Substation Control',
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: theme.themeMode,
      home: const AuthWrapper(), // Changed to AuthWrapper
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // If user is not authenticated, show login screen
    if (auth.user == null) {
      return const LoginScreen(); // You'll need to create this
    }

    // If authenticated, show main app
    return const MainNavigation();
  }
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NavProvider>(
        builder: (_, nav, __) => IndexedStack(
          index: nav.currentIndex,
          children: const [
            MapScreen(),
            DashboardScreen(),
            HistoryScreen(),
            AlertsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}
