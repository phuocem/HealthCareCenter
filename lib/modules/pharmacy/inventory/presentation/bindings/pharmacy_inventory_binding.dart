import 'package:get/get.dart';
import '../controllers/pharmacy_inventory_controller.dart';

class PharmacyInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyInventoryController>(() => PharmacyInventoryController());
  }
}
