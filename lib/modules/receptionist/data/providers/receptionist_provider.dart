import 'package:supabase_flutter/supabase_flutter.dart';

class ReceptionistProvider {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchTodayAppointments() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return await _supabase
        .from('appointments')
        .select('*, user_profiles!appointments_patient_id_fkey(*), doctors(*, user_profiles(*))')
        .eq('appointment_date', today);
  }
}
