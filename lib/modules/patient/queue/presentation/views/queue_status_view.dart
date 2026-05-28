import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/queue_status_controller.dart';

class QueueStatusView extends GetView<QueueStatusController> {
  const QueueStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      body: Stack(
        children: [
          // Decorative blobs
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
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF0284C7)));
                    }

                    return RefreshIndicator(
                      onRefresh: () => controller.loadQueueStatus(),
                      color: const Color(0xFF0284C7),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildQueueStatusCard(),
                            const SizedBox(height: 24),
                            const Text(
                              'TIẾN TRÌNH KHÁM BỆNH',
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildProgressTimeline(),
                            const SizedBox(height: 30),
                            _buildSimulationButton(),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
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
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF475569), size: 16),
              onPressed: () => Get.back(),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'HÀNG CHỜ REALTIME',
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

  Widget _buildQueueStatusCard() {
    final patientNum = controller.patientNumber.value;
    final currentNum = controller.currentNumber.value;
    final waitMin = controller.waitingTimeMin.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SỐ THỨ TỰ CỦA BẠN',
                    style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '#$patientNum',
                    style: const TextStyle(
                        color: Color(0xFF0284C7),
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.people_alt_rounded,
                    color: Color(0xFF0284C7), size: 26),
              ),
            ],
          ),
          const Divider(color: Color(0xFFE2E8F0), height: 32, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQueueSubDetail(
                  'ĐANG GỌI ĐẾN', '#$currentNum', const Color(0xFF10B981)),
              _buildQueueSubDetail(
                  'DỰ KIẾN CHỜ', '$waitMin phút', const Color(0xFFF59E0B)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.meeting_room_rounded,
                    color: Color(0xFF64748B), size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            controller.doctorName.value,
                            style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 13,
                                fontWeight: FontWeight.w800),
                          )),
                      const SizedBox(height: 2),
                      Obx(() => Text(
                            controller.clinicRoom.value,
                            style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueSubDetail(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              color: color, fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _buildProgressTimeline() {
    final statusList = [
      {'status': 'waiting_confirm', 'label': 'Chờ xác nhận', 'desc': 'Yêu cầu khám đang chờ phê duyệt'},
      {'status': 'waiting_exam', 'label': 'Đang chờ khám', 'desc': 'Xếp hàng chờ tại phòng bác sĩ chỉ định'},
      {'status': 'testing', 'label': 'Đang xét nghiệm', 'desc': 'Thực hiện lấy mẫu xét nghiệm lâm sàng'},
      {'status': 'waiting_result', 'label': 'Chờ kết quả', 'desc': 'Chờ kết quả xét nghiệm gửi về bác sĩ'},
      {'status': 'prescribed', 'label': 'Đã kê đơn', 'desc': 'Bác sĩ kết luận bệnh và hoàn tất kê đơn điện tử'},
      {'status': 'waiting_pay', 'label': 'Chờ thanh toán', 'desc': 'Thanh toán viện phí và hóa đơn thuốc phát sinh'},
      {'status': 'completed', 'label': 'Hoàn tất', 'desc': 'Nhận thuốc và kết thúc phiên khám bệnh'},
    ];

    final currentStatusIndex = statusList.indexWhere((s) => s['status'] == controller.activeStatus.value);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: statusList.length,
        itemBuilder: (context, index) {
          final step = statusList[index];
          final isCompleted = index < currentStatusIndex;
          final isActive = index == currentStatusIndex;
          final isLast = index == statusList.length - 1;

          Color stepColor = const Color(0xFFCBD5E1);
          if (isCompleted) {
            stepColor = const Color(0xFF10B981);
          } else if (isActive) {
            stepColor = const Color(0xFF0284C7);
          }

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: stepColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: stepColor, width: isActive ? 5 : 2),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check_rounded,
                              color: Color(0xFF10B981), size: 12)
                          : null,
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: isCompleted
                              ? const Color(0xFF10B981)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['label']!,
                          style: TextStyle(
                            color: isActive
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF64748B),
                            fontSize: 13,
                            fontWeight: isActive
                                ? FontWeight.w900
                                : FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step['desc']!,
                          style: TextStyle(
                            color: isActive
                                ? const Color(0xFF475569)
                                : const Color(0xFF94A3B8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSimulationButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF475569).withOpacity(0.08),
            blurRadius: 10,
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: () => _showStatusSwitcherDialog(),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF475569),
          side: const BorderSide(color: Color(0xFFCBD5E1)),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.terminal_rounded, size: 16),
            SizedBox(width: 8),
            Text(
              'SIMULATOR: CHUYỂN TRẠNG THÁI',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusSwitcherDialog() {
    final statusList = [
      {'status': 'waiting_confirm', 'label': '1. Chờ xác nhận'},
      {'status': 'waiting_exam', 'label': '2. Đang chờ khám'},
      {'status': 'testing', 'label': '3. Đang xét nghiệm'},
      {'status': 'waiting_result', 'label': '4. Chờ kết quả'},
      {'status': 'prescribed', 'label': '5. Đã kê đơn'},
      {'status': 'waiting_pay', 'label': '6. Chờ thanh toán'},
      {'status': 'completed', 'label': '7. Hoàn tất'},
    ];

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F1626),
        title: const Text(
          'MÔ PHỎNG TRẠNG THÁI KHÁM BỆNH',
          style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statusList.map((item) {
            return ListTile(
              title: Text(
                item['label']!,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w800),
              ),
              onTap: () {
                controller.activeStatus.value = item['status']!;
                if (item['status'] == 'waiting_exam') {
                  controller.simulateQueueUpdate();
                }
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
