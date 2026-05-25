import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_management_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class ScheduleManagementView extends GetView<UserManagementController> {
  const ScheduleManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = Get.arguments as Map<String, dynamic>;
    final profile = doctor['user_profiles'];
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadSchedules(doctor['id']);
    });

    return Scaffold(
      backgroundColor: AppColors.adminBg,
      appBar: AppBar(
        title: Text(
          'Lịch: ${profile['full_name']}', 
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white, letterSpacing: -0.5),
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
            top: -100,
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
            child: Column(
              children: [
                _buildDaySelector(),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
                    }
                    
                    final daySchedules = controller.schedules.where((s) => s['day_of_week'] == controller.selectedDay.value).toList();
                    
                    if (daySchedules.isEmpty) {
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
                              child: const Icon(Icons.event_busy_rounded, size: 54, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Không có lịch khám cho ngày này', 
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: daySchedules.length,
                      itemBuilder: (context, index) {
                        final slot = daySchedules[index];
                        return _buildSlotCard(slot, doctor['id']);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
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
        child: FloatingActionButton.extended(
          onPressed: () => _showAddSlotDialog(doctor['id']),
          backgroundColor: const Color(0xFF38BDF8),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          label: const Text('THÊM KHUNG GIỜ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          icon: const Icon(Icons.add, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    final days = [
      {'label': 'CN', 'value': 0},
      {'label': 'Thứ 2', 'value': 1},
      {'label': 'Thứ 3', 'value': 2},
      {'label': 'Thứ 4', 'value': 3},
      {'label': 'Thứ 5', 'value': 4},
      {'label': 'Thứ 6', 'value': 5},
      {'label': 'Thứ 7', 'value': 6},
    ];
    return Container(
      height: 105,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          return Obx(() {
            final isSelected = controller.selectedDay.value == day['value'];
            return GestureDetector(
              onTap: () => controller.selectedDay.value = day['value'] as int,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 72,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.neonBlueGradient : null,
                  color: isSelected ? null : AppColors.adminSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: isSelected 
                      ? null 
                      : Border.all(color: AppColors.adminCardBorder, width: 1.5),
                  boxShadow: isSelected 
                      ? [BoxShadow(color: const Color(0xFF38BDF8).withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))]
                      : [],
                ),
                child: Center(
                  child: Text(
                    day['label'] as String, 
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildSlotCard(Map<String, dynamic> slot, String doctorId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.access_time_filled_rounded, color: Color(0xFF38BDF8), size: 22),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${slot['start_time'].substring(0, 5)} - ${slot['end_time'].substring(0, 5)}', 
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tối đa: ${slot['max_patients']} bệnh nhân', 
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          _buildActionButton(
            Icons.delete_outline_rounded, 
            AppColors.error.withValues(alpha: 0.8), 
            () => controller.deleteSchedule(slot['id'], doctorId),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02), 
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onTap,
      ),
    );
  }

  void _showAddSlotDialog(String doctorId) {
    String startTime = '08:00';
    String endTime = '09:00';

    Get.bottomSheet(
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            decoration: BoxDecoration(
              color: AppColors.adminBg.withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Thêm Khung Giờ Mới', 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: _buildTimePicker('BẮT ĐẦU', startTime, (val) => startTime = val)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTimePicker('KẾT THÚC', endTime, (val) => endTime = val)),
                  ],
                ),
                const SizedBox(height: 36),
                Container(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => controller.saveSchedule(
                      doctorId: doctorId,
                      dayOfWeek: controller.selectedDay.value,
                      startTime: startTime,
                      endTime: endTime,
                    ),
                    child: const Text('XÁC NHẬN LƯU', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, String time, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: Get.context!,
              initialTime: TimeOfDay(
                hour: int.parse(time.split(':')[0]),
                minute: int.parse(time.split(':')[1]),
              ),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Color(0xFF38BDF8),
                      onPrimary: Colors.black,
                      surface: Color(0xFF0F1626),
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              onChanged('${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00');
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 18, color: Color(0xFF38BDF8)),
                const SizedBox(width: 10),
                Text(
                  time, 
                  style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
