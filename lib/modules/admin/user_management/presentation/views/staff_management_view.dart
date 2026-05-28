import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_management_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class StaffManagementView extends GetView<UserManagementController> {
  const StaffManagementView({super.key});

  // Role meta: label, color, icon
  static const _roles = [
    {'value': 'receptionist', 'label': 'Lễ tân',           'color': 0xFF34D399, 'icon': Icons.support_agent_rounded},
    {'value': 'cashier',      'label': 'Thu ngân',          'color': 0xFFFBBF24, 'icon': Icons.payments_rounded},
    {'value': 'lab_staff',    'label': 'KTV Xét nghiệm',   'color': 0xFFC084FC, 'icon': Icons.biotech_rounded},
    {'value': 'pharmacist',   'label': 'Dược sĩ',           'color': 0xFF22D3EE, 'icon': Icons.medication_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminBg,
      appBar: AppBar(
        title: const Text(
          'Nhân Sự Hệ Thống',
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
      body: Stack(
        children: [
          Positioned(
            bottom: -100,
            right: -100,
            width: 300,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF34D399).withValues(alpha: 0.04),
              ),
            ),
          ),
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value && controller.staff.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF34D399)));
              }

              if (controller.staff.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.adminSurface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
                        ),
                        child: const Icon(Icons.badge_outlined, size: 54, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Chưa có nhân viên nào',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nhấn + để tạo tài khoản nhân viên',
                        style: TextStyle(color: Color(0xFF475569), fontSize: 12),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.staff.length,
                itemBuilder: (context, index) {
                  final person = controller.staff[index];
                  return _buildStaffCard(context, person);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF34D399).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showCreateStaffSheet(context),
          backgroundColor: const Color(0xFF34D399),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          icon: const Icon(Icons.person_add_rounded, color: Color(0xFF0F172A), size: 20),
          label: const Text(
            'Tạo tài khoản',
            style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w800, fontSize: 13),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Staff Card
  // ─────────────────────────────────────────────────────────
  Widget _buildStaffCard(BuildContext context, Map<String, dynamic> profile) {
    final role = profile['role']?.toString();
    final roleColor = Color(_getRoleColorHex(role));
    final roleLabel = _getRoleLabel(role);
    final roleIcon = _getRoleIcon(role);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
      ),
      child: Row(
        children: [
          // Avatar ring
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [roleColor, roleColor.withValues(alpha: 0.3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF0F1626),
              child: Icon(roleIcon, color: Colors.white70, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile['full_name'] ?? 'N/A',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.white),
                ),
                const SizedBox(height: 5),
                _buildRoleTag(roleLabel, roleColor),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 12, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        profile['email'] ?? 'N/A',
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Actions menu
          _buildActionsMenu(context, profile),
        ],
      ),
    );
  }

  Widget _buildRoleTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5, height: 5,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color, blurRadius: 4)],
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label.toUpperCase(),
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 9, letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsMenu(BuildContext context, Map<String, dynamic> profile) {
    final name = profile['full_name']?.toString() ?? 'nhân viên';
    final id = profile['id']?.toString() ?? '';

    return PopupMenuButton<String>(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: const Icon(Icons.more_vert_rounded, color: Color(0xFF64748B), size: 18),
      ),
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline_rounded, color: Color(0xFFFB7185), size: 18),
              SizedBox(width: 10),
              Text('Xóa tài khoản', style: TextStyle(color: Color(0xFFFB7185), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'delete') {
          _confirmDelete(context, id, name);
        }
      },
    );
  }

  void _confirmDelete(BuildContext context, String id, String name) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.adminSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFFB7185), width: 1.5),
        ),
        title: const Text('Xác nhận xóa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        content: Text(
          'Bạn chắc chắn muốn xóa tài khoản của "$name"?\nHành động này không thể hoàn tác.',
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB7185),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.back();
              controller.deleteStaff(id, name);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Create Staff Bottom Sheet
  // ─────────────────────────────────────────────────────────
  void _showCreateStaffSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final selectedRole = RxString('receptionist');
    final showPassword = false.obs;

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F1626),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Tạo tài khoản nhân viên',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5),
              ),
              const SizedBox(height: 4),
              const Text(
                'Nhân viên sẽ nhận được email để xác nhận tài khoản',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
              const SizedBox(height: 28),

              // Role selector
              _buildSheetLabel('CHỌN CHỨC VỤ'),
              const SizedBox(height: 10),
              Obx(() => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _roles.map((r) {
                  final isSelected = selectedRole.value == r['value'];
                  final color = Color(r['color'] as int);
                  return GestureDetector(
                    onTap: () => selectedRole.value = r['value'] as String,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withValues(alpha: 0.12) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? color : const Color(0xFF334155),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(r['icon'] as IconData, color: isSelected ? color : const Color(0xFF64748B), size: 16),
                          const SizedBox(width: 8),
                          Text(
                            r['label'] as String,
                            style: TextStyle(
                              color: isSelected ? color : const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )),
              const SizedBox(height: 24),

              // Full name
              _buildSheetLabel('HỌ VÀ TÊN'),
              const SizedBox(height: 8),
              _buildSheetTextField(
                controller: nameCtrl,
                hint: 'Nguyễn Văn A',
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 16),

              // Phone
              _buildSheetLabel('SỐ ĐIỆN THOẠI (tùy chọn)'),
              const SizedBox(height: 8),
              _buildSheetTextField(
                controller: phoneCtrl,
                hint: '0901 234 567',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Email
              _buildSheetLabel('EMAIL ĐĂNG NHẬP'),
              const SizedBox(height: 8),
              _buildSheetTextField(
                controller: emailCtrl,
                hint: 'nhanvien@hospital.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password
              _buildSheetLabel('MẬT KHẨU TẠM THỜI'),
              const SizedBox(height: 8),
              Obx(() => _buildSheetTextField(
                controller: passwordCtrl,
                hint: 'Tối thiểu 6 ký tự',
                icon: Icons.lock_outline_rounded,
                isPassword: !showPassword.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF64748B),
                    size: 18,
                  ),
                  onPressed: () => showPassword.toggle(),
                ),
              )),
              const SizedBox(height: 32),

              // Submit button
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF34D399)))
                  : SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _submitCreateStaff(
                          nameCtrl, emailCtrl, passwordCtrl, phoneCtrl, selectedRole,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34D399),
                          foregroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add_rounded, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'TẠO TÀI KHOẢN',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetLabel(String label) {
    return Text(
      label,
      style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2),
    );
  }

  Widget _buildSheetTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF1E293B),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF334155), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF34D399), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  void _submitCreateStaff(
    TextEditingController nameCtrl,
    TextEditingController emailCtrl,
    TextEditingController passwordCtrl,
    TextEditingController phoneCtrl,
    RxString selectedRole,
  ) {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;
    final phone = phoneCtrl.text.trim();

    if (name.isEmpty) {
      Get.snackbar('Thiếu thông tin', 'Vui lòng nhập họ và tên');
      return;
    }
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar('Email không hợp lệ', 'Vui lòng nhập email đúng định dạng');
      return;
    }
    if (password.length < 6) {
      Get.snackbar('Mật khẩu yếu', 'Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    controller.addStaff(
      email: email,
      password: password,
      fullName: name,
      role: selectedRole.value,
      phone: phone.isNotEmpty ? phone : null,
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Helpers
  // ─────────────────────────────────────────────────────────
  int _getRoleColorHex(String? role) {
    switch (role) {
      case 'receptionist': return 0xFF34D399;
      case 'cashier':      return 0xFFFBBF24;
      case 'lab_staff':    return 0xFFC084FC;
      case 'pharmacist':   return 0xFF22D3EE;
      case 'admin':        return 0xFFF87171;
      default:             return 0xFF818CF8;
    }
  }

  String _getRoleLabel(String? role) {
    switch (role) {
      case 'receptionist': return 'Lễ tân';
      case 'cashier':      return 'Thu ngân';
      case 'lab_staff':    return 'KTV Xét nghiệm';
      case 'pharmacist':   return 'Dược sĩ';
      case 'admin':        return 'Quản trị viên';
      default:             return 'Nhân viên';
    }
  }

  IconData _getRoleIcon(String? role) {
    switch (role) {
      case 'receptionist': return Icons.support_agent_rounded;
      case 'cashier':      return Icons.payments_rounded;
      case 'lab_staff':    return Icons.biotech_rounded;
      case 'pharmacist':   return Icons.medication_rounded;
      case 'admin':        return Icons.admin_panel_settings_rounded;
      default:             return Icons.person_rounded;
    }
  }
}
