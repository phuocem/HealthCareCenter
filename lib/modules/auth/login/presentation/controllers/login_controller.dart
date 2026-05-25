import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/login_repository.dart';
import '../../../../../core/routes/app_routes.dart';

class LoginController extends GetxController {
  final _repository = LoginRepository();
  final isLoading = false.obs;
  final showPassword = false.obs;

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Lưu ý', 'Vui lòng nhập đầy đủ email và mật khẩu');
      return;
    }

    try {
      isLoading.value = true;
      final response = await _repository.login(email, password);
      
      if (response.user != null) {
        final profile = await _repository.getUserProfile(response.user!.id);
        if (profile != null) {
          _redirectUser(profile['role']);
        } else {
          Get.snackbar('Lỗi', 'Không tìm thấy hồ sơ người dùng. Vui lòng liên hệ Admin.');
        }
      }
    } on AuthException catch (e) {
      Get.snackbar('Lỗi đăng nhập', _getAuthErrorMessage(e.message));
    } catch (e) {
      Get.snackbar('Lỗi hệ thống', 'Đã xảy ra lỗi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _getAuthErrorMessage(String message) {
    if (message.contains('Invalid login credentials')) return 'Email hoặc mật khẩu không chính xác';
    if (message.contains('Email not confirmed')) return 'Vui lòng xác nhận email trước khi đăng nhập';
    return message;
  }

  void _redirectUser(String role) {
    switch (role) {
      case 'admin': Get.offAllNamed(Routes.ADMIN_HOME); break;
      case 'doctor': Get.offAllNamed(Routes.DOCTOR_HOME); break;
      case 'patient': Get.offAllNamed(Routes.PATIENT_HOME); break;
      default: Get.offAllNamed(Routes.LOGIN);
    }
  }
}
