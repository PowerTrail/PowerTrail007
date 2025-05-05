import 'package:flutter/material.dart';
import 'core/constants/colors.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/nav_provider.dart';
import 'core/providers/substation_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/widgets/custom_bottom_nav.dart';
import 'features/alerts/presentation/alerts_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/history/presentation/history_screen.dart';
import 'features/map/presentation/map_screen.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!, // Use dotenv to fetch SUPABASE_URL
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!, // Use dotenv to fetch SUPABASE_ANON_KEY
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SubstationProvider()),
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
