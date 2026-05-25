import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryProvider {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchAppointments(String userId) async {
    return await _supabase
        .from('appointments')
        .select('*, doctors(*, user_profiles(*))')
        .eq('patient_id', userId)
        .order('appointment_date', ascending: false);
  }
}
