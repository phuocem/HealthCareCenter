import 'package:get/get.dart';
import '../../data/repositories/register_repository.dart';
import '../../../../../core/routes/app_routes.dart';

class RegisterController extends GetxController {
  final _repository = RegisterRepository();
  final isLoading = false.obs;
  final showPassword = false.obs;

  Future<void> register(String email, String password, String fullName) async {
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      Get.snackbar('Thông báo', 'Vui lòng điền đầy đủ thông tin');
      return;
    }

    try {
      isLoading.value = true;
      await _repository.register(email, password, fullName);
      Get.snackbar('Thành công', 'Đăng ký tài khoản thành công! Vui lòng đăng nhập.');
      Get.offNamed(Routes.LOGIN);
    } catch (e) {
      final errorStr = e.toString();
      if (errorStr.contains('User already registered') || errorStr.contains('already exists')) {
        Get.snackbar('Thông báo', 'Tài khoản này đã tồn tại. Vui lòng đăng nhập.');
        Get.offNamed(Routes.LOGIN);
      } else {
        Get.snackbar('Lỗi', 'Đăng ký thất bại: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
