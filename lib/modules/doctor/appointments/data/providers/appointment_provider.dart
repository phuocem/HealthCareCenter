import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentProvider {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getDoctorAppointments(String doctorId) async {
    return await _supabase
        .from('appointments')
        .select('*, user_profiles!appointments_patient_id_fkey(*)')
        .eq('doctor_id', doctorId);
  }
}
