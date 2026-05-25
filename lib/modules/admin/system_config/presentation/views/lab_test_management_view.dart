import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/system_config_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class LabTestManagementView extends GetView<SystemConfigController> {
  const LabTestManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.adminBg,
      appBar: AppBar(
        title: const Text(
          'Chỉ Số Xét Nghiệm', 
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
            top: -100,
            left: -100,
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
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.labTestTypes.length,
                itemBuilder: (context, index) {
                  final test = controller.labTestTypes[index];
                  return _buildTestCard(test);
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
              color: const Color(0xFFC084FC).withValues(alpha: 0.25),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showTestDialog(),
          backgroundColor: const Color(0xFFC084FC),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildTestCard(Map<String, dynamic> test) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.adminCardBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFC084FC).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFC084FC).withValues(alpha: 0.12)),
                ),
                child: const Icon(Icons.biotech_rounded, color: Color(0xFFC084FC), size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  test['test_name'], 
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              _buildIconButton(
                Icons.edit_rounded, 
                const Color(0xFF38BDF8), 
                () => _showTestDialog(test: test),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFF1E293B), height: 1, thickness: 1.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoTile('THAM CHIẾU', test['reference_range'] ?? 'N/A', Icons.straighten_rounded, const Color(0xFF34D399)),
              _buildInfoTile('ĐƠN VỊ', test['unit'] ?? 'N/A', Icons.square_foot_rounded, const Color(0xFFFBBF24)),
              _buildInfoTile('LIÊN KẾT', test['services']?['name']?.split(' ').last ?? 'Chưa gán', Icons.link_rounded, const Color(0xFF38BDF8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF64748B), size: 10),
              const SizedBox(width: 4),
              Text(
                label, 
                style: const TextStyle(fontSize: 9, color: Color(0xFF64748B), fontWeight: FontWeight.w800, letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value, 
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02), 
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 18),
        onPressed: onTap,
      ),
    );
  }

  void _showTestDialog({Map<String, dynamic>? test}) {
    final nameController = TextEditingController(text: test?['test_name']);
    final rangeController = TextEditingController(text: test?['reference_range']);
    final unitController = TextEditingController(text: test?['unit']);
    String? selectedServiceId = test?['service_id'];

    Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: AppColors.adminBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: const BorderSide(color: AppColors.adminCardBorder, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    test == null ? 'Thêm Chỉ Số Xét Nghiệm' : 'Sửa Chỉ Số Xét Nghiệm', 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(nameController, 'Tên chỉ số', Icons.biotech_rounded, const Color(0xFFC084FC)),
                  const SizedBox(height: 16),
                  _buildTextField(rangeController, 'Khoảng tham chiếu', Icons.straighten_rounded, const Color(0xFF34D399)),
                  const SizedBox(height: 16),
                  _buildTextField(unitController, 'Đơn vị đo', Icons.square_foot_rounded, const Color(0xFFFBBF24)),
                  const SizedBox(height: 16),
                  Obx(() => _buildServiceDropdown(selectedServiceId, (val) => selectedServiceId = val)),
                  const SizedBox(height: 28),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC084FC).withValues(alpha: 0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC084FC),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        final data = {
                          'test_name': nameController.text,
                          'reference_range': rangeController.text,
                          'unit': unitController.text,
                          'service_id': selectedServiceId,
                        };
                        controller.saveLabTest(data, id: test?['id']);
                        Get.back();
                      },
                      child: const Text('LƯU CHỈ SỐ', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, Color color) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.02),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.adminCardBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildServiceDropdown(String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: AppColors.adminSurface,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Dịch vụ xét nghiệm',
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.02),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.adminCardBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
        ),
      ),
      items: controller.services
          .where((s) => s['category'] == 'Lab Test')
          .map((e) => DropdownMenuItem(value: e['id'] as String, child: Text(e['name'])))
          .toList(),
      onChanged: onChanged,
    );
  }
}
