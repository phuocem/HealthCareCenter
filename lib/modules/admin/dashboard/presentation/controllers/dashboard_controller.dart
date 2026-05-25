import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../data/repositories/dashboard_repository.dart';

class DashboardController extends GetxController {
  final _repository = DashboardRepository();
  final isLoading = false.obs;
  final stats = <String, dynamic>{}.obs;
  final activities = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _repository.getStats(),
        _repository.getActivities(),
      ]);
      stats.assignAll(results[0] as Map<String, dynamic>);
      activities.assignAll(results[1] as List<Map<String, dynamic>>);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu thống kê');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStats() => loadData();

  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Lỗi', 'Đăng xuất thất bại: $e');
    }
  }
}
