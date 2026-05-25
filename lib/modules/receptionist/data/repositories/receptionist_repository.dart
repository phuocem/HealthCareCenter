import '../providers/receptionist_provider.dart';

class ReceptionistRepository {
  final ReceptionistProvider _provider = ReceptionistProvider();

  Future<List<Map<String, dynamic>>> getTodayAppointments() async {
    return await _provider.fetchTodayAppointments();
  }
}
