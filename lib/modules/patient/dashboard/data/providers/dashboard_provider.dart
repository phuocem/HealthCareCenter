import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardProvider {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchProfile(String userId) async {
    return await _supabase.from('user_profiles').select().eq('id', userId).single();
  }

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    return await _supabase.from('doctors').select('*, user_profiles(*), departments(name)').limit(5);
  }

  Future<List<Map<String, dynamic>>> fetchUpcomingAppointments(String userId) async {
    return await _supabase.from('appointments').select('*, doctors(*, user_profiles(*))').eq('patient_id', userId).gt('appointment_date', DateTime.now().toIso8601String()).order('appointment_date').limit(1);
  }
}
