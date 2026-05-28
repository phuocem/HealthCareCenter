import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pharmacist_dashboard_controller.dart';
import '../../../../core/routes/app_routes.dart';

class PharmacistDashboardView extends GetView<PharmacistDashboardController> {
  const PharmacistDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            width: 280,
            height: 280,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1222D3EE),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -120,
            width: 300,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1206B6D4),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(color: Colors.transparent),
          ),
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF22D3EE)),
                );
              }
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildStatCards(),
                          const SizedBox(height: 28),
                          _buildSectionTitle('QUICK ACTIONS'),
                          const SizedBox(height: 16),
                          _buildQuickActions(),
                          const SizedBox(height: 28),
                          _buildSectionTitle('ĐƠN THUỐC CHỜ CẤP PHÁT'),
                          const SizedBox(height: 16),
                          _buildPendingPrescriptions(),
                          const SizedBox(height: 28),
                          _buildSectionTitle('THUỐC SẮP HẾT TỒN KHO'),
                          const SizedBox(height: 16),
                          _buildLowStockAlert(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        'DƯỢC - PHARMACY',
        style: TextStyle(
          color: Color(0xFF22D3EE),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: IconButton(
            onPressed: controller.loadData,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF22D3EE), size: 18),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFB7185).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFB7185).withValues(alpha: 0.15)),
          ),
          child: IconButton(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFFB7185), size: 18),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F1626),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFFB7185), width: 1.5),
        ),
        title: const Text('Đăng xuất', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        content: const Text('Bạn có chắc muốn đăng xuất?', style: TextStyle(color: Color(0xFF94A3B8))),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB7185),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xin chào, ${controller.staffName.value}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Quản lý cấp phát thuốc & tồn kho dược phẩm',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    ));
  }

  Widget _buildStatCards() {
    return Obx(() => Row(
      children: [
        _buildStatCard('Đơn chờ cấp', controller.pendingPrescriptions.value.toString(),
            Icons.pending_actions_rounded, const Color(0xFFFBBF24)),
        const SizedBox(width: 12),
        _buildStatCard('Đã cấp phát', controller.dispensedCount.value.toString(),
            Icons.medication_rounded, const Color(0xFF22D3EE)),
        const SizedBox(width: 12),
        _buildStatCard('Thuốc sắp hết', controller.lowStockCount.value.toString(),
            Icons.warning_amber_rounded, const Color(0xFFFB7185)),
      ],
    ));
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1626),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 12),
            Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFF22D3EE),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            )),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'label': 'Cấp phát thuốc', 'icon': Icons.medication_liquid_rounded, 'color': const Color(0xFF22D3EE)},
      {'label': 'Nhập kho', 'icon': Icons.add_box_rounded, 'color': const Color(0xFF34D399)},
      {'label': 'Kiểm kho', 'icon': Icons.inventory_2_rounded, 'color': const Color(0xFFC084FC)},
      {'label': 'Báo cáo tồn', 'icon': Icons.bar_chart_rounded, 'color': const Color(0xFFFBBF24)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        final color = action['color'] as Color;
        return GestureDetector(
          onTap: () {
            if (index == 0) {
              Get.toNamed(Routes.PHARMACY_DISPENSE);
            } else {
              Get.snackbar('Tính năng', 'Tính năng đang được phát triển.');
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1626),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
            ),
            child: Row(
              children: [
                Icon(action['icon'] as IconData, color: color, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    action['label'] as String,
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 12),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPendingPrescriptions() {
    return Obx(() {
      if (controller.prescriptions.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1626),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
          ),
          alignment: Alignment.center,
          child: const Text(
            'KHÔNG CÓ ĐƠN THUỐC CHỜ CẤP PHÁT',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
          ),
        );
      }
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F1626),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: controller.prescriptions.length > 5 ? 5 : controller.prescriptions.length,
          separatorBuilder: (_, i) => const Divider(color: Color(0xFF1E293B), height: 16),
          itemBuilder: (context, index) {
            final rx = controller.prescriptions[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.toNamed(Routes.PHARMACY_DISPENSE),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22D3EE),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rx['patient_name']?.toString() ?? 'Bệnh nhân',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text('BS. ${rx['doctor_name']?.toString() ?? ''}',
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${rx['item_count'] ?? 0} thuốc',
                          style: const TextStyle(color: Color(0xFF22D3EE), fontWeight: FontWeight.w700, fontSize: 12)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBBF24).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Chờ cấp',
                            style: TextStyle(color: Color(0xFFFBBF24), fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildLowStockAlert() {
    return Obx(() {
      if (controller.lowStockItems.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1626),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
          ),
          alignment: Alignment.center,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 16),
              SizedBox(width: 8),
              Text('Tồn kho bình thường', style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        );
      }
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F1626),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFFB7185).withValues(alpha: 0.3), width: 1.5),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: controller.lowStockItems.length > 5 ? 5 : controller.lowStockItems.length,
          separatorBuilder: (_, i) => const Divider(color: Color(0xFF1E293B), height: 16),
          itemBuilder: (context, index) {
            final item = controller.lowStockItems[index];
            final qty = int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;
            final minQty = int.tryParse(item['min_quantity']?.toString() ?? '10') ?? 10;
            final percent = qty / (minQty == 0 ? 1 : minQty);

            return Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFFB7185), size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name']?.toString() ?? '',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: percent.clamp(0.0, 1.0),
                          backgroundColor: const Color(0xFF1E293B),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            percent < 0.2 ? const Color(0xFFFB7185) : const Color(0xFFFBBF24),
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text('$qty/$minQty',
                    style: const TextStyle(color: Color(0xFFFB7185), fontWeight: FontWeight.w900, fontSize: 12)),
              ],
            );
          },
        ),
      );
    });
  }
}
