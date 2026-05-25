import 'package:supabase_flutter/supabase_flutter.dart';

class BookingProvider {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    return await _supabase.from('doctors').select('*, user_profiles(*), departments(*)').eq('is_active', true);
  }

  Future<List<Map<String, dynamic>>> fetchSchedules(String doctorId, int dayOfWeek) async {
    return await _supabase.from('doctor_schedules').select().eq('doctor_id', doctorId).eq('day_of_week', dayOfWeek);
  }

  Future<void> insertAppointment(Map<String, dynamic> data) async {
    await _supabase.from('appointments').insert(data);
  }
}
