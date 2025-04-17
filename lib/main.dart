import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:substation_control/core/constants/colors.dart';
import 'package:substation_control/core/providers/theme_provider.dart';
import 'package:substation_control/core/widgets/custom_bottom_nav.dart';
import 'package:substation_control/features/alerts/presentation/alerts_screen.dart';
import 'package:substation_control/features/auth/presentation/auth_screen.dart';
import 'package:substation_control/core/providers/auth_provider.dart';
import 'package:substation_control/core/providers/nav_provider.dart';
import 'package:substation_control/features/dashboard/presentation/dashboard_screen.dart';
import 'package:substation_control/features/history/presentation/history_screen.dart';
import 'package:substation_control/features/map/presentation/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return auth.user == null ? const AuthScreen() : const MainNavigation();
  }
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NavProvider>(
        builder:
            (_, nav, __) => IndexedStack(
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
