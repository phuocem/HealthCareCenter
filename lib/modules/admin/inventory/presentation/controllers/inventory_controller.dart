import 'package:get/get.dart';
import '../../data/repositories/inventory_repository.dart';

class InventoryController extends GetxController {
  final _repository = InventoryRepository();
  
  final isLoading = false.obs;
  final inventoryItems = <Map<String, dynamic>>[].obs;
  final transactions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _repository.getInventory(),
        _repository.getRecentTransactions(),
      ]);
      inventoryItems.assignAll(results[0] as List<Map<String, dynamic>>);
      transactions.assignAll(results[1] as List<Map<String, dynamic>>);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu kho: $e');
    } finally {
      isLoading.value = false;
    }
  }

  int getTotalStock(Map<String, dynamic> item) {
    final batches = item['inventory_batches'] as List?;
    if (batches == null || batches.isEmpty) return 0;
    return batches.fold(0, (sum, batch) => sum + (batch['quantity'] as int));
  }

  int getExpiredCount() {
    int count = 0;
    final now = DateTime.now();
    for (var item in inventoryItems) {
      final batches = item['inventory_batches'] as List?;
      if (batches != null) {
        for (var batch in batches) {
          final expiryStr = batch['expiry_date'] as String?;
          if (expiryStr != null) {
            try {
              final expiry = DateTime.parse(expiryStr);
              if (expiry.isBefore(now)) {
                count++;
                break; 
              }
            } catch (_) {}
          }
        }
      }
    }
    return count;
  }
}
