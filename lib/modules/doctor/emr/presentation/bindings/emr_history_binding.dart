import 'package:get/get.dart';
import '../controllers/emr_history_controller.dart';

class EmrHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmrHistoryController>(() => EmrHistoryController());
  }
}
