import 'package:get/get.dart';
import '../controllers/receptionist_dashboard_controller.dart';

class ReceptionistDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceptionistDashboardController>(
        () => ReceptionistDashboardController());
  }
}
