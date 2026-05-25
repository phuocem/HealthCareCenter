import '../providers/booking_provider.dart';

class BookingRepository {
  final BookingProvider _provider = BookingProvider();

  Future<List<Map<String, dynamic>>> getDoctors() async {
    return await _provider.fetchDoctors();
  }

  Future<List<Map<String, dynamic>>> getSchedules(String doctorId, int dayOfWeek) async {
    return await _provider.fetchSchedules(doctorId, dayOfWeek);
  }

  Future<void> bookAppointment(Map<String, dynamic> data) async {
    await _provider.insertAppointment(data);
  }
}
