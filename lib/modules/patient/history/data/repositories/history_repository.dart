import '../providers/history_provider.dart';

class HistoryRepository {
  final HistoryProvider _provider = HistoryProvider();

  Future<List<Map<String, dynamic>>> getAppointments(String userId) async {
    return await _provider.fetchAppointments(userId);
  }
}
