import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pharmacy_inventory_controller.dart';

class PharmacyInventoryView extends GetView<PharmacyInventoryController> {
  const PharmacyInventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        title: const Text(
          'QUẢN LÝ KHO THUỐC',
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
            icon: const Icon(Icons.sync_rounded, color: Color(0xFF38BDF8)),
            onPressed: () => controller.loadInventory(),
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

              if (controller.inventoryList.isEmpty) {
                return const Center(
                  child: Text(
                    'Không tìm thấy danh mục thuốc nào.',
                    style: TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.bold),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(18),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.inventoryList.length,
                itemBuilder: (context, index) {
                  final med = controller.inventoryList[index];
                  final name = med['name'] ?? 'Tên thuốc';
                  final stock = int.tryParse(med['stock']?.toString() ?? '0') ?? 0;
                  final expiry = med['expiry_date'] ?? '2028-12-31';
                  final type = med['type'] ?? 'Viên nén';
                  final replacement = med['replacement'] ?? 'Chưa cập nhật thuốc thay thế';

                  // Warnings logic
                  final isOutOfStock = stock == 0;
                  final isLowStock = stock > 0 && stock <= 15;
                  
                  // Simple expiry check (if expired or expiring soon in 3 months)
                  final expDate = DateTime.tryParse(expiry) ?? DateTime.now();
                  final isExpiringSoon = expDate.difference(DateTime.now()).inDays < 90;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1626),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                          color: isOutOfStock
                              ? const Color(0xFFEF4444).withOpacity(0.3)
                              : isExpiringSoon
                                  ? const Color(0xFFFBBF24).withOpacity(0.3)
                                  : const Color(0xFF1E293B),
                          width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                type,
                                style: const TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'SỐ LƯỢNG TỒN KHO',
                                  style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$stock đơn vị',
                                  style: TextStyle(
                                      color: isOutOfStock
                                          ? const Color(0xFFEF4444)
                                          : isLowStock
                                              ? const Color(0xFFFBBF24)
                                              : Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'HẠN SỬ DỤNG',
                                  style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  expiry,
                                  style: TextStyle(
                                      color: isExpiringSoon
                                          ? const Color(0xFFFBBF24)
                                          : Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                            color: Color(0xFF1E293B),
                            height: 24,
                            thickness: 1),
                        
                        // Expiring / Stock Warnings Badges
                        if (isOutOfStock) ...[
                          _buildWarningBadge(
                              Icons.error_outline_rounded,
                              'HẾT HÀNG: Cần bổ sung hoặc nhập thuốc thay thế',
                              const Color(0xFFEF4444)),
                          const SizedBox(height: 8),
                          _buildReplacementCard(replacement),
                        ] else if (isLowStock) ...[
                          _buildWarningBadge(
                              Icons.warning_amber_rounded,
                              'CẢNH BÁO: Tồn kho dưới mức an toàn',
                              const Color(0xFFFBBF24)),
                        ],

                        if (isExpiringSoon && !isOutOfStock) ...[
                          const SizedBox(height: 6),
                          _buildWarningBadge(
                              Icons.history_rounded,
                              'CẢNH BÁO CẬN HẠN: Hạn dùng dưới 90 ngày',
                              const Color(0xFFFBBF24)),
                        ],
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

  Widget _buildWarningBadge(IconData icon, String message, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplacementCard(String replacement) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF38BDF8).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.swap_horiz_rounded, color: Color(0xFF38BDF8), size: 14),
              SizedBox(width: 6),
              Text(
                'THUỐC TƯƠNG ĐƯƠNG THAY THẾ',
                style: TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 9,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            replacement,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.3),
          ),
        ],
      ),
    );
  }
}
