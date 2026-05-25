import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserManagementProvider {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    return await _supabase
        .from('doctors')
        .select('*, user_profiles(*), departments(*)')
        .order('id');
  }

  Future<List<Map<String, dynamic>>> fetchStaff() async {
    return await _supabase
        .from('user_profiles')
        .select()
        .not('role', 'in', '("doctor","patient")')
        .order('full_name');
  }

  Future<List<Map<String, dynamic>>> fetchDepartments() async {
    return await _supabase.from('departments').select().order('name');
  }

  Future<List<Map<String, dynamic>>> fetchServices() async {
    return await _supabase
        .from('services')
        .select()
        .order('name');
  }

  Future<String> createDoctorProfile(Map<String, dynamic> data, String email, String password) async {
    
    
    final tempClient = SupabaseClient(
      dotenv.get('SUPABASE_URL'),
      dotenv.get('SUPABASE_ANON_KEY'),
      authOptions: const AuthClientOptions(
        authFlowType: AuthFlowType.implicit,
      ),
    );

    final response = await tempClient.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': data['profile']['full_name'],
      },
    );

    final newUserId = response.user?.id;
    if (newUserId == null) {
      throw Exception('Không thể tạo người dùng trong hệ thống Auth của Supabase.');
    }

    
    final profileData = Map<String, dynamic>.from(data['profile'])..['id'] = newUserId;
    final doctorData = Map<String, dynamic>.from(data['doctor'])..['id'] = newUserId;

    
    await _supabase.from('user_profiles').upsert(profileData);

    
    await _supabase.from('doctors').insert(doctorData);

    return newUserId;
  }

  Future<void> updateDoctor(String id, Map<String, dynamic> data) async {
    await _supabase.from('doctors').update(data).eq('id', id);
  }

  Future<List<Map<String, dynamic>>> fetchSchedules(String doctorId) async {
    return List<Map<String, dynamic>>.from(
      await _supabase.from('doctor_schedules').select().eq('doctor_id', doctorId),
    );
  }

  Future<void> addSchedule(Map<String, dynamic> data) async {
    await _supabase.from('doctor_schedules').insert(data);
  }

  Future<void> deleteSchedule(String id) async {
    await _supabase.from('doctor_schedules').delete().eq('id', id);
  }
}
