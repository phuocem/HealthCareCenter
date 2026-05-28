import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/routes/app_routes.dart';

class ReceptionistDashboardController extends GetxController {
  final _supabase = Supabase.instance.client;

  final isLoading = true.obs;
  final staffName = ''.obs;
  final todayAppointments = 0.obs;
  final waitingCount = 0.obs;
  final completedCount = 0.obs;
  final appointments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // Load staff name
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final profile = await _supabase
            .from('user_profiles')
            .select('full_name')
            .eq('id', user.id)
            .single();
        staffName.value = profile['full_name']?.toString() ?? 'Lễ tân';
      }

      // Load today appointments
      final today = DateTime.now();
      final todayStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final aptsData = await _supabase
          .from('appointments')
          .select(
              'id, status, appointment_date, appointment_time, patients(full_name), doctors(full_name)')
          .eq('appointment_date', todayStr)
          .order('appointment_time', ascending: true);

      final aptsList = List<Map<String, dynamic>>.from(aptsData);
      todayAppointments.value = aptsList.length;
      waitingCount.value =
          aptsList.where((a) => a['status'] == 'pending').length;
      completedCount.value =
          aptsList.where((a) => a['status'] == 'completed').length;

      appointments.value = aptsList.map((a) {
        return {
          'patient_name': a['patients']?['full_name'] ?? 'Bệnh nhân',
          'doctor_name': a['doctors']?['full_name'] ?? 'Bác sĩ',
          'time': a['appointment_time']?.toString().substring(0, 5) ?? '',
          'status': a['status'] ?? '',
        };
      }).toList();
    } catch (e) {
      // ignore errors silently for demo
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
