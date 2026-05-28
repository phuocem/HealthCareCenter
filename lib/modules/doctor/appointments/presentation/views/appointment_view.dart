import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/appointment_controller.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/routes/app_routes.dart';

class AppointmentView extends GetView<AppointmentController> {
  const AppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF070B19), 
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.terminal_rounded, color: Color(0xFF0D9488), size: 20),
            SizedBox(width: 8),
            Text(
              'TRẠM ĐIỀU HÀNH CA KHÁM', 
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.w900, 
                fontSize: 16, 
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          
          Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: IconButton(
              onPressed: controller.loadDoctorSchedule,
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0D9488), size: 18),
            ),
          ),
          
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
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
                      'Đăng xuất phiên trực',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                    content: const Text(
                      'Bác sĩ có chắc chắn muốn đăng xuất khỏi Trạm Điều Hành Ca Khám?',
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
      ),
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
                color: Color(0x100D9488),
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
                color: Color(0x0C38BDF8),
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: Container(color: Colors.transparent),
          ),

          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488)));
              }

              final total = controller.appointments.length;
              final waiting = controller.appointments.where((a) => a['status'] == 'pending' || a['status'] == 'confirmed').length;
              final completed = controller.appointments.where((a) => a['status'] == 'completed').length;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDoctorBanner(), 
                          const SizedBox(height: 24),
                          
                          _buildTelemetryStats(total, waiting, completed), 
                          const SizedBox(height: 24),

                          _buildQuickShortcutPanel(), 
                          const SizedBox(height: 28),

                          _buildSectionTitle('LỊCH TRÌNH CA LÂM SÀNG HÔM NAY'),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  if (controller.appointments.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildEmptyStateCard(),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final app = controller.appointments[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            child: _buildStaggeredPatientCard(app),
                          );
                        },
                        childCount: controller.appointments.length,
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorBanner() {
    return GestureDetector(
      onTap: () => _showDoctorProfileDialog(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.adminSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D9488).withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.15)),
              ),
              child: const Icon(Icons.medical_services_rounded, color: Color(0xFF0D9488), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Bác sĩ. ${controller.doctorName.value}',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF34D399),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Color(0xFF34D399), blurRadius: 6, spreadRadius: 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.doctorSpecialty.value.toUpperCase(),
                    style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.doctorEmail.value,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Xem hồ sơ ➜',
                        style: TextStyle(color: Color(0xFF0D9488), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryStats(int total, int waiting, int completed) {
    return Row(
      children: [
        _buildStatCard('TỔNG CA', total.toString(), const Color(0xFF38BDF8), Icons.assignment_ind_rounded),
        const SizedBox(width: 12),
        _buildStatCard('ĐANG CHỜ', waiting.toString(), const Color(0xFFFBBF24), Icons.pending_actions_rounded),
        const SizedBox(width: 12),
        _buildStatCard('ĐÃ XONG', completed.toString(), const Color(0xFF34D399), Icons.check_circle_outline_rounded),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.adminSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickShortcutPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.adminSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.adminCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TIỆN ÍCH LÂM SÀNG',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildShortcutChip('Kê đơn thuốc', Icons.medication_rounded, const Color(0xFF38BDF8)),
              const SizedBox(width: 8),
              _buildShortcutChip('Bệnh nhân', Icons.people_rounded, const Color(0xFFFBBF24)),
              const SizedBox(width: 8),
              _buildShortcutChip('Lịch biểu', Icons.calendar_month_rounded, const Color(0xFF34D399)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutChip(String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
              ),
            ),
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
            color: const Color(0xFF0D9488),
            borderRadius: BorderRadius.circular(2),
            boxShadow: const [
              BoxShadow(color: Color(0xFF0D9488), blurRadius: 4),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF64748B), 
            fontSize: 10, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0D9488).withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.1), width: 1.5),
            ),
            child: const Icon(
              Icons.event_busy_rounded, 
              color: Color(0xFF0D9488), 
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Lịch hẹn hôm nay trống',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3),
          ),
          const SizedBox(height: 10),
          const Text(
            'Hiện tại không có lịch hẹn khám lâm sàng nào cho bạn hôm nay. Bác sĩ hãy tận dụng thời gian nghỉ ngơi hoặc kiểm tra lại cấu hình phân ca trực!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.5, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 28),
          
          
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: controller.loadDoctorSchedule,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
              label: const Text(
                'LÀM MỚI HỆ THỐNG', 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaggeredPatientCard(Map<String, dynamic> app) {
    final patient = app['user_profiles'];
    final patientName = patient != null ? (patient['full_name'] ?? 'Bệnh nhân') : 'Bệnh nhân';
    final status = app['status'] ?? 'pending';
    final timeStr = app['start_time'].toString().substring(0, 5);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(18),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timeStr,
                  style: const TextStyle(color: Color(0xFF0D9488), fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                ),
                const Text(
                  'GIỜ HẸN',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
              ],
            ),
            title: Text(
              patientName, 
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 12, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      app['appointment_date'], 
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ],
            ),
            trailing: _buildStatusChip(status),
          ),
          const Divider(height: 1, color: Color(0xFF1E293B), thickness: 1, indent: 18, endIndent: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                _buildActionBtn(Icons.phone_rounded, 'GỌI ĐIỆN', const Color(0xFF38BDF8), () {}),
                _buildActionBtn(Icons.edit_note_rounded, 'GHI CHÚ', const Color(0xFFD97706), () {}),
                if (status == 'checked_in')
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34D399),
                          foregroundColor: const Color(0xFF070B19),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 16),
                        label: const Text('BẮT ĐẦU KHÁM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        onPressed: () => Get.toNamed(Routes.DOCTOR_EXAMINE, arguments: {'appointmentId': app['id']}),
                      ),
                    ),
                  )
                else
                  _buildActionBtn(Icons.check_circle_rounded, 'HOÀN TẤT', const Color(0xFF0D9488), () {
                    controller.updateAppointmentStatus(app['id'], 'completed');
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = const Color(0xFF38BDF8);
    String label = 'Đang chờ';
    
    if (status == 'pending') {
      color = const Color(0xFFFBBF24);
      label = 'Chờ xác nhận';
    } else if (status == 'confirmed') {
      color = const Color(0xFF38BDF8);
      label = 'Đã xác nhận';
    } else if (status == 'checked_in') {
      color = const Color(0xFF34D399);
      label = 'Đã Check-in';
    } else if (status == 'completed') {
      color = const Color(0xFF10B981);
      label = 'Đã xong';
    } else if (status == 'cancelled') {
      color = const Color(0xFFEF4444);
      label = 'Đã hủy';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                BoxShadow(color: color, blurRadius: 4, spreadRadius: 0.5)
              ]
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(), 
            style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 15, color: color),
        label: Text(
          label, 
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _showDoctorProfileDialog() {
    final name = controller.doctorName.value;
    final spec = controller.doctorSpecialty.value;
    final email = controller.doctorEmail.value.isEmpty ? 'dr.hoangnam@healthx.com' : controller.doctorEmail.value;

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F1626),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
        ),
        content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.badge_rounded, color: Color(0xFF0D9488), size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'HỒ SƠ BÁC SĨ CHI TIẾT',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5),
                  ),
                ],
              ),
              const Divider(color: Color(0xFF1E293B), height: 28, thickness: 1.5),
              
              _buildDialogSectionHeader('THÔNG TIN HÀNH NGHỀ & CHUYÊN MÔN'),
              const SizedBox(height: 8),
              _buildDialogRow(Icons.account_box_rounded, 'HỌ VÀ TÊN', 'Bác sĩ. $name', const Color(0xFF38BDF8)),
              _buildDialogRow(Icons.school_rounded, 'HỌC VỊ / HỌC HÀM', controller.doctorQualification.value, const Color(0xFF3B82F6)),
              _buildDialogRow(Icons.credit_card_rounded, 'GIẤY PHÉP HÀNH NGHỀ', controller.doctorLicense.value, const Color(0xFF8B5CF6)),
              _buildDialogRow(Icons.medical_services_rounded, 'CHUYÊN KHOA', spec, const Color(0xFFEC4899)),
              _buildDialogRow(Icons.location_city_rounded, 'NƠI ĐÀO TẠO CHUYÊN SÂU', controller.doctorSchool.value, const Color(0xFF3B82F6)),
              _buildDialogRow(Icons.workspace_premium_rounded, 'THÂM NIÊN LÂM SÀNG', '${controller.doctorExperience.value} năm kinh nghiệm', const Color(0xFF10B981)),
              _buildDialogRow(Icons.auto_awesome_rounded, 'CHUYÊN KHOA SÂU', controller.doctorSubSpecialization.value, const Color(0xFFFBBF24)),
              _buildDialogRow(Icons.center_focus_strong_rounded, 'CHUYÊN MÔN LÂM SÀNG', controller.doctorClinicalFocus.value, const Color(0xFF38BDF8)),
              _buildDialogRow(Icons.card_membership_rounded, 'CHỨNG CHỈ CME ĐÃ CẤP', controller.doctorCertificates.value, const Color(0xFF10B981)),
              
              const SizedBox(height: 18),
              _buildDialogSectionHeader('LIÊN HỆ KHẨN CẤP & CÁ NHÂN'),
              const SizedBox(height: 8),
              _buildDialogRow(Icons.phone_iphone_rounded, 'SỐ ĐIỆN THOẠI DI ĐỘNG', controller.doctorPhone.value, const Color(0xFF10B981)),
              _buildDialogRow(Icons.email_rounded, 'THƯ ĐIỆN TỬ', email, const Color(0xFF38BDF8)),
              _buildDialogRow(Icons.contact_phone_rounded, 'LIÊN HỆ NGƯỜI THÂN BÁC SĨ', '${controller.doctorEmergencyName.value} - ${controller.doctorEmergencyPhone.value}', const Color(0xFFEF4444)),
              
              const SizedBox(height: 18),
              _buildDialogSectionHeader('LỊCH TRÌNH & ĐÁNH GIÁ'),
              const SizedBox(height: 8),
              _buildDialogRow(Icons.calendar_month_rounded, 'CA TRỰC ĐĂNG KÝ', 'Sáng (07:30 - 11:30) | Chiều (13:30 - 17:30)', const Color(0xFF38BDF8)),
              _buildDialogRow(Icons.monetization_on_rounded, 'MỨC PHÍ TƯ VẤN', '150.000 đ', const Color(0xFF10B981)),
              _buildDialogRow(Icons.star_rounded, 'ĐÁNH GIÁ TRUNG BÌNH', '4.9 ★ (128 phản hồi bệnh nhân)', const Color(0xFFFBBF24)),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Get.back(),
            child: const Text('ĐÓNG HỒ SƠ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF0D9488),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0D9488),
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDialogRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 8, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
