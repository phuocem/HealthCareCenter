import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardProvider {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchSystemStats() async {
    
    final pRes = await _supabase.from('user_profiles').select('*').eq('role', 'patient').count(CountOption.exact);
    final dRes = await _supabase.from('user_profiles').select('*').eq('role', 'doctor').count(CountOption.exact);
    final aRes = await _supabase.from('appointments').select('*').count(CountOption.exact);

    final rRes = await _supabase.from('payments').select('amount');
    double totalRevenue = 0;
    for (var row in rRes) {
      totalRevenue += (row['amount'] as num).toDouble();
    }

    return {
      'total_patients': pRes.count,
      'total_doctors': dRes.count,
      'total_appointments': aRes.count,
      'total_revenue': totalRevenue,
    };
  }

  Future<List<Map<String, dynamic>>> fetchRecentActivities() async {
    
    final appointments = await _supabase
        .from('appointments')
        .select('*, user_profiles!patient_id(full_name)')
        .order('created_at', ascending: false)
        .limit(5);
    
    return List<Map<String, dynamic>>.from(appointments.map((e) => {
      'type': 'appointment',
      'title': 'Lịch hẹn mới: ${e['user_profiles']?['full_name'] ?? 'Ẩn danh'}',
      'time': e['created_at'],
    }));
  }
}
