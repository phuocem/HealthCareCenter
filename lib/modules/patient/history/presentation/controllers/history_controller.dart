import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/history_repository.dart';

class HistoryController extends GetxController {
  final _repository = HistoryRepository();
  final _client = Supabase.instance.client;
  
  final isLoading = false.obs;
  final historyList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      isLoading.value = true;
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;
      
      final data = await _repository.getAppointments(userId);
      historyList.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Could not load history');
    } finally {
      isLoading.value = false;
    }
  }
}
