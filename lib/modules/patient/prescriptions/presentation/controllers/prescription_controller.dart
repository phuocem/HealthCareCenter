import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PrescriptionController extends GetxController {
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  final prescriptions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPrescriptions();
  }

  Future<void> loadPrescriptions() async {
    try {
      isLoading.value = true;
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      final data = await _client
          .from('prescriptions')
          .select('*, prescription_items(*, inventory_items(*)), medical_records!inner(*, doctors(user_profiles(*)), appointments(*, invoices(*)))')
          .eq('medical_records.patient_id', userId);

      prescriptions.assignAll(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải đơn thuốc: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
