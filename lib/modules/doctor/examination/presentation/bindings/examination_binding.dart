import 'package:get/get.dart';
import '../controllers/examination_controller.dart';

class ExaminationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExaminationController>(() => ExaminationController());
  }
}
