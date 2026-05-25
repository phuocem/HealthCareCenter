import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/user_management_controller.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/routes/app_routes.dart';

class AddDoctorView extends GetView<UserManagementController> {
  AddDoctorView({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final licenseController = TextEditingController();
  final experienceController = TextEditingController();
  
  final RxString selectedDept = ''.obs;
  final RxMap<String, dynamic> selectedService = <String, dynamic>{}.obs;

  
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final licenseFocusNode = FocusNode();
  final experienceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminBg,
      appBar: AppBar(
        title: const Text(
          'Thêm Bác Sĩ Mới', 
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18, letterSpacing: -0.5),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.departments.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepIndicator(),
              const SizedBox(height: 24),

              _buildSectionTitle('TÀI KHOẢN HỆ THỐNG'),
              _buildCard([
                _buildTextField(emailController, 'Email đăng nhập', Icons.email_outlined, focusNode: emailFocusNode),
                _buildTextField(passwordController, 'Mật khẩu tạm thời', Icons.lock_outline_rounded, isPassword: true, focusNode: passwordFocusNode),
              ]),
              const SizedBox(height: 24),
              
              _buildSectionTitle('THÔNG TIN CÁ NHÂN'),
              _buildCard([
                _buildTextField(nameController, 'Họ và tên bác sĩ', Icons.person_outline_rounded, focusNode: nameFocusNode),
                _buildTextField(licenseController, 'Số chứng chỉ hành nghề', Icons.badge_outlined, focusNode: licenseFocusNode),
                _buildTextField(experienceController, 'Số năm kinh nghiệm', Icons.work_history_outlined, isNumber: true, focusNode: experienceFocusNode),
              ]),
              const SizedBox(height: 24),
              
              _buildSectionTitle('CHUYÊN MÔN & PHÍ KHÁM'),
              _buildCard([
                const Text(
                  'Phòng ban trực thuộc', 
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 10),
                _buildDepartmentDropdown(),
                const SizedBox(height: 20),
                const Text(
                  'Loại dịch vụ & Phí khám', 
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 10),
                _buildServiceDropdown(),
                const SizedBox(height: 16),
                _buildPriceDisplay(),
              ]),
              const SizedBox(height: 36),
              
              _buildNextButton(),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF38BDF8),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BƯỚC 1/2: THÔNG TIN BÁC SĨ',
                  style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
                SizedBox(height: 2),
                Text(
                  'Nhập thông tin cơ bản & chuyên môn',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 12,
            decoration: BoxDecoration(
              gradient: AppColors.neonBlueGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title, 
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDepartmentDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: AppColors.adminSurface,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.02),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.adminCardBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      hint: const Text('Chọn phòng ban', style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500)),
      items: controller.departments.map((dept) => DropdownMenuItem(
        value: dept['id'].toString(),
        child: Text(dept['name']),
      )).toList(),
      onChanged: (val) {
        selectedDept.value = val ?? '';
        selectedService.clear(); 
      },
    );
  }

  Widget _buildServiceDropdown() {
    return Obx(() {
      final filteredServices = controller.services.where((s) => s['department_id'] == selectedDept.value).toList();
      
      if (selectedDept.isEmpty) {
        return const Text('Vui lòng chọn phòng ban trước', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500));
      }
      
      if (filteredServices.isEmpty) {
        return const Text('Không tìm thấy dịch vụ khám cho khoa này', style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w500));
      }

      return DropdownButtonFormField<Map<String, dynamic>>(
        dropdownColor: AppColors.adminSurface,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.02),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.adminCardBorder, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        hint: const Text('Chọn loại dịch vụ khám', style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500)),
        items: filteredServices.map((service) => DropdownMenuItem(
          value: service,
          child: Text(service['name']),
        )).toList(),
        onChanged: (val) {
          if (val != null) {
            selectedService.value = val;
          }
        },
      );
    });
  }

  Widget _buildPriceDisplay() {
    return Obx(() {
      if (selectedService.isEmpty) return const SizedBox.shrink();
      final price = selectedService['base_price'] ?? 0.0;
      final formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.15), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Phí khám áp dụng:', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w800, fontSize: 13)),
            Text(formattedPrice, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w900, fontSize: 16)),
          ],
        ),
      );
    });
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String hint, 
    IconData icon, {
    bool isPassword = false, 
    bool isNumber = false,
    FocusNode? focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        focusNode: focusNode,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500),
          prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.02),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.adminCardBorder, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitStep1,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF38BDF8),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'TIẾP TỤC: THIẾT LẬP LỊCH KHÁM',
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2, fontSize: 13),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  
  void _submitStep1() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final name = nameController.text.trim();
    final license = licenseController.text.trim();
    final expText = experienceController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Lỗi nhập liệu', 'Vui lòng nhập Email đăng nhập của bác sĩ.', backgroundColor: Colors.orange, colorText: Colors.white);
      emailFocusNode.requestFocus();
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Lỗi nhập liệu', 'Email đăng nhập không đúng định dạng.', backgroundColor: Colors.orange, colorText: Colors.white);
      emailFocusNode.requestFocus();
      return;
    }
    if (password.isEmpty) {
      Get.snackbar('Lỗi nhập liệu', 'Vui lòng nhập Mật khẩu tạm thời.', backgroundColor: Colors.orange, colorText: Colors.white);
      passwordFocusNode.requestFocus();
      return;
    }
    if (password.length < 6) {
      Get.snackbar('Lỗi nhập liệu', 'Mật khẩu phải từ 6 ký tự trở lên để bảo mật.', backgroundColor: Colors.orange, colorText: Colors.white);
      passwordFocusNode.requestFocus();
      return;
    }
    if (name.isEmpty) {
      Get.snackbar('Lỗi nhập liệu', 'Vui lòng nhập Họ và tên bác sĩ.', backgroundColor: Colors.orange, colorText: Colors.white);
      nameFocusNode.requestFocus();
      return;
    }
    if (license.isEmpty) {
      Get.snackbar('Lỗi nhập liệu', 'Vui lòng nhập Số chứng chỉ hành nghề.', backgroundColor: Colors.orange, colorText: Colors.white);
      licenseFocusNode.requestFocus();
      return;
    }
    if (expText.isEmpty) {
      Get.snackbar('Lỗi nhập liệu', 'Vui lòng nhập Số năm kinh nghiệm.', backgroundColor: Colors.orange, colorText: Colors.white);
      experienceFocusNode.requestFocus();
      return;
    }
    final expYears = int.tryParse(expText);
    if (expYears == null || expYears < 0) {
      Get.snackbar('Lỗi nhập liệu', 'Số năm kinh nghiệm phải là số nguyên dương hợp lệ.', backgroundColor: Colors.orange, colorText: Colors.white);
      experienceFocusNode.requestFocus();
      return;
    }
    if (selectedDept.value.isEmpty) {
      Get.snackbar('Lỗi nhập liệu', 'Vui lòng chọn Phòng ban trực thuộc.', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    if (selectedService.isEmpty) {
      Get.snackbar('Lỗi nhập liệu', 'Vui lòng chọn Loại dịch vụ khám & phí khám.', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    
    Get.toNamed(
      Routes.ADD_DOCTOR_SCHEDULE,
      arguments: {
        'email': email,
        'password': password,
        'fullName': name,
        'licenseNumber': license,
        'experienceYears': expYears,
        'departmentId': selectedDept.value,
        'consultationFee': (selectedService['base_price'] as num).toDouble(),
      },
    );
  }
}
