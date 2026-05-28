import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicalResultsController extends GetxController {
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  final medicalRecords = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicalRecords();
  }

  Future<void> loadMedicalRecords() async {
    try {
      isLoading.value = true;
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      final data = await _client
          .from('medical_records')
          .select('*, doctors(user_profiles(*)), lab_requests(*, lab_request_items(*, lab_results(*), lab_test_types(*)))')
          .eq('patient_id', userId)
          .order('created_at', ascending: false);

      medicalRecords.assignAll(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải kết quả khám: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
