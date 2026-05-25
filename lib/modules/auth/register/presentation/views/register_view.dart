import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../controllers/register_controller.dart';
class RegisterView extends GetView<RegisterController> {
  RegisterView({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF070B19), 
      body: Stack(
        children: [
          
          Positioned(
            top: -50,
            right: -50,
            width: 320,
            height: 320,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1F0284C7),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            width: 280,
            height: 280,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x14C084FC),
              ),
            ),
          ),
          
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: Container(color: Colors.transparent),
          ),

          
          Column(
            children: [
              
              SizedBox(
                height: size.height * 0.33,
                child: SafeArea(
                  bottom: false,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          child: Image.asset(
                            'assets/images/logo.png', 
                            width: 48, 
                            height: 48,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'TẠO TÀI KHOẢN',
                          style: TextStyle(
                            fontSize: 30, 
                            fontWeight: FontWeight.w900, 
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Đăng ký cổng dịch vụ số HealthX',
                          style: TextStyle(
                            fontSize: 13, 
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06), 
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ĐIỀN HỒ SƠ ĐĂNG KÝ',
                                style: TextStyle(
                                  fontSize: 11, 
                                  fontWeight: FontWeight.w900, 
                                  color: Color(0xFF38BDF8),
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 28),
                              _buildFields(),
                              const SizedBox(height: 32),
                              _buildRegisterActions(),
                              const SizedBox(height: 28),
                              _buildFooter(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        
        TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          decoration: InputDecoration(
            labelText: 'HỌ VÀ TÊN BẠN',
            labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
            prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF64748B), size: 20),
            filled: false,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1E293B), width: 1.5),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1E293B), width: 1.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF38BDF8), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 24),

        
        TextField(
          controller: emailController,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          decoration: InputDecoration(
            labelText: 'ĐỊA CHỈ EMAIL',
            labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
            prefixIcon: const Icon(Icons.alternate_email_rounded, color: Color(0xFF64748B), size: 20),
            filled: false,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1E293B), width: 1.5),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1E293B), width: 1.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF38BDF8), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 24),
        
        
        Obx(() => TextField(
          controller: passwordController,
          obscureText: !controller.showPassword.value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          decoration: InputDecoration(
            labelText: 'MẬT KHẨU TRUY CẬP',
            labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
            prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF64748B), size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                controller.showPassword.value ? Icons.visibility : Icons.visibility_off_rounded,
                color: const Color(0xFF64748B),
                size: 20,
              ),
              onPressed: () => controller.showPassword.toggle(),
            ),
            filled: false,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1E293B), width: 1.5),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1E293B), width: 1.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF38BDF8), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        )),
      ],
    );
  }

  Widget _buildRegisterActions() {
    return Row(
      children: [
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: const Icon(
            Icons.verified_user_rounded, 
            color: Color(0xFF38BDF8), 
            size: 26,
          ),
        ),
        const SizedBox(width: 16),

        
        Expanded(
          child: Obx(() => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: controller.isLoading.value 
                  ? null 
                  : () => controller.register(emailController.text, passwordController.text, nameController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38BDF8),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 58),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: controller.isLoading.value 
                ? const SizedBox(
                    height: 22, 
                    width: 22, 
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  ) 
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ĐĂNG KÝ NGAY', 
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Đã có tài khoản? ', 
          style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600, fontSize: 13),
        ),
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: const Text(
            'Đăng nhập', 
            style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
