import 'package:get/get.dart';

class TelemedicineCallController extends GetxController {
  final isMuted = false.obs;
  final isCameraOff = false.obs;
  final callDurationSec = 0.obs;
  
  final patientName = 'Nguyễn Văn A'.obs;
  final connectionStatus = 'Đang kết nối...'.obs;

  @override
  void onInit() {
    super.onInit();
    startCallTimer();
  }

  void startCallTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      connectionStatus.value = 'Đang kết nối trực tuyến';
      _incrementTimer();
    });
  }

  void _incrementTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (connectionStatus.value == 'Đang kết nối trực tuyến') {
        callDurationSec.value += 1;
        _incrementTimer();
      }
    });
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
  }

  void toggleCamera() {
    isCameraOff.value = !isCameraOff.value;
  }

  void endCall() {
    connectionStatus.value = 'Cuộc gọi đã kết thúc';
    Get.back();
    Get.snackbar('Hệ thống', 'Cuộc gọi telemedicine đã hoàn tất.');
  }
}
