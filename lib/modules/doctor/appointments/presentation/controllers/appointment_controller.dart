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
  
  final doctorPhone = '0988 777 888'.obs;
  final doctorLicense = 'CCHN-102948-BYT'.obs;
  final doctorExperience = '12'.obs;
  final doctorQualification = 'Thạc sĩ, Bác sĩ CKI'.obs;
  final doctorSchool = 'Đại học Y Dược TP.HCM'.obs;
  final doctorSubSpecialization = 'Can thiệp tim mạch, Siêu âm tim Doppler'.obs;
  final doctorCertificates = 'Chứng chỉ tim mạch can thiệp nâng cao, CME Siêu âm tim'.obs;
  final doctorClinicalFocus = 'Hồi sức tim mạch & Can thiệp lòng mạch'.obs;
  final doctorEmergencyName = 'Nguyễn Thị Hồng (Vợ)'.obs;
  final doctorEmergencyPhone = '0911 222 333'.obs;

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
        doctorName.value = profile['full_name'] ?? 'Bác sĩ Hoàng Nam';
        doctorEmail.value = profile['email'] ?? 'dr.hoangnam@healthx.com';
        doctorPhone.value = profile['phone'] ?? '0988 777 888';
        
        final docData = profile['doctors'] as Map?;
        if (docData != null) {
          doctorLicense.value = docData['license_number'] ?? 'CCHN-102948-BYT';
          doctorExperience.value = docData['experience_years']?.toString() ?? '12';
          doctorQualification.value = docData['qualification'] ?? 'Thạc sĩ, Bác sĩ CKI';
          doctorSchool.value = docData['school'] ?? 'Đại học Y Dược TP.HCM';
          doctorSubSpecialization.value = docData['specialization'] ?? 'Can thiệp tim mạch, Siêu âm tim Doppler';
          doctorCertificates.value = docData['certificates'] ?? 'Chứng chỉ tim mạch can thiệp nâng cao, CME Siêu âm tim';
          doctorClinicalFocus.value = docData['clinical_focus'] ?? 'Hồi sức tim mạch & Can thiệp lòng mạch';
          doctorEmergencyName.value = docData['emergency_relative_name'] ?? 'Nguyễn Thị Hồng (Vợ)';
          doctorEmergencyPhone.value = docData['emergency_relative_phone'] ?? '0911 222 333';
          
          final deptData = docData['departments'] as Map?;
          if (deptData != null) {
            doctorSpecialty.value = deptData['name'] ?? 'Khoa Tim Mạch';
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

  Future<void> updateAppointmentStatus(String id, String status) async {
    try {
      isLoading.value = true;
      await _client.from('appointments').update({'status': status}).eq('id', id);
      await loadDoctorSchedule();
      Get.snackbar('Thành công', 'Đã cập nhật trạng thái lịch hẹn.');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật trạng thái: $e');
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
