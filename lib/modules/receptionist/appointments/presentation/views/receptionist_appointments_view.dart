import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/receptionist_appointments_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class ReceptionistAppointmentsView extends GetView<ReceptionistAppointmentsController> {
  const ReceptionistAppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        title: const Text('Tiếp Nhận & Lịch Hẹn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF34D399)),
            onPressed: () => controller.loadAppointments(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -100,
            right: -100,
            width: 300,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1034D399),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            width: 300,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x100284C7),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildFilterTabs(),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF34D399)));
                    }

                    final list = controller.filteredAppointments;
                    if (list.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final apt = list[index];
                        return _buildAppointmentCard(apt);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final tabs = ['Tất cả', 'Chờ XN', 'Đã XN', 'Đã check-in', 'Hoàn thành'];
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.currentTab.value == index;
            return GestureDetector(
              onTap: () => controller.currentTab.value = index,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF34D399) : const Color(0xFF0F1626),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF34D399) : const Color(0xFF1E293B),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF0A0F1E) : const Color(0xFF94A3B8),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> apt) {
    final patient = apt['user_profiles'];
    final patientName = patient != null ? (patient['full_name'] ?? 'Bệnh nhân') : 'Bệnh nhân';
    final doctorData = apt['doctors'] as Map?;
    String doctorName = 'Bác sĩ';
    String departmentName = 'Phòng khám';
    if (doctorData != null) {
      final docProfile = doctorData['user_profiles'] as Map?;
      if (docProfile != null) {
        doctorName = docProfile['full_name'] ?? 'Bác sĩ';
      }
      final deptData = doctorData['departments'] as Map?;
      if (deptData != null) {
        departmentName = deptData['name'] ?? 'Phòng khám';
      }
    }

    final status = apt['status'] ?? 'pending';
    final timeStr = apt['start_time'].toString().substring(0, 5);
    final dateStr = apt['appointment_date'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date & Time block
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0F1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        timeStr,
                        style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateStr,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Patient and Doctor Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.medical_services_rounded, size: 12, color: Color(0xFF64748B)),
                          const SizedBox(width: 6),
                          Text(
                            'BS: $doctorName',
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.local_hospital_rounded, size: 12, color: Color(0xFF64748B)),
                          const SizedBox(width: 6),
                          Text(
                            departmentName,
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status Badge
                _buildStatusChip(status),
              ],
            ),
          ),
          
          // Action Buttons Divider & Layout
          if (status == 'pending' || status == 'confirmed') ...[
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: const Color(0xFFF87171)),
                    icon: const Icon(Icons.cancel_outlined, size: 16),
                    label: const Text('Hủy hẹn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    onPressed: () => controller.cancelAppointment(apt['id']),
                  ),
                  const Spacer(),
                  if (status == 'pending')
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38BDF8),
                        foregroundColor: const Color(0xFF0A0F1E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      icon: const Icon(Icons.check_rounded, size: 14),
                      label: const Text('Xác nhận', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      onPressed: () => controller.confirmAppointment(apt['id']),
                    ),
                  if (status == 'confirmed')
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF34D399),
                        foregroundColor: const Color(0xFF0A0F1E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      icon: const Icon(Icons.login_rounded, size: 14),
                      label: const Text('Check-in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      onPressed: () => controller.checkIn(apt['id']),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = const Color(0xFF64748B);
    String label = 'Đang chờ';

    if (status == 'pending') {
      color = const Color(0xFFFBBF24);
      label = 'Chờ xác nhận';
    } else if (status == 'confirmed') {
      color = const Color(0xFF38BDF8);
      label = 'Đã xác nhận';
    } else if (status == 'checked_in') {
      color = const Color(0xFF34D399);
      label = 'Đã check-in';
    } else if (status == 'completed') {
      color = const Color(0xFF64748B);
      label = 'Hoàn thành';
    } else if (status == 'cancelled') {
      color = const Color(0xFFF87171);
      label = 'Đã hủy';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF0F1626),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event_busy_rounded, color: Color(0xFF64748B), size: 36),
          ),
          const SizedBox(height: 14),
          const Text('Không tìm thấy lịch hẹn phù hợp', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        ],
      ),
    );
  }
}
