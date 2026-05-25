import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booking_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class SelectTimeSlotView extends GetView<BookingController> {
  const SelectTimeSlotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA), 
      body: Stack(
        children: [
          
          Positioned(
            top: -60,
            right: -60,
            width: 260,
            height: 260,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x2238BDF8),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            width: 220,
            height: 220,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x14F43F5E),
              ),
            ),
          ),

          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF0284C7)));
              }
              if (controller.availableSlots.isEmpty) {
                return Column(
                  children: [
                    _buildCustomAppBar(),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0F172A).withOpacity(0.02),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.event_busy_rounded, size: 54, color: Color(0xFF94A3B8)),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Không có lịch trống trong hôm nay', 
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              
              final morningSlots = <Map<String, dynamic>>[];
              final afternoonSlots = <Map<String, dynamic>>[];
              final eveningSlots = <Map<String, dynamic>>[];

              for (final slot in controller.availableSlots) {
                final timeStr = slot['start_time'].toString();
                final hour = int.tryParse(timeStr.split(':')[0]) ?? 0;
                if (hour < 12) {
                  morningSlots.add(slot);
                } else if (hour < 17) {
                  afternoonSlots.add(slot);
                } else {
                  eveningSlots.add(slot);
                }
              }
              
              return Column(
                children: [
                  _buildCustomAppBar(),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      children: [
                        if (morningSlots.isNotEmpty) ...[
                          _buildSectionHeader('CA SÁNG', Icons.wb_sunny_rounded, const Color(0xFFD97706)),
                          const SizedBox(height: 12),
                          _buildSlotsGrid(morningSlots),
                          const SizedBox(height: 28),
                        ],
                        if (afternoonSlots.isNotEmpty) ...[
                          _buildSectionHeader('CA CHIỀU', Icons.wb_twilight_rounded, const Color(0xFF0284C7)),
                          const SizedBox(height: 12),
                          _buildSlotsGrid(afternoonSlots),
                          const SizedBox(height: 28),
                        ],
                        if (eveningSlots.isNotEmpty) ...[
                          _buildSectionHeader('CA TỐI', Icons.nights_stay_rounded, const Color(0xFF7C3AED)),
                          const SizedBox(height: 12),
                          _buildSlotsGrid(eveningSlots),
                          const SizedBox(height: 28),
                        ],
                      ],
                    ),
                  ),
                  _buildBottomAction(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withOpacity(0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF475569), size: 16),
              onPressed: () => Get.back(),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'KHUNG GIỜ KHÁM',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String label, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
      ],
    );
  }

  Widget _buildSlotsGrid(List<Map<String, dynamic>> slots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final timeStr = slot['start_time'].toString().substring(0, 5);
        
        return Obx(() {
          final isSelected = controller.selectedSlot.value == slot;
          return GestureDetector(
            onTap: () => controller.selectedSlot.value = slot,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: isSelected ? const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF0284C7)]) : null,
                color: isSelected ? null : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                border: isSelected 
                    ? null 
                    : Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: isSelected 
                        ? const Color(0xFF0284C7).withOpacity(0.2) 
                        : const Color(0xFF0F172A).withOpacity(0.02),
                    blurRadius: isSelected ? 10 : 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected) ...[
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    timeStr,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF0F172A),
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.05),
            blurRadius: 25,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => controller.selectedSlot.value != null ? Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'GIỜ KHÁM ĐÃ CHỌN:', 
                    style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.12)),
                    ),
                    child: Text(
                      controller.selectedSlot.value!['start_time'].toString().substring(0, 5),
                      style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0284C7), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ) : const SizedBox.shrink()),
            Obx(() {
              final hasSelected = controller.selectedSlot.value != null;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: hasSelected ? [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ] : [],
                ),
                child: ElevatedButton(
                  onPressed: hasSelected ? () => _showConfirmDialog() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'XÁC NHẬN ĐẶT LỊCH HẸN',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success.withOpacity(0.15), width: 1.5),
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 44),
              ),
              const SizedBox(height: 20),
              const Text(
                'XÁC NHẬN ĐẶT LỊCH', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Bạn có muốn đặt lịch khám với Bác sĩ ${controller.selectedDoctor.value!['user_profiles']['full_name']} vào lúc ${controller.selectedSlot.value!['start_time'].toString().substring(0, 5)}?',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.4, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'Hủy', 
                        style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.confirmBooking();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('Xác nhận'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
