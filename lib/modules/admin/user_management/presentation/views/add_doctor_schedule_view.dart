import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_management_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class AddDoctorScheduleView extends GetView<UserManagementController> {
  AddDoctorScheduleView({super.key});

  final Map<String, dynamic> doctorData = Get.arguments ?? {};

  final startTimeController = TextEditingController(text: '08:00');
  final endTimeController = TextEditingController(text: '17:00');
  final lunchStartController = TextEditingController(text: '12:00');
  final lunchEndController = TextEditingController(text: '13:00');

  final RxList<int> selectedDays = <int>[1, 2, 3, 4, 5].obs; 
  final RxBool hasLunchBreak = true.obs;
  final RxInt selectedDuration = 60.obs; 
  final RxList<Map<String, String>> generatedSlots = <Map<String, String>>[].obs;

  @override
  Widget build(BuildContext context) {
    
    if (generatedSlots.isEmpty) {
      _autoGenerateSlots(showSuccessMessage: false);
    }

    return Scaffold(
      backgroundColor: AppColors.adminBg,
      appBar: AppBar(
        title: const Text(
          'Thiết Lập Lịch Khám', 
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
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepIndicator(),
              const SizedBox(height: 24),

              _buildSectionTitle('1. CHỌN NGÀY LÀM VIỆC TRONG TUẦN'),
              _buildCard([
                const Text(
                  'Chọn những ngày bác sĩ sẽ nhận khám bệnh nhân:', 
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 16),
                _buildWorkingDaysPicker(),
              ]),
              const SizedBox(height: 24),

              _buildSectionTitle('2. BỘ TỰ ĐỘNG CHIA PHÂN LỊCH'),
              _buildCard([
                const Text(
                  'Cấu hình khung giờ làm việc chung & nghỉ trưa:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(startTimeController, 'Giờ bắt đầu', Icons.play_arrow_rounded),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(endTimeController, 'Giờ kết thúc', Icons.stop_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: hasLunchBreak.value,
                        activeColor: const Color(0xFF38BDF8),
                        side: const BorderSide(color: Color(0xFF475569), width: 1.5),
                        onChanged: (val) {
                          hasLunchBreak.value = val ?? false;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Có thời gian nghỉ trưa',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
                if (hasLunchBreak.value) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(lunchStartController, 'Nghỉ trưa từ', Icons.lunch_dining_outlined),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(lunchEndController, 'Quay lại lúc', Icons.wb_sunny_outlined),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),

                const Text(
                  'Thời lượng mỗi ca khám (phút):',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 12),
                _buildDurationSelector(),
                const SizedBox(height: 24),

                _buildGenerateButton(),
              ]),
              const SizedBox(height: 24),

              _buildSectionTitle('3. DANH SÁCH KHUNG GIỜ SẼ TẠO'),
              _buildCard([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng số ca khám: ${generatedSlots.length}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF38BDF8)),
                    ),
                    GestureDetector(
                      onTap: () => _addCustomSlot(context),
                      child: const Row(
                        children: [
                          Icon(Icons.add_circle_outline_rounded, color: Color(0xFF38BDF8), size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Thêm ca thủ công',
                            style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSlotsGrid(),
              ]),
              const SizedBox(height: 36),

              _buildSubmitButton(),
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
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BƯỚC 2/2: LỊCH TRÌNH KHÁM BỆNH',
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
                SizedBox(height: 2),
                Text(
                  'Phân bổ ngày làm việc & chia nhỏ ca khám',
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
            decoration: const BoxDecoration(
              gradient: AppColors.neonBlueGradient,
              borderRadius: BorderRadius.all(Radius.circular(2)),
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
      width: double.infinity,
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

  Widget _buildWorkingDaysPicker() {
    final days = [
      {'name': 'Thứ 2', 'value': 1},
      {'name': 'Thứ 3', 'value': 2},
      {'name': 'Thứ 4', 'value': 3},
      {'name': 'Thứ 5', 'value': 4},
      {'name': 'Thứ 6', 'value': 5},
      {'name': 'Thứ 7', 'value': 6},
      {'name': 'C.Nhật', 'value': 0},
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: days.map((day) {
        final val = day['value'] as int;
        final isSelected = selectedDays.contains(val);

        return GestureDetector(
          onTap: () {
            if (isSelected) {
              selectedDays.remove(val);
            } else {
              selectedDays.add(val);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected ? const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF0284C7)]) : null,
              color: isSelected ? null : Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? Colors.transparent : AppColors.adminCardBorder, 
                width: 1.5,
              ),
              boxShadow: isSelected ? [
                BoxShadow(color: const Color(0xFF38BDF8).withValues(alpha: 0.2), blurRadius: 8),
              ] : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check_circle, color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                ],
                Text(
                  day['name'] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 18),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _buildDurationSelector() {
    final durations = [30, 45, 60, 90];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: durations.map((dur) {
        final isSelected = selectedDuration.value == dur;
        return Expanded(
          child: GestureDetector(
            onTap: () => selectedDuration.value = dur,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected ? const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF0284C7)]) : null,
                color: isSelected ? null : Colors.white.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.adminCardBorder,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '$dur phút',
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenerateButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
      ),
      child: OutlinedButton.icon(
        onPressed: () => _autoGenerateSlots(showSuccessMessage: true),
        icon: const Icon(Icons.flash_on_rounded, color: Color(0xFF38BDF8), size: 18),
        label: const Text(
          'TỰ ĐỘNG CHIA KHUNG GIỜ',
          style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSlotsGrid() {
    if (generatedSlots.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.01),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.adminCardBorder, style: BorderStyle.solid),
        ),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(Icons.hourglass_empty_rounded, color: Color(0xFF475569), size: 36),
            SizedBox(height: 8),
            Text(
              'Chưa có khung giờ nào được chọn.',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: generatedSlots.length,
      itemBuilder: (context, index) {
        final slot = generatedSlots[index];
        final timeStr = '${slot['start']} - ${slot['end']}';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.adminCardBorder, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.access_time_rounded, color: Color(0xFF38BDF8), size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  timeStr,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
                ),
              ),
              GestureDetector(
                onTap: () => generatedSlots.removeAt(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded, color: Color(0xFFEF4444), size: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    final isLoading = controller.isLoading.value;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitAllData,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: isLoading 
          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_rounded, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'HOÀN TẤT & TẠO BÁC SĨ',
                    style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.3, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  void _autoGenerateSlots({required bool showSuccessMessage}) {
    final start = startTimeController.text.trim();
    final end = endTimeController.text.trim();
    final hasLunch = hasLunchBreak.value;
    final lunchStart = lunchStartController.text.trim();
    final lunchEnd = lunchEndController.text.trim();
    final duration = selectedDuration.value;

    final timeRegex = RegExp(r'^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(start) || !timeRegex.hasMatch(end)) {
      Get.snackbar('Lỗi nhập liệu', 'Vui lòng điền đúng định dạng HH:mm cho Giờ làm việc', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (hasLunch && (!timeRegex.hasMatch(lunchStart) || !timeRegex.hasMatch(lunchEnd))) {
      Get.snackbar('Lỗi nhập liệu', 'Vui lòng điền đúng định dạng HH:mm cho Giờ nghỉ trưa', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    int toMinutes(String time) {
      final parts = time.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }

    String fromMinutes(int totalMinutes) {
      final h = totalMinutes ~/ 60;
      final m = totalMinutes % 60;
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    }

    final startMins = toMinutes(start);
    final endMins = toMinutes(end);
    final lunchStartMins = hasLunch ? toMinutes(lunchStart) : 0;
    final lunchEndMins = hasLunch ? toMinutes(lunchEnd) : 0;

    if (startMins >= endMins) {
      Get.snackbar('Lỗi nhập liệu', 'Giờ bắt đầu làm việc phải trước Giờ kết thúc', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (hasLunch && lunchStartMins >= lunchEndMins) {
      Get.snackbar('Lỗi nhập liệu', 'Giờ bắt đầu nghỉ trưa phải trước Giờ kết thúc nghỉ trưa', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    final List<Map<String, String>> slots = [];
    int current = startMins;

    while (current + duration <= endMins) {
      final slotStart = current;
      final slotEnd = current + duration;

      bool overlapsLunch = false;
      if (hasLunch) {
        if (slotStart < lunchEndMins && slotEnd > lunchStartMins) {
          overlapsLunch = true;
        }
      }

      if (!overlapsLunch) {
        slots.add({
          'start': fromMinutes(slotStart),
          'end': fromMinutes(slotEnd),
        });
        current = slotEnd;
      } else {
        current = lunchEndMins;
      }
    }

    generatedSlots.assignAll(slots);
    if (showSuccessMessage) {
      if (slots.isNotEmpty) {
        Get.snackbar('Thành công', 'Đã tự động chia thành ${slots.length} ca khám sức khỏe thành công!', backgroundColor: AppColors.success, colorText: Colors.white);
      } else {
        Get.snackbar('Thông báo', 'Không có ca khám nào được chia, vui lòng xem lại cấu hình.', backgroundColor: Colors.amber, colorText: Colors.black);
      }
    }
  }

  Future<void> _addCustomSlot(BuildContext context) async {
    final TimeOfDay? pickedStart = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      helpText: 'CHỌN GIỜ BẮT ĐẦU CA KHÁM',
    );
    if (pickedStart == null) return;
    if (!context.mounted) return;

    final TimeOfDay? pickedEnd = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: pickedStart.hour + 1, minute: pickedStart.minute),
      helpText: 'CHỌN GIỜ KẾT THÚC CA KHÁM',
    );
    if (pickedEnd == null) return;

    final startStr = '${pickedStart.hour.toString().padLeft(2, '0')}:${pickedStart.minute.toString().padLeft(2, '0')}';
    final endStr = '${pickedEnd.hour.toString().padLeft(2, '0')}:${pickedEnd.minute.toString().padLeft(2, '0')}';

    if (pickedStart.hour * 60 + pickedStart.minute >= pickedEnd.hour * 60 + pickedEnd.minute) {
      Get.snackbar('Lỗi nhập liệu', 'Giờ kết thúc phải sau giờ bắt đầu ca khám', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    generatedSlots.add({
      'start': startStr,
      'end': endStr,
    });

    generatedSlots.sort((a, b) => a['start']!.compareTo(b['start']!));
  }

  void _submitAllData() {
    if (selectedDays.isEmpty) {
      Get.snackbar('Lỗi nhập liệu', 'Vui lòng chọn ít nhất một ngày làm việc trong tuần.', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (generatedSlots.isEmpty) {
      Get.snackbar('Lỗi nhập liệu', 'Vui lòng cấu hình và tự động chia ít nhất một khung giờ khám.', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    controller.addDoctor(
      fullName: doctorData['fullName'] ?? '',
      email: doctorData['email'] ?? '',
      password: doctorData['password'] ?? '',
      departmentId: doctorData['departmentId'] ?? '',
      licenseNumber: doctorData['licenseNumber'] ?? '',
      consultationFee: doctorData['consultationFee'] ?? 0.0,
      experienceYears: doctorData['experienceYears'] ?? 0,
      workingDays: selectedDays.toList(),
      slots: generatedSlots.toList(),
      phone: doctorData['phone'],
      qualification: doctorData['qualification'],
      school: doctorData['school'],
      specialization: doctorData['specialization'],
      certificates: doctorData['certificates'],
      clinicalFocus: doctorData['clinicalFocus'],
      emergencyRelativeName: doctorData['emergencyRelativeName'],
      emergencyRelativePhone: doctorData['emergencyRelativePhone'],
    );
  }
}
