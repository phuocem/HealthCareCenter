import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/prescription_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class PrescriptionView extends GetView<PrescriptionController> {
  const PrescriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        title: const Text('Đơn Thuốc Của Tôi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF22D3EE)),
            onPressed: () => controller.loadPrescriptions(),
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
                color: Color(0x1022D3EE),
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
                color: Color(0x1006B6D4),
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
                return const Center(child: CircularProgressIndicator(color: Color(0xFF22D3EE)));
              }

              if (controller.prescriptions.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: controller.prescriptions.length,
                itemBuilder: (context, index) {
                  final prescription = controller.prescriptions[index];
                  return _buildPrescriptionCard(prescription);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(Map<String, dynamic> pres) {
    final record = pres['medical_records'] as Map?;
    final doctor = record != null ? record['doctors'] as Map? : null;
    final docProfile = doctor != null ? doctor['user_profiles'] as Map? : null;
    final doctorName = docProfile != null ? (docProfile['full_name'] ?? 'Bác sĩ') : 'Bác sĩ';
    
    final date = record != null && record['created_at'] != null 
        ? record['created_at'].toString().substring(0, 10) 
        : '';

    // Check payment status from invoices
    final apt = record != null ? record['appointments'] as Map? : null;
    final invoices = apt != null ? apt['invoices'] as List? : null;
    bool isPaid = false;
    if (invoices != null && invoices.isNotEmpty) {
      final inv = invoices.first as Map;
      isPaid = inv['status'] == 'paid';
    }

    final items = pres['prescription_items'] as List? ?? [];

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
                'Kê đơn ngày: $date',
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
              ),
              _buildInvoiceStatusChip(isPaid),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Bác sĩ chỉ định: $doctorName',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF1E293B)),
          const SizedBox(height: 8),
          const Text('CHI TIẾT THUỐC:', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...items.map((item) {
            final invItem = item['inventory_items'] as Map?;
            final name = invItem != null ? (invItem['name'] ?? 'Thuốc') : 'Thuốc';
            final qty = item['quantity'] ?? 1;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0F1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.medication_rounded, color: Color(0xFF22D3EE), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        const Text(
                          'Liều lượng: Uống theo chỉ định của bác sĩ',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22D3EE).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'SL: $qty',
                      style: const TextStyle(color: Color(0xFF22D3EE), fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInvoiceStatusChip(bool isPaid) {
    final color = isPaid ? const Color(0xFF10B981) : const Color(0xFFFBBF24);
    final label = isPaid ? 'Đã thanh toán / Đã nhận thuốc' : 'Chờ thanh toán hóa đơn';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold),
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
            child: const Icon(Icons.medication_rounded, color: Color(0xFF64748B), size: 36),
          ),
          const SizedBox(height: 14),
          const Text('Bạn chưa có đơn thuốc nào', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        ],
      ),
    );
  }
}
