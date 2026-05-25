import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_management_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class StaffManagementView extends GetView<UserManagementController> {
  const StaffManagementView({super.key});

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
                color: const Color(0xFFC084FC).withValues(alpha: 0.05),
              ),
            ),
          ),
          
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value && controller.staff.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
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
                  return _buildStaffCard(person);
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
              color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {}, 
          backgroundColor: const Color(0xFF38BDF8),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> profile) {
    final role = profile['role']?.toString();
    final roleColor = _getRoleColor(role);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
      ),
      child: Row(
        children: [
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
              radius: 28,
              backgroundColor: const Color(0xFF0F1626),
              child: const Icon(Icons.person_rounded, color: Colors.white70, size: 28),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile['full_name'] ?? 'N/A', 
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 6),
                _buildRoleTag(role, roleColor),
                const SizedBox(height: 8),
                Text(
                  profile['email'] ?? 'Không có email', 
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildIconButton(Icons.more_vert_rounded, () {}),
        ],
      ),
    );
  }

  Widget _buildRoleTag(String? role, Color color) {
    String roleLabel = 'NHÂN VIÊN';
    switch (role) {
      case 'receptionist': roleLabel = 'Lễ tân'; break;
      case 'cashier': roleLabel = 'Thu ngân'; break;
      case 'lab_staff': roleLabel = 'Kỹ thuật viên Lab'; break;
      case 'pharmacist': roleLabel = 'Dược sĩ'; break;
      case 'admin': roleLabel = 'Quản trị viên'; break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color,
                  blurRadius: 4,
                  spreadRadius: 0.5,
                )
              ]
            ),
          ),
          const SizedBox(width: 6),
          Text(
            roleLabel.toUpperCase(), 
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 9, letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'receptionist': return const Color(0xFF34D399); 
      case 'cashier': return const Color(0xFFFBBF24);      
      case 'lab_staff': return const Color(0xFFC084FC);    
      case 'pharmacist': return const Color(0xFF22D3EE);   
      case 'admin': return const Color(0xFFF87171);        
      default: return const Color(0xFF818CF8);             
    }
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02), 
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF64748B), size: 20),
        onPressed: onTap,
      ),
    );
  }
}
