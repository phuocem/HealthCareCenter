import 'package:get/get.dart';
import '../controllers/pharmacist_dashboard_controller.dart';

class PharmacistDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacistDashboardController>(
        () => PharmacistDashboardController());
  }
}
