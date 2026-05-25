import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../data/repositories/appointment_repository.dart';

class AppointmentController extends GetxController {
  final _repository = AppointmentRepository();
  final _client = Supabase.instance.client;
  
  final isLoading = false.obs;
  final appointments = <Map<String, dynamic>>[].obs;
  final doctorName = 'Bác sĩ'.obs;
  final doctorEmail = ''.obs;
  final doctorSpecialty = 'Khoa chuyên môn'.obs;

  @override
  void onInit() {
    super.onInit();
    loadDoctorSchedule();
  }

  Future<void> loadDoctorSchedule() async {
    try {
      isLoading.value = true;
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;
      
      
      final profile = await _client.from('user_profiles').select('*, doctors(*, departments(*))').eq('id', userId).maybeSingle();
      if (profile != null) {
        doctorName.value = profile['full_name'] ?? 'Bác sĩ';
        doctorEmail.value = profile['email'] ?? '';
        final docData = profile['doctors'] as Map?;
        if (docData != null) {
          final deptData = docData['departments'] as Map?;
          if (deptData != null) {
            doctorSpecialty.value = deptData['name'] ?? 'Khoa chuyên môn';
          }
        }
      }

      final data = await _repository.fetchAppointments(userId);
      appointments.assignAll(data);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải lịch khám: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Lỗi', 'Đăng xuất thất bại: $e');
    }
  }
}
