import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/dashboard_controller.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/routes/app_routes.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.adminBg,
      body: Stack(
        children: [
          
          Positioned(
            top: -100,
            right: -100,
            width: 320,
            height: 320,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x14C084FC),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            width: 350,
            height: 350,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1F0284C7),
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
          
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value && controller.stats.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
              }
              
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          
                          
                          _buildTelemetryChartDisplay(size, currencyFormat), 
                          const SizedBox(height: 32),
                          
                          _buildSectionTitle('COMMAND ACTIONS MATRIX'),
                          const SizedBox(height: 16),
                          
                          _buildOrbitalActionGrid(), 
                          const SizedBox(height: 32),
                          
                          _buildSectionTitle('SYSTEM TERMINAL LOGGER'),
                          const SizedBox(height: 16),
                          
                          _buildConsoleTerminalLog(), 
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'CORE SYSTEM MONITOR', 
        style: TextStyle(
          color: Color(0xFF38BDF8), 
          fontSize: 11, 
          fontWeight: FontWeight.w900, 
          letterSpacing: 2,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: IconButton(
            onPressed: controller.loadData, 
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF38BDF8), size: 18),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFB7185).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFB7185).withValues(alpha: 0.15)),
          ),
          child: IconButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  backgroundColor: AppColors.adminSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: Color(0xFFFB7185), width: 1.5),
                  ),
                  title: const Text(
                    'Đăng xuất hệ thống',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                  content: const Text(
                    'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản Quản trị viên?',
                    style: TextStyle(color: Color(0xFF94A3B8)),
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
                        controller.logout();
                      },
                      child: const Text('Đăng xuất', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            }, 
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFFB7185), size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trung tâm chỉ huy', 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 26, 
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Đồng bộ hóa hoạt động toàn hệ thống y tế', 
          style: TextStyle(
            color: Color(0xFF64748B), 
            fontSize: 13, 
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  
  Widget _buildTelemetryChartDisplay(Size size, NumberFormat format) {
    final revenue = controller.stats['total_revenue'] ?? 0.0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TỔNG QUAN DOANH THU & KHOA',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          Text(
            format.format(revenue),
            style: const TextStyle(color: Color(0xFF34D399), fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const SizedBox(height: 20),
          
          
          Row(
            children: [
              _buildTelemetryIndicator('BỆNH NHÂN', controller.stats['total_patients']?.toString() ?? '0', const Color(0xFF38BDF8), 0.7),
              const SizedBox(width: 14),
              _buildTelemetryIndicator('BÁC SĨ', controller.stats['total_doctors']?.toString() ?? '0', const Color(0xFFC084FC), 0.5),
              const SizedBox(width: 14),
              _buildTelemetryIndicator('LỊCH HẸN', controller.stats['total_appointments']?.toString() ?? '0', const Color(0xFFFBBF24), 0.8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryIndicator(String label, String value, Color color, double percent) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          
          
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: percent,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(color: color, blurRadius: 4, spreadRadius: 0.5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            gradient: AppColors.neonBlueGradient,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title, 
          style: const TextStyle(
            color: Color(0xFF64748B), 
            fontSize: 10, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  
  Widget _buildOrbitalActionGrid() {
    return Column(
      children: [
        Row(
          children: [
            _buildOrbitalItem('Quản Lý Bác Sĩ', Icons.medical_services_rounded, const Color(0xFF38BDF8), () => Get.toNamed(Routes.DOCTOR_MANAGEMENT)),
            const SizedBox(width: 12),
            _buildOrbitalItem('Hồ Sơ Nhân Viên', Icons.badge_rounded, const Color(0xFFC084FC), () => Get.toNamed(Routes.STAFF_MANAGEMENT)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildOrbitalItem('Quản Lý Khoa', Icons.domain_rounded, const Color(0xFF34D399), () => Get.toNamed(Routes.DEPARTMENTS)),
            const SizedBox(width: 12),
            _buildOrbitalItem('Bảng Giá Dịch Vụ', Icons.payments_rounded, const Color(0xFFFBBF24), () => Get.toNamed(Routes.SERVICES)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildOrbitalItem('Xét Nghiệm Lab', Icons.biotech_rounded, const Color(0xFFF472B6), () => Get.toNamed(Routes.LAB_TESTS)),
            const SizedBox(width: 12),
            _buildOrbitalItem('Kho Dược Phẩm', Icons.inventory_2_rounded, const Color(0xFF22D3EE), () => Get.toNamed(Routes.INVENTORY)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildOrbitalItem('Nhà Cung Cấp', Icons.local_shipping_rounded, const Color(0xFFFB7185), () => Get.toNamed(Routes.SUPPLIERS)),
            const SizedBox(width: 12),
            _buildOrbitalItem('Quản Lý Ca Trực', Icons.calendar_month_rounded, const Color(0xFF818CF8), () => Get.toNamed(Routes.SCHEDULE_MANAGEMENT)),
          ],
        ),
      ],
    );
  }

  Widget _buildOrbitalItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.adminSurface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topRight: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
            border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08), 
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title, 
                  style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w800, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildConsoleTerminalLog() {
    if (controller.activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.adminSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
        ),
        alignment: Alignment.center,
        child: const Text(
          'NO SYSTEM ACTIVITY DETECTED', 
          style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: controller.activities.length,
        separatorBuilder: (context, index) => const Divider(color: Color(0xFF1E293B), height: 20, thickness: 1.5),
        itemBuilder: (context, index) {
          final activity = controller.activities[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SYSTEM >', 
                style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  activity['title']?.toString().toUpperCase() ?? '', 
                  style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace', height: 1.3),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatTime(activity['time']), 
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes}M';
      if (diff.inHours < 24) return '${diff.inHours}H';
      return DateFormat('dd/MM').format(date);
    } catch (e) { return ''; }
  }
}
