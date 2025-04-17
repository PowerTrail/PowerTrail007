import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubstationProvider with ChangeNotifier {
  double _voltage = 220.0;
  bool _isOnline = true;
  final List<Map<String, dynamic>> _actionLogs = [];
  final List<Map<String, dynamic>> _alerts = [];

  double get voltage => _voltage;
  bool get isOnline => _isOnline;
  List<Map<String, dynamic>> get actionLogs => _actionLogs;
  List<Map<String, dynamic>> get alerts => _alerts;

  SubstationProvider() {
    _initializeData();
  }

  void _initializeData() {
    // Mock data initialization
    _actionLogs.addAll([
      {
        'action': 'Voltage adjusted to 220V',
        'timestamp': Timestamp.now(),
        'status': 'Completed',
      },
      {
        'action': 'Circuit breaker reset',
        'timestamp': Timestamp.now(),
        'status': 'Pending',
      },
    ]);

    _alerts.addAll([
      {
        'message': 'Voltage spike detected',
        'timestamp': '2 minutes ago',
        'severity': 'critical',
      },
      {
        'message': 'Temperature above threshold',
        'timestamp': '15 minutes ago',
        'severity': 'warning',
      },
    ]);
  }

  void setVoltage(double value) {
    _voltage = value;
    _logAction('Voltage set to ${value.toStringAsFixed(1)}V');
    notifyListeners();
  }

  void toggleStatus() {
    _isOnline = !_isOnline;
    _logAction('Power ${_isOnline ? 'ON' : 'OFF'}');
    notifyListeners();
  }

  void _logAction(String action) {
    _actionLogs.insert(0, {
      'action': action,
      'timestamp': Timestamp.now(),
      'status': 'Completed',
    });
  }

  void addAlert(String message, String severity) {
    _alerts.insert(0, {
      'message': message,
      'timestamp': DateTime.now().toString(),
      'severity': severity,
    });
    notifyListeners();
  }
}
