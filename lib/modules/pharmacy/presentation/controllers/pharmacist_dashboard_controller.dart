import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/routes/app_routes.dart';

class PharmacistDashboardController extends GetxController {
  final _supabase = Supabase.instance.client;

  final isLoading = true.obs;
  final staffName = ''.obs;
  final pendingPrescriptions = 0.obs;
  final dispensedCount = 0.obs;
  final lowStockCount = 0.obs;
  final prescriptions = <Map<String, dynamic>>[].obs;
  final lowStockItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      final user = _supabase.auth.currentUser;
      if (user != null) {
        final profile = await _supabase
            .from('user_profiles')
            .select('full_name')
            .eq('id', user.id)
            .single();
        staffName.value = profile['full_name']?.toString() ?? 'Dược sĩ';
      }

      // Load prescriptions
      final rxData = await _supabase
          .from('prescriptions')
          .select('id, status, patients(full_name), doctors(full_name), prescription_items(count)')
          .order('created_at', ascending: false);

      final rxList = List<Map<String, dynamic>>.from(rxData);
      pendingPrescriptions.value = rxList.where((r) => r['status'] == 'pending').length;
      dispensedCount.value = rxList.where((r) => r['status'] == 'dispensed').length;

      prescriptions.value = rxList
          .where((r) => r['status'] == 'pending')
          .map((r) => {
                'patient_name': r['patients']?['full_name'] ?? 'Bệnh nhân',
                'doctor_name': r['doctors']?['full_name'] ?? 'Bác sĩ',
                'item_count': r['prescription_items'] is List
                    ? (r['prescription_items'] as List).length
                    : 0,
              })
          .toList();

      // Load low stock
      final stockData = await _supabase
          .from('medicines')
          .select('id, name, quantity, min_quantity')
          .filter('quantity', 'lte', 'min_quantity');

      final stockList = List<Map<String, dynamic>>.from(stockData);
      lowStockCount.value = stockList.length;
      lowStockItems.value = stockList;
    } catch (e) {
      // ignore
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
