import 'package:flutter/material.dart';
import 'login_from.dart';
import 'signup_from.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const FlutterLogo(size: 100),
            const SizedBox(height: 40),
            TabBar(
              controller: _tabController,
              tabs: const [Tab(text: 'Login'), Tab(text: 'Sign Up')],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [LoginForm(), SignupForm()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
