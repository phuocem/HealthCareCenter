import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/receptionist_dashboard_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';

class ReceptionistDashboardView extends GetView<ReceptionistDashboardController> {
  const ReceptionistDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -80,
            right: -80,
            width: 280,
            height: 280,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1234D399),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -120,
            width: 300,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x120284C7),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(color: Colors.transparent),
          ),

          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF34D399)),
                );
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
                          _buildStatCards(),
                          const SizedBox(height: 28),
                          _buildSectionTitle('QUICK ACTIONS'),
                          const SizedBox(height: 16),
                          _buildQuickActions(),
                          const SizedBox(height: 28),
                          _buildSectionTitle('LỊCH HẸN HÔM NAY'),
                          const SizedBox(height: 16),
                          _buildTodayAppointments(),
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
        'LỄ TÂN HỆ THỐNG',
        style: TextStyle(
          color: Color(0xFF34D399),
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
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF34D399), size: 18),
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
            onPressed: () => _showLogoutDialog(),
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFFB7185), size: 18),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F1626),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFFB7185), width: 1.5),
        ),
        title: const Text('Đăng xuất', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        content: const Text('Bạn có chắc muốn đăng xuất?', style: TextStyle(color: Color(0xFF94A3B8))),
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
  }

  Widget _buildHeader() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xin chào, ${controller.staffName.value}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Quản lý tiếp nhận & lịch hẹn bệnh nhân',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    ));
  }

  Widget _buildStatCards() {
    return Obx(() => Row(
      children: [
        _buildStatCard('Lịch hẹn hôm nay', controller.todayAppointments.value.toString(), Icons.calendar_today_rounded, const Color(0xFF34D399)),
        const SizedBox(width: 12),
        _buildStatCard('Chờ tiếp nhận', controller.waitingCount.value.toString(), Icons.hourglass_top_rounded, const Color(0xFFFBBF24)),
        const SizedBox(width: 12),
        _buildStatCard('Đã hoàn thành', controller.completedCount.value.toString(), Icons.check_circle_rounded, const Color(0xFF38BDF8)),
      ],
    ));
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1626),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 12),
            Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3),
                maxLines: 2),
          ],
        ),
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
            gradient: AppColors.neonEmeraldGradient,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            )),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'label': 'Đặt lịch hẹn', 'icon': Icons.add_circle_outline_rounded, 'color': const Color(0xFF34D399)},
      {'label': 'Tiếp nhận BN', 'icon': Icons.person_add_rounded, 'color': const Color(0xFF38BDF8)},
      {'label': 'Tìm bệnh nhân', 'icon': Icons.search_rounded, 'color': const Color(0xFFC084FC)},
      {'label': 'Xem lịch bác sĩ', 'icon': Icons.calendar_month_rounded, 'color': const Color(0xFFFBBF24)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        final color = action['color'] as Color;
        return GestureDetector(
          onTap: () {
            if (index == 0 || index == 1) {
              Get.toNamed(Routes.RECEPTION_APPOINTMENTS);
            } else if (index == 2) {
              _showPatientSearchDialog(context);
            } else {
              _showDoctorScheduleDialog(context);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1626),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
            ),
            child: Row(
              children: [
                Icon(action['icon'] as IconData, color: color, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    action['label'] as String,
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 12),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPatientSearchDialog(BuildContext context) {
    final searchController = TextEditingController();
    final searchResults = <Map<String, String>>[
      {'name': 'Nguyễn Văn A', 'phone': '0901234567', 'status': 'Đang chờ khám'},
      {'name': 'Trần Thị B', 'phone': '0918765432', 'status': 'Hoàn tất khám'},
      {'name': 'Lê Hoàng C', 'phone': '0987654321', 'status': 'Đang xét nghiệm'},
    ].obs;

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F1626),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFC084FC), width: 1.5),
        ),
        title: const Text('Tìm kiếm Bệnh nhân', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nhập tên hoặc số điện thoại...',
                hintStyle: const TextStyle(color: Colors.white30),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFC084FC)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.03),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.maxFinite,
              height: 150,
              child: Obx(() => ListView.builder(
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (_, i) {
                  final bn = searchResults[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(bn['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('SĐT: ${bn['phone']!}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(bn['status']!, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ĐÓNG', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDoctorScheduleDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F1626),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFFBBF24), width: 1.5),
        ),
        title: const Text('Lịch làm việc Bác sĩ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDoctorScheduleRow('BS. Nguyễn Minh Tuấn', 'Nội tổng quát', 'Thứ 2 - Thứ 6', 'Sáng (08:00 - 12:00)'),
              const Divider(color: Colors.white10),
              _buildDoctorScheduleRow('BS. Trần Thị Mai', 'Nhi khoa', 'Thứ 3 - Thứ 7', 'Chiều (13:30 - 17:30)'),
              const Divider(color: Colors.white10),
              _buildDoctorScheduleRow('BS. Lê Hoàng Long', 'Tim mạch', 'Thứ 2, 4, 6', 'Sáng (08:00 - 12:00)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ĐÓNG', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorScheduleRow(String name, String specialization, String days, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          Text(specialization, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(days, style: const TextStyle(color: Colors.white54, fontSize: 10)),
              Text(time, style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayAppointments() {
    return Obx(() {
      if (controller.appointments.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1626),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
          ),
          alignment: Alignment.center,
          child: const Text(
            'KHÔNG CÓ LỊCH HẸN HÔM NAY',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
          ),
        );
      }
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F1626),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: controller.appointments.length > 5 ? 5 : controller.appointments.length,
          separatorBuilder: (_, i) => const Divider(color: Color(0xFF1E293B), height: 16),
          itemBuilder: (context, index) {
            final apt = controller.appointments[index];
            return _buildAppointmentItem(apt);
          },
        ),
      );
    });
  }

  Widget _buildAppointmentItem(Map<String, dynamic> apt) {
    final statusColor = apt['status'] == 'confirmed'
        ? const Color(0xFF34D399)
        : apt['status'] == 'pending'
            ? const Color(0xFFFBBF24)
            : const Color(0xFF64748B);

    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                apt['patient_name']?.toString() ?? 'Bệnh nhân',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                apt['doctor_name']?.toString() ?? 'Bác sĩ',
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              apt['time']?.toString() ?? '',
              style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w700, fontSize: 12),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                apt['status']?.toString() ?? '',
                style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
