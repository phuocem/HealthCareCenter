import 'package:get/get.dart';
import '../controllers/medical_results_controller.dart';

class MedicalResultsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalResultsController>(() => MedicalResultsController());
  }
}
