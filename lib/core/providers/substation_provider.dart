import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubstationProvider with ChangeNotifier {
  double _voltage = 220.0;
  bool _isOnline = true;
  final List<Map<String, dynamic>> _actionLogs = [];
  final List<Map<String, dynamic>> _alerts = [];
  final SupabaseClient _supabase = Supabase.instance.client;

  double get voltage => _voltage;
  bool get isOnline => _isOnline;
  List<Map<String, dynamic>> get actionLogs => _actionLogs;
  List<Map<String, dynamic>> get alerts => _alerts;

  SubstationProvider() {
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await Future.wait([
      fetchSubstationStatus(),
      fetchActionLogs(),
      fetchAlerts(),
    ]);
  }

  Future<void> fetchSubstationStatus() async {
    try {
      final response = await _supabase
          .from('substations')
          .select('voltage_level, operational_status')
          .eq('id', 'main-substation') // Use your actual substation ID
          .single();
      
      _voltage = response['voltage_level'] ?? 220.0;
      _isOnline = response['operational_status'] == 'Fully operational';
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching substation status: $e');
      }
    }
  }

  Future<void> fetchActionLogs() async {
    try {
      final response = await _supabase
          .from('action_logs')
          .select('*')
          .order('timestamp', ascending: false)
          .limit(10);
      
      _actionLogs.clear();
      _actionLogs.addAll(response);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching action logs: $e');
      }
    }
  }

  Future<void> fetchAlerts() async {
    try {
      final response = await _supabase
          .from('alerts')
          .select('*')
          .order('timestamp', ascending: false)
          .limit(10);
      
      _alerts.clear();
      _alerts.addAll(response);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching alerts: $e');
      }
    }
  }

  Future<void> setVoltage(double value) async {
    _voltage = value;
    
    try {
      // Update in database
      await _supabase
          .from('substations')
          .update({'voltage_level': value})
          .eq('id', 'main-substation'); // Use your actual substation ID
      
      // Log action
      await _logAction('Voltage set to ${value.toStringAsFixed(1)}V');
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating voltage: $e');
      }
    }
  }

  Future<void> toggleStatus() async {
    _isOnline = !_isOnline;
    
    try {
      // Update in database
      await _supabase
          .from('substations')
          .update({'status': _isOnline ? 'Online' : 'Offline'})
          .eq('id', 'main-substation'); // Use your actual substation ID
      
      // Log action
      await _logAction('Power ${_isOnline ? 'ON' : 'OFF'}');
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating status: $e');
      }
    }
  }

  Future<void> _logAction(String action) async {
    final newAction = {
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'Completed',
      'substation_id': 'main-substation', // Use your actual substation ID
    };
    
    try {
      // Insert into database
      await _supabase.from('action_logs').insert(newAction);
      
      // Update local list
      _actionLogs.insert(0, newAction);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error logging action: $e');
      }
    }
  }

  Future<void> addAlert(String message, String severity) async {
    final newAlert = {
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      'severity': severity,
      'substation_id': 'main-substation', // Use your actual substation ID
    };
    
    try {
      // Insert into database
      await _supabase.from('alerts').insert(newAlert);
      
      // Update local list
      _alerts.insert(0, newAlert);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding alert: $e');
      }
    }
  }
}