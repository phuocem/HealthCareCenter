import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/routes/app_routes.dart';

class ReceptionistAppointmentsController extends GetxController {
  final _client = Supabase.instance.client;
  
  final isLoading = false.obs;
  final appointments = <Map<String, dynamic>>[].obs;
  final currentTab = 0.obs; // 0: Tất cả, 1: Chờ xác nhận, 2: Đã xác nhận, 3: Đã check-in, 4: Hoàn thành

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      isLoading.value = true;
      
      // Query today's appointments with details
      final data = await _client
          .from('appointments')
          .select('*, user_profiles!appointments_patient_id_fkey(*), doctors(*, user_profiles(*), departments(*))')
          .order('start_time', ascending: true);

      if (data != null) {
        appointments.assignAll(List<Map<String, dynamic>>.from(data));
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách hẹn: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get filteredAppointments {
    if (currentTab.value == 0) return appointments;
    
    String targetStatus = 'pending';
    if (currentTab.value == 1) targetStatus = 'pending';
    if (currentTab.value == 2) targetStatus = 'confirmed';
    if (currentTab.value == 3) targetStatus = 'checked_in';
    if (currentTab.value == 4) targetStatus = 'completed';

    return appointments.where((apt) => apt['status'] == targetStatus).toList();
  }

  Future<void> confirmAppointment(String id) async {
    try {
      isLoading.value = true;
      await _client.from('appointments').update({'status': 'confirmed'}).eq('id', id);
      await loadAppointments();
      Get.snackbar('Thành công', 'Đã xác nhận lịch hẹn thành công.');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể xác nhận lịch hẹn: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIn(String id) async {
    try {
      isLoading.value = true;
      await _client.from('appointments').update({'status': 'checked_in'}).eq('id', id);
      await loadAppointments();
      Get.snackbar('Thành công', 'Đã tiếp nhận bệnh nhân (Check-in thành công).');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể check-in: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelAppointment(String id) async {
    try {
      isLoading.value = true;
      await _client.from('appointments').update({'status': 'cancelled'}).eq('id', id);
      await loadAppointments();
      Get.snackbar('Thành công', 'Đã hủy lịch hẹn.');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể hủy lịch hẹn: $e');
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
