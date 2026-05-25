import '../providers/dashboard_provider.dart';

class DashboardRepository {
  final DashboardProvider _provider = DashboardProvider();

  Future<Map<String, dynamic>> getStats() async {
    return await _provider.fetchSystemStats();
  }

  Future<List<Map<String, dynamic>>> getActivities() async {
    return await _provider.fetchRecentActivities();
  }
}
