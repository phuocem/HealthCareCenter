import '../providers/appointment_provider.dart';

class AppointmentRepository {
  final AppointmentProvider _provider = AppointmentProvider();

  Future<List<Map<String, dynamic>>> fetchAppointments(String doctorId) async {
    return await _provider.getDoctorAppointments(doctorId);
  }
}
