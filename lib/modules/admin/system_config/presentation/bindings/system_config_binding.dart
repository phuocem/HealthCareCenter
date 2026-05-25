import 'package:get/get.dart';
import '../controllers/system_config_controller.dart';

class SystemConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SystemConfigController>(() => SystemConfigController());
  }
}
