import 'package:get/get.dart';
import '../controllers/lab_dashboard_controller.dart';

class LabDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabDashboardController>(() => LabDashboardController());
  }
}
