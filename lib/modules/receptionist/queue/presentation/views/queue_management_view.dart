import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/queue_management_controller.dart';

class QueueManagementView extends GetView<QueueManagementController> {
  const QueueManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        title: const Text(
          'HÀNG CHỜ PHÒNG KHÁM',
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 1.5,
              color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF38BDF8)),
            onPressed: () => controller.loadQueue(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -120,
            right: -120,
            width: 320,
            height: 320,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1038BDF8),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            width: 350,
            height: 350,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x10C084FC),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
            child: Container(color: Colors.transparent),
          ),

          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
              }

              if (controller.queueList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F1626),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: const Icon(Icons.queue_play_next_rounded,
                            size: 54, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Hàng đợi đang trống',
                        style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(18),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.queueList.length,
                itemBuilder: (context, index) {
                  final item = controller.queueList[index];
                  final patientName =
                      item['appointments']?['user_profiles']?['full_name'] ??
                          'Bệnh nhân vãng lai';
                  final reason =
                      item['appointments']?['reason'] ?? 'Khám tổng quát';
                  final number = item['queue_number'] ?? 0;
                  final status = item['status'].toString();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1626),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _getBorderColor(status), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withOpacity(0.08),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: _getStatusColor(status).withOpacity(0.2)),
                          ),
                          child: Center(
                            child: Text(
                              '#$number',
                              style: TextStyle(
                                  color: _getStatusColor(status),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patientName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                reason,
                                style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              _buildStatusBadge(status),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            if (status == 'waiting') ...[
                              IconButton(
                                icon: const Icon(Icons.volume_up_rounded,
                                    color: Color(0xFF10B981), size: 22),
                                onPressed: () => controller.callNext(item['id']),
                                tooltip: 'Gọi khám',
                              ),
                              IconButton(
                                icon: const Icon(Icons.do_disturb_on_rounded,
                                    color: Color(0xFFF43F5E), size: 20),
                                onPressed: () => controller.skipPatient(item['id']),
                                tooltip: 'Bỏ qua',
                              ),
                            ],
                            IconButton(
                              icon: const Icon(Icons.print_rounded,
                                  color: Color(0xFF38BDF8), size: 20),
                              onPressed: () => controller.printSlip(item),
                              tooltip: 'In phiếu khám',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'calling':
        return const Color(0xFF10B981);
      case 'skipped':
        return const Color(0xFFF43F5E);
      default:
        return const Color(0xFF38BDF8);
    }
  }

  Color _getBorderColor(String status) {
    if (status == 'calling') {
      return const Color(0xFF10B981).withOpacity(0.4);
    }
    return const Color(0xFF1E293B);
  }

  Widget _buildStatusBadge(String status) {
    String label = 'ĐANG ĐỢI';
    Color color = const Color(0xFF38BDF8);

    if (status == 'calling') {
      label = 'ĐANG GỌI';
      color = const Color(0xFF10B981);
    } else if (status == 'skipped') {
      label = 'BỎ QUA';
      color = const Color(0xFFF43F5E);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 8, fontWeight: FontWeight.bold),
      ),
    );
  }
}
