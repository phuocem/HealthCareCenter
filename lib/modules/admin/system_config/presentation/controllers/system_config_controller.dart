import 'package:get/get.dart';
import '../../../data/providers/admin_provider.dart';

class SystemConfigController extends GetxController {
  final _adminProvider = AdminProvider();

  final isLoading = false.obs;
  final departments = <Map<String, dynamic>>[].obs;
  final services = <Map<String, dynamic>>[].obs;
  final labTestTypes = <Map<String, dynamic>>[].obs;
  final inventoryItems = <Map<String, dynamic>>[].obs;
  final suppliers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllConfig();
  }

  Future<void> loadAllConfig() async {
    try {
      isLoading.value = true;
      final results = await Future.wait<List<Map<String, dynamic>>>([
        _adminProvider.fetchDepartments(),
        _adminProvider.fetchServices(),
        _adminProvider.fetchLabTestTypes(),
        _adminProvider.fetchInventoryItems(),
        _adminProvider.fetchSuppliers(),
      ]);
      departments.assignAll(results[0]);
      services.assignAll(results[1]);
      labTestTypes.assignAll(results[2]);
      inventoryItems.assignAll(results[3]);
      suppliers.assignAll(results[4]);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải cấu hình: $e');
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> saveDepartment(Map<String, dynamic> data, {String? id}) async {
    try {
      isLoading.value = true;
      if (id == null) {
        await _adminProvider.createDepartment(data);
      } else {
        await _adminProvider.updateDepartment(id, data);
      }
      await loadAllConfig();
      Get.snackbar('Thành công', 'Đã lưu phòng ban');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lưu phòng ban: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDepartment(String id) async {
    try {
      await _adminProvider.deleteDepartment(id);
      await loadAllConfig();
      Get.snackbar('Thành công', 'Đã xóa phòng ban');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể xóa phòng ban: $e');
    }
  }

  
  Future<void> saveService(Map<String, dynamic> data, {String? id}) async {
    try {
      isLoading.value = true;
      if (id == null) {
        await _adminProvider.createService(data);
      } else {
        await _adminProvider.updateService(id, data);
      }
      await loadAllConfig();
      Get.snackbar('Thành công', 'Đã lưu dịch vụ');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lưu dịch vụ: $e');
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> saveLabTest(Map<String, dynamic> data, {String? id}) async {
    try {
      isLoading.value = true;
      if (id == null) {
        await _adminProvider.createLabTestType(data);
      } else {
        await _adminProvider.updateLabTestType(id, data);
      }
      await loadAllConfig();
      Get.snackbar('Thành công', 'Đã lưu loại xét nghiệm');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lưu xét nghiệm: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
