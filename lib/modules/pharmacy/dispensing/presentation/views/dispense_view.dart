import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dispense_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class DispenseView extends GetView<DispenseController> {
  const DispenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0F1E),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1626),
          elevation: 0,
          title: const Text('Cấp Phát Thuốc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
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
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Color(0xFF22D3EE),
            labelColor: Color(0xFF22D3EE),
            unselectedLabelColor: Color(0xFF64748B),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(text: 'CHỜ CẤP PHÁT', icon: Icon(Icons.hourglass_top_rounded, size: 20)),
              Tab(text: 'ĐÃ CẤP PHÁT', icon: Icon(Icons.task_alt_rounded, size: 20)),
            ],
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

                return TabBarView(
                  children: [
                    _buildPrescriptionList(controller.readyPrescriptions, isDispensed: false),
                    _buildPrescriptionList(controller.dispensedPrescriptions, isDispensed: true),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptionList(List<Map<String, dynamic>> list, {required bool isDispensed}) {
    if (list.isEmpty) {
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
              child: Icon(
                isDispensed ? Icons.assignment_turned_in_rounded : Icons.pending_actions_rounded,
                color: const Color(0xFF64748B),
                size: 36,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              isDispensed ? 'Không có đơn thuốc nào đã phát' : 'Không có đơn thuốc nào chờ phát',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final pres = list[index];
        final record = pres['medical_records'] as Map?;
        final patient = record != null ? record['user_profiles'] as Map? : null;
        final patientName = patient != null ? (patient['full_name'] ?? 'Bệnh nhân') : 'Bệnh nhân';
        final isPaid = pres['is_paid'] ?? false;
        
        final items = pres['prescription_items'] as List? ?? [];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
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
                    patientName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  _buildPaymentBadge(isPaid),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFF1E293B)),
              const SizedBox(height: 8),
              const Text('THUỐC CHỈ ĐỊNH:', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...items.map((item) {
                final invItem = item['inventory_items'] as Map?;
                final name = invItem != null ? (invItem['name'] ?? 'Thuốc') : 'Thuốc';
                final qty = item['quantity'] ?? 1;
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 5, color: Color(0xFF22D3EE)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(name, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ),
                      Text('SL: $qty', style: const TextStyle(color: Color(0xFF22D3EE), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }),
              if (!isDispensed) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPaid ? const Color(0xFF22D3EE) : const Color(0xFF1E293B),
                      foregroundColor: isPaid ? const Color(0xFF0A0F1E) : const Color(0xFF64748B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.local_shipping_rounded, size: 16),
                    label: Text(
                      isPaid ? 'CẤP PHÁT THUỐC' : 'CHỜ BỆNH NHÂN THANH TOÁN',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
                    ),
                    onPressed: isPaid 
                        ? () => controller.dispensePrescription(pres['id'])
                        : null, // Disabled if unpaid
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentBadge(bool isPaid) {
    final color = isPaid ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final label = isPaid ? 'Đã thanh toán' : 'Chưa thanh toán';

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
}
