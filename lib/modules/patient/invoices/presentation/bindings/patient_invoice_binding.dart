import 'package:get/get.dart';
import '../controllers/patient_invoice_controller.dart';

class PatientInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientInvoiceController>(() => PatientInvoiceController());
  }
}
