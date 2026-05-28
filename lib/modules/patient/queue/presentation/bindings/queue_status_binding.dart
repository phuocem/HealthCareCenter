import 'package:get/get.dart';
import '../controllers/queue_status_controller.dart';

class QueueStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QueueStatusController>(() => QueueStatusController());
  }
}
