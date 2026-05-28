import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medical_results_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class MedicalResultsView extends GetView<MedicalResultsController> {
  const MedicalResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        title: const Text('Kết Quả Khám & Xét Nghiệm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0284C7)),
            onPressed: () => controller.loadMedicalRecords(),
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
                color: Color(0x100284C7),
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
                color: Color(0x1038BDF8),
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
                return const Center(child: CircularProgressIndicator(color: Color(0xFF0284C7)));
              }

              if (controller.medicalRecords.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: controller.medicalRecords.length,
                itemBuilder: (context, index) {
                  final record = controller.medicalRecords[index];
                  return _buildRecordCard(record);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    final doctor = record['doctors'] as Map?;
    final docProfile = doctor != null ? doctor['user_profiles'] as Map? : null;
    final doctorName = docProfile != null ? (docProfile['full_name'] ?? 'Bác sĩ') : 'Bác sĩ';
    
    final date = record['created_at'] != null 
        ? record['created_at'].toString().substring(0, 10) 
        : '';
        
    final diagnosis = record['diagnosis'] ?? 'Không ghi nhận';
    
    // Parse lab requests
    final labRequests = record['lab_requests'] as List? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lịch khám ngày: $date',
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'BS: $doctorName',
                  style: const TextStyle(color: Color(0xFF0284C7), fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'CHẨN ĐOÁN LÂM SÀNG:',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            diagnosis,
            style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
          ),
          
          // Lab results section if any exists
          if (labRequests.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF1E293B)),
            const SizedBox(height: 10),
            const Text(
              'KẾT QUẢ XÉT NGHIỆM CHỈ ĐỊNH:',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...labRequests.map((req) {
              final items = req['lab_request_items'] as List? ?? [];
              final status = req['status']?.toString() ?? 'pending';

              if (status == 'pending') {
                return Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0F1E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.hourglass_top_rounded, color: Color(0xFFFBBF24), size: 16),
                      SizedBox(width: 8),
                      Text('Xét nghiệm đang trong quá trình xử lý...', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    ],
                  ),
                );
              }

              return Column(
                children: items.map<Widget>((item) {
                  final testType = item['lab_test_types'] as Map?;
                  final testName = testType != null ? (testType['name'] ?? 'Xét nghiệm') : 'Xét nghiệm';
                  final unit = testType != null ? (testType['unit'] ?? '') : '';
                  
                  final results = item['lab_results'] as List? ?? [];
                  String resultVal = 'Chưa có kết quả';
                  bool isAbnormal = false;

                  if (results.isNotEmpty) {
                    final res = results.first as Map;
                    resultVal = res['result_value']?.toString() ?? '';
                    isAbnormal = res['is_abnormal'] == true;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0F1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1E293B)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(testName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(
                              'Kết quả: $resultVal $unit',
                              style: TextStyle(
                                color: isAbnormal ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isAbnormal ? const Color(0xFFEF4444) : const Color(0xFF10B981)).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isAbnormal ? 'Bất thường' : 'Bình thường',
                            style: TextStyle(
                              color: isAbnormal ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ],
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
            child: const Icon(Icons.assignment_rounded, color: Color(0xFF64748B), size: 36),
          ),
          const SizedBox(height: 14),
          const Text('Bạn chưa có kết quả khám nào', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        ],
      ),
    );
  }
}
