import 'package:get/get.dart';
import '../controllers/receptionist_appointments_controller.dart';

class ReceptionistAppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceptionistAppointmentsController>(() => ReceptionistAppointmentsController());
  }
}
