import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  MockUser? _user; // Explicitly typed as MockUser (non-nullable after login)

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    _authService.user.listen((user) {
      _user = user; // Stream provides MockUser? which matches our type
      notifyListeners();
    });
  }

  MockUser? get user => _user; // Expose typed user

  Future<void> signIn(String email, String password) async {
    try {
      _user = await _authService.signIn(email, password); // Returns MockUser?
      notifyListeners(); // Added missing notify
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners(); // Added missing notify
  }
}
