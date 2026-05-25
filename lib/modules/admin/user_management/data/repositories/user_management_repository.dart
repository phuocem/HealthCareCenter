import '../providers/user_management_provider.dart';

class UserManagementRepository {
  final _provider = UserManagementProvider();

  Future<List<Map<String, dynamic>>> getDoctors() async {
    return await _provider.fetchDoctors();
  }

  Future<List<Map<String, dynamic>>> getStaff() async {
    return await _provider.fetchStaff();
  }

  Future<List<Map<String, dynamic>>> getDepartments() async {
    return await _provider.fetchDepartments();
  }

  Future<List<Map<String, dynamic>>> getServices() async {
    return await _provider.fetchServices();
  }

  Future<String> createDoctor(Map<String, dynamic> data, String email, String password) async {
    return await _provider.createDoctorProfile(data, email, password);
  }

  Future<void> addDoctorSchedule(Map<String, dynamic> data) async {
    await _provider.addSchedule(data);
  }

  Future<List<Map<String, dynamic>>> getSchedules(String doctorId) async {
    return await _provider.fetchSchedules(doctorId);
  }

  Future<void> deleteSchedule(String id) async {
    await _provider.deleteSchedule(id);
  }
}
