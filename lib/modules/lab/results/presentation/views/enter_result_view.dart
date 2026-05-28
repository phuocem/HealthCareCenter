import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lab_results_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class EnterResultView extends GetView<LabResultsController> {
  const EnterResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        title: const Text('Nhập Kết Quả Xét Nghiệm',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
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
                color: Color(0x10EC4899),
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
                color: Color(0x10C084FC),
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
                    child: CircularProgressIndicator(color: Color(0xFFEC4899)));
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPatientCard(),
                          const SizedBox(height: 20),
                          _buildSamplingStateCard(),
                          const SizedBox(height: 20),
                          _buildUrgentTagCard(),
                          const SizedBox(height: 24),
                          const Text(
                            'KẾT QUẢ XÉT NGHIỆM CHI TIẾT',
                            style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 12),
                          ...controller.requestItems
                              .map((item) => _buildResultInputCard(item)),
                          const SizedBox(height: 24),
                          _buildAttachmentCard(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButton(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard() {
    return Container(
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
              color: Color(0x1CEC4899),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded,
                color: Color(0xFFEC4899), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.patientName.value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ngày yêu cầu: ${controller.requestDate.value}',
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSamplingStateCard() {
    final states = [
      {'val': 'waiting_sample', 'label': 'Chờ lấy mẫu', 'color': const Color(0xFFFBBF24)},
      {'val': 'processing', 'label': 'Đang xử lý', 'color': const Color(0xFF38BDF8)},
      {'val': 'completed', 'label': 'Hoàn tất', 'color': const Color(0xFF10B981)},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TRẠNG THÁI MẪU XÉT NGHIỆM',
            style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: states.map((s) {
              final isSelected = controller.samplingState.value == s['val'];
              final color = s['color'] as Color;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.samplingState.value = s['val'] as String;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.12) : const Color(0xFF0A0F1E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isSelected ? color : const Color(0xFF1E293B),
                          width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        s['label'] as String,
                        style: TextStyle(
                            color: isSelected ? color : const Color(0xFF64748B),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentTagCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.report_problem_rounded, color: Color(0xFFEF4444), size: 20),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ĐÁNH DẤU KẾT QUẢ KHẨN CẤP',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Ưu tiên bác sĩ xem kết quả sớm nhất',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: controller.isUrgent.value,
            activeColor: const Color(0xFFEF4444),
            activeTrackColor: const Color(0xFFEF4444).withOpacity(0.3),
            inactiveThumbColor: const Color(0xFF64748B),
            inactiveTrackColor: const Color(0xFF0A0F1E),
            onChanged: (val) {
              controller.isUrgent.value = val;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultInputCard(Map<String, dynamic> item) {
    final testType = item['lab_test_types'] as Map?;
    final testName =
        testType != null ? (testType['name'] ?? 'Xét nghiệm') : 'Xét nghiệm';
    final testUnit = testType != null ? (testType['unit'] ?? '') : '';
    final itemId = item['id'].toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                testName.toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5),
              ),
              if (testUnit.toString().isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0F1E),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Đơn vị: $testUnit',
                    style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Nhập giá trị kết quả...',
                    hintStyle: const TextStyle(color: Color(0xFF475569)),
                    fillColor: const Color(0xFF0A0F1E),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
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
                      borderSide: const BorderSide(color: Color(0xFFEC4899)),
                    ),
                  ),
                  onChanged: (val) {
                    controller.resultValues[itemId] = val;
                  },
                ),
              ),
              const SizedBox(width: 14),
              // Abnormal Toggle Card
              Obx(() {
                final isAb = controller.isAbnormal[itemId] ?? false;
                return GestureDetector(
                  onTap: () {
                    controller.isAbnormal[itemId] = !isAb;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: isAb
                          ? const Color(0xFFEF4444).withOpacity(0.15)
                          : const Color(0xFF0A0F1E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isAb
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF1E293B),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAb
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline_rounded,
                          color: isAb
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF64748B),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Bất thường',
                          style: TextStyle(
                            color: isAb
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF64748B),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentCard() {
    final image = controller.attachedFilePath.value;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ĐÍNH KÈM FILE KẾT QUẢ XÉT NGHIỆM',
            style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => controller.pickAttachment(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0F1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E293B), width: 1),
              ),
              child: image.isEmpty
                  ? const Column(
                      children: [
                        Icon(Icons.cloud_upload_outlined,
                            color: Color(0xFFEC4899), size: 28),
                        SizedBox(height: 8),
                        Text(
                          'Chọn file đính kèm (Ảnh chụp mẫu xét nghiệm, X-Quang...)',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF10B981), size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Đã đính kèm tệp tin thành công',
                          style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
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
            backgroundColor: const Color(0xFFEC4899),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          onPressed: () => controller.submitResults(),
          child: const Text(
            'GỬI KẾT QUẢ XÉT NGHIỆM',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }
}
