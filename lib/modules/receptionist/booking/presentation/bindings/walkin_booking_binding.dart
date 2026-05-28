import 'package:get/get.dart';
import '../controllers/walkin_booking_controller.dart';

class WalkinBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalkinBookingController>(() => WalkinBookingController());
  }
}
