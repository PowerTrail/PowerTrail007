import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;
  
  // Substations
  Future<List<Map<String, dynamic>>> getSubstations() async {
    try {
      final response = await client
          .from('substations')
          .select('id, name, district_id, voltage_level, latitude, longitude, commissioned_date, operational_status, transformer_capacity, control_system, updated_at')
          .order('name');
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching substations: $e');
      }
      return [];
    }
  }
  
  // Solar plants
  Future<List<Map<String, dynamic>>> getSolarPlants() async {
    try {
      final response = await client
          .from('solar_plants')
          .select('id, developer, location, district_id, ac_capacity, dc_capacity, substation, commissioning_date, latitude, longitude')
          .order('developer');
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching solar plants: $e');
      }
      return [];
    }
  }
  
  // Wind farms
  Future<List<Map<String, dynamic>>> getWindFarms() async {
    try {
      final response = await client
          .from('wind_farms')
          .select('id, owner, village, substation, district_id, total_approved_capacity, wind_capacity, commissioning_date, latitude, longitude')
          .order('owner');
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching wind farms: $e');
      }
      return [];
    }
  }
  
  // Hybrid projects
  Future<List<Map<String, dynamic>>> getHybridProjects() async {
    try {
      final response = await client
          .from('hybrid_projects')
          .select('id, owner, village, substation, district_id, total_approved_capacity, wind_capacity, solar_capacity, commissioning_date')
          .order('owner');
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching hybrid projects: $e');
      }
      return [];
    }
  }
  
  // Get district name by id
  Future<String> getDistrictName(String districtId) async {
    try {
      final response = await client
          .from('districts')
          .select('name')
          .eq('id', districtId)
          .single();
      
      return response['name'] as String;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching district name: $e');
      }
      return 'Unknown District';
    }
  }
  
  // Log action
  Future<void> logAction(String action, String substationId, String status) async {
    try {
      await client.from('action_logs').insert({
        'action': action,
        'substation_id': substationId,
        'timestamp': DateTime.now().toIso8601String(),
        'status': status
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error logging action: $e');
      }
    }
  }
  
  // Get action logs for a substation
  Future<List<Map<String, dynamic>>> getActionLogs(String substationId) async {
    try {
      final response = await client
          .from('action_logs')
          .select('*')
          .eq('substation_id', substationId)
          .order('timestamp', ascending: false)
          .limit(10);
      
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching action logs: $e');
      }
      return [];
    }
  }
}