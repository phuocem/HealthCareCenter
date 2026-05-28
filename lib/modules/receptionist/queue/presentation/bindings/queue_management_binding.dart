import 'package:get/get.dart';
import '../controllers/queue_management_controller.dart';

class QueueManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QueueManagementController>(() => QueueManagementController());
  }
}
