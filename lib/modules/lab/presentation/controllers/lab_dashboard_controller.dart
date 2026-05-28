import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/routes/app_routes.dart';

class LabDashboardController extends GetxController {
  final _supabase = Supabase.instance.client;

  final isLoading = true.obs;
  final staffName = ''.obs;
  final pendingCount = 0.obs;
  final inProgressCount = 0.obs;
  final completedCount = 0.obs;
  final pendingRequests = <Map<String, dynamic>>[].obs;

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
        staffName.value = profile['full_name']?.toString() ?? 'Nhân viên Lab';
      }

      final requestsData = await _supabase
          .from('lab_requests')
          .select('id, status, priority, lab_tests(name), patients(full_name)')
          .order('created_at', ascending: false);

      final reqList = List<Map<String, dynamic>>.from(requestsData);
      pendingCount.value = reqList.where((r) => r['status'] == 'pending').length;
      inProgressCount.value =
          reqList.where((r) => r['status'] == 'in_progress').length;
      completedCount.value =
          reqList.where((r) => r['status'] == 'completed').length;

      pendingRequests.value = reqList
          .where((r) => r['status'] == 'pending')
          .map((r) => {
                'test_name': r['lab_tests']?['name'] ?? 'Xét nghiệm',
                'patient_name': r['patients']?['full_name'] ?? 'Bệnh nhân',
                'priority': r['priority'] ?? 'normal',
                'status': r['status'] ?? '',
              })
          .toList();
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
