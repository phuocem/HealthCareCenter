import 'package:get/get.dart';
import '../controllers/telemedicine_call_controller.dart';

class TelemedicineCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TelemedicineCallController>(() => TelemedicineCallController());
  }
}
