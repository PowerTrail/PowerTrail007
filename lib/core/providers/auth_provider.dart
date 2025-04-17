import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:substation_control/core/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  User? _user;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService() {
    _authService.user.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  Future<void> signIn(String email, String password) async {
    try {
      _user = await _authService.signIn(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
  }
}
