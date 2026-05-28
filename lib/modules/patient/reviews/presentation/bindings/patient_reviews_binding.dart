import 'package:get/get.dart';
import '../controllers/patient_reviews_controller.dart';

class PatientReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientReviewsController>(() => PatientReviewsController());
  }
}
