import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/examination_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class ExaminationView extends GetView<ExaminationController> {
  const ExaminationView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0F1E),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1626),
          elevation: 0,
          title: Obx(() => Text(
            'Khám Bệnh: ${controller.patientName.value}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          )),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Color(0xFFF87171)),
              onPressed: () => controller.logout(),
            ),
          ],
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Color(0xFF34D399),
            labelColor: Color(0xFF34D399),
            unselectedLabelColor: Color(0xFF64748B),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(text: 'LÂM SÀNG', icon: Icon(Icons.assignment_rounded, size: 20)),
              Tab(text: 'XÉT NGHIỆM', icon: Icon(Icons.biotech_rounded, size: 20)),
              Tab(text: 'KÊ ĐƠN', icon: Icon(Icons.medication_rounded, size: 20)),
            ],
          ),
        ),
        body: Stack(
          children: [
            // Background blur highlights
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
                  color: Color(0x1060A5FA),
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
            SafeArea(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF34D399)),
                  );
                }
                
                return Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildClinicalTab(context),
                          _buildLabTab(context),
                          _buildPrescriptionTab(context),
                        ],
                      ),
                    ),
                    _buildBottomBar(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: CLINICAL DIAGNOSIS & VITALS
  Widget _buildClinicalTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1626),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0x1C60A5FA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded, color: Color(0xFF60A5FA), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        controller.patientName.value,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                        controller.patientEmail.value.isNotEmpty ? controller.patientEmail.value : 'Không có email',
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          const Text(
            'CHẨN ĐOÁN LÂM SÀNG *',
            style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Nhập chẩn đoán bệnh chính...',
              hintStyle: const TextStyle(color: Color(0xFF475569)),
              fillColor: const Color(0xFF0F1626),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF34D399)),
              ),
            ),
            onChanged: (val) => controller.diagnosis.value = val,
          ),
          const SizedBox(height: 20),

          const Text(
            'GHI CHÚ / TRIỆU CHỨNG',
            style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Nhập triệu chứng, ghi chú điều trị...',
              hintStyle: const TextStyle(color: Color(0xFF475569)),
              fillColor: const Color(0xFF0F1626),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF1E293B)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF34D399)),
              ),
            ),
            onChanged: (val) => controller.notes.value = val,
          ),
          const SizedBox(height: 20),

          const Text(
            'CHỈ SỐ SINH TỒN (TÙY CHỌN)',
            style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildVitalInput(
                  label: 'Cân nặng (kg)',
                  hint: '60',
                  icon: Icons.monitor_weight_outlined,
                  color: const Color(0xFF10B981),
                  onChanged: (val) => controller.weight.value = val,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildVitalInput(
                  label: 'Nhịp tim (bpm)',
                  hint: '75',
                  icon: Icons.favorite_border_rounded,
                  color: const Color(0xFFEF4444),
                  onChanged: (val) => controller.heartRate.value = val,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildVitalInput(
                  label: 'Nhiệt độ (°C)',
                  hint: '36.5',
                  icon: Icons.thermostat_rounded,
                  color: const Color(0xFFF59E0B),
                  onChanged: (val) => controller.temperature.value = val,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalInput({
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF475569)),
            prefixIcon: Icon(icon, color: color, size: 16),
            fillColor: const Color(0xFF0F1626),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1E293B)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1E293B)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: color),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // TAB 2: LAB TESTS SELECTOR
  Widget _buildLabTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CHỌN YÊU CẦU XÉT NGHIỆM',
            style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
          ),
          const SizedBox(height: 6),
          const Text(
            'Bệnh nhân sẽ được chỉ định thực hiện các xét nghiệm này trước khi nhận kết quả khám cuối cùng.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
          const SizedBox(height: 18),
          
          if (controller.labTestTypes.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text('Không có xét nghiệm nào khả dụng', style: TextStyle(color: Color(0xFF64748B))),
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.labTestTypes.map((test) {
                final isSelected = controller.selectedLabTests.any((element) => element['id'] == test['id']);
                return GestureDetector(
                  onTap: () => controller.toggleLabTest(test),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEC4899).withValues(alpha: 0.15) : const Color(0xFF0F1626),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFEC4899) : const Color(0xFF1E293B),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                          color: isSelected ? const Color(0xFFEC4899) : const Color(0xFF64748B),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          test['name'] ?? 'Xét nghiệm',
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                        if (test['unit'] != null && test['unit'].toString().trim().isNotEmpty)
                          Text(
                            ' (${test['unit']})',
                            style: const TextStyle(color: Color(0xFF475569), fontSize: 11),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF1E293B)),
          const SizedBox(height: 14),
          
          const Text(
            'DANH SÁCH CHỈ ĐỊNH XÉT NGHIỆM:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),
          if (controller.selectedLabTests.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1626),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B), style: BorderStyle.solid),
              ),
              child: const Center(
                child: Text(
                  'Chưa chọn xét nghiệm nào.',
                  style: TextStyle(color: Color(0xFF475569), fontSize: 13),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.selectedLabTests.length,
              itemBuilder: (context, index) {
                final test = controller.selectedLabTests[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1626),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.biotech_rounded, color: Color(0xFFEC4899), size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          test['name'] ?? '',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 18),
                        onPressed: () => controller.toggleLabTest(test),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // TAB 3: PRESCRIPTION MANAGER
  Widget _buildPrescriptionTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'KÊ ĐƠN THUỐC',
            style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
          ),
          const SizedBox(height: 14),

          // Medicine selection dropdown card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1626),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Chọn thuốc có sẵn trong kho:', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                const SizedBox(height: 8),
                if (controller.inventoryItems.isEmpty)
                  const Text('Không tìm thấy thuốc nào trong kho', style: TextStyle(color: Color(0xFFEF4444)))
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0F1E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Map<String, dynamic>>(
                        dropdownColor: const Color(0xFF0F1626),
                        value: controller.selectedMedicine.value,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF22D3EE)),
                        items: controller.inventoryItems.map((item) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: item,
                            child: Text(
                              item['name'] ?? 'Thuốc',
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) controller.selectedMedicine.value = val;
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Số lượng:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFF22D3EE)),
                          onPressed: () {
                            if (controller.medicineQuantity.value > 1) {
                              controller.medicineQuantity.value--;
                            }
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0F1E),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF1E293B)),
                          ),
                          child: Text(
                            '${controller.medicineQuantity.value}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF22D3EE)),
                          onPressed: () => controller.medicineQuantity.value++,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22D3EE),
                      foregroundColor: const Color(0xFF0A0F1E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Thêm vào đơn thuốc', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => controller.addMedicine(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'ĐƠN THUỐC ĐÃ CHỈ ĐỊNH:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),

          if (controller.prescriptionItems.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1626),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: const Center(
                child: Text(
                  'Chưa có thuốc nào trong đơn.',
                  style: TextStyle(color: Color(0xFF475569), fontSize: 13),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.prescriptionItems.length,
              itemBuilder: (context, index) {
                final item = controller.prescriptionItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1626),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.medication_rounded, color: Color(0xFF22D3EE), size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] ?? '',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Số lượng: ${item['quantity']}',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 18),
                        onPressed: () => controller.removeMedicine(index),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // BOTTOM FINALIZATION BAR
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF0F1626),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF34D399),
            foregroundColor: const Color(0xFF0A0F1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          onPressed: () => controller.finalizeExamination(),
          child: const Text(
            'HOÀN TẤT HỒ SƠ KHÁM',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }
}
