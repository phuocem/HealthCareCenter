import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../../../../core/routes/app_routes.dart';

class DashboardController extends GetxController {
  final _repository = DashboardRepository();
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  final userName = 'Bệnh nhân'.obs;
  final userProfile = <String, dynamic>{}.obs;
  final doctors = <Map<String, dynamic>>[].obs;
  final upcomingAppointment = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;
      
      final results = await Future.wait([
        _repository.getProfile(userId),
        _repository.getDoctors(),
        _repository.getUpcomingAppointments(userId),
      ]);

      final profileMap = results[0] as Map<String, dynamic>;
      userProfile.value = profileMap;
      userName.value = profileMap['full_name'] ?? 'Bệnh nhân';
      
      doctors.assignAll(results[1] as List<Map<String, dynamic>>);
      final appointments = results[2] as List<Map<String, dynamic>>;
      if (appointments.isNotEmpty) {
        upcomingAppointment.value = appointments.first;
      }
    } catch (e) {
      print('Dashboard error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('Logout error: $e');
    }
  }
}
