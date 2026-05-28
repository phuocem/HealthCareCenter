import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientInvoiceController extends GetxController {
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  final invoices = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    try {
      isLoading.value = true;
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      final data = await _client
          .from('invoices')
          .select('*, payments(*)')
          .eq('patient_id', userId)
          .order('id', ascending: false);

      invoices.assignAll(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách hóa đơn: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
