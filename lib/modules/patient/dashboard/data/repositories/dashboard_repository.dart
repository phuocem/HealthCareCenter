import '../providers/dashboard_provider.dart';

class DashboardRepository {
  final DashboardProvider _provider = DashboardProvider();

  Future<Map<String, dynamic>> getProfile(String userId) async {
    return await _provider.fetchProfile(userId);
  }

  Future<List<Map<String, dynamic>>> getDoctors() async {
    return await _provider.fetchDoctors();
  }

  Future<List<Map<String, dynamic>>> getUpcomingAppointments(String userId) async {
    return await _provider.fetchUpcomingAppointments(userId);
  }
}
