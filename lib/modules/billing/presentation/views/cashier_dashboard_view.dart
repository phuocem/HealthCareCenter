import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/cashier_dashboard_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';

class CashierDashboardView extends GetView<CashierDashboardController> {
  const CashierDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

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
                color: Color(0x12FBBF24),
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
                color: Color(0x12F59E0B),
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
                  child: CircularProgressIndicator(color: Color(0xFFFBBF24)),
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
                          _buildRevenueCard(currencyFormat),
                          const SizedBox(height: 20),
                          _buildStatRow(),
                          const SizedBox(height: 28),
                          _buildSectionTitle('QUICK ACTIONS'),
                          const SizedBox(height: 16),
                          _buildQuickActions(),
                          const SizedBox(height: 28),
                          _buildSectionTitle('HÓA ĐƠN GẦN ĐÂY'),
                          const SizedBox(height: 16),
                          _buildRecentInvoices(currencyFormat),
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
        'THU NGÂN HỆ THỐNG',
        style: TextStyle(
          color: Color(0xFFFBBF24),
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
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFFFBBF24), size: 18),
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
          'Quản lý thanh toán & hóa đơn bệnh nhân',
          style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    ));
  }

  Widget _buildRevenueCard(NumberFormat fmt) {
    return Obx(() => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1500), Color(0xFF0F1626)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DOANH THU HÔM NAY',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Text(
            fmt.format(controller.todayRevenue.value),
            style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMiniStat('Đã thanh toán', controller.paidCount.value.toString(), const Color(0xFF34D399)),
              const SizedBox(width: 24),
              _buildMiniStat('Chờ thanh toán', controller.pendingCount.value.toString(), const Color(0xFFFBBF24)),
              const SizedBox(width: 24),
              _buildMiniStat('Tổng hóa đơn', controller.totalInvoices.value.toString(), const Color(0xFF38BDF8)),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildStatRow() {
    return Obx(() => Row(
      children: [
        _buildStatCard('Tiền mặt', controller.cashAmount.value, Icons.payments_rounded, const Color(0xFF34D399)),
        const SizedBox(width: 12),
        _buildStatCard('Chuyển khoản', controller.transferAmount.value, Icons.account_balance_rounded, const Color(0xFF38BDF8)),
      ],
    ));
  }

  Widget _buildStatCard(String label, double amount, IconData icon, Color color) {
    final fmt = NumberFormat.compactCurrency(locale: 'vi_VN', symbol: 'đ');
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1626),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fmt.format(amount),
                      style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w900)),
                  Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
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
            gradient: AppColors.neonOrangeGradient,
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
      {'label': 'Tạo hóa đơn', 'icon': Icons.receipt_long_rounded, 'color': const Color(0xFFFBBF24)},
      {'label': 'Thanh toán', 'icon': Icons.payment_rounded, 'color': const Color(0xFF34D399)},
      {'label': 'Tra cứu BN', 'icon': Icons.search_rounded, 'color': const Color(0xFF38BDF8)},
      {'label': 'Báo cáo ngày', 'icon': Icons.bar_chart_rounded, 'color': const Color(0xFFC084FC)},
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
            if (index == 0 || index == 1) {
              Get.toNamed(Routes.CASHIER_INVOICES);
            } else if (index == 2) {
              _showPatientSearchDialog(context);
            } else {
              _showDailyReportDialog(context);
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

  void _showPatientSearchDialog(BuildContext context) {
    final searchController = TextEditingController();
    final searchResults = <Map<String, String>>[
      {'name': 'Nguyễn Văn A', 'code': 'HD-7782-A', 'amount': '250.000đ', 'status': 'Chờ TT'},
      {'name': 'Trần Thị B', 'code': 'HD-8109-B', 'amount': '580.000đ', 'status': 'Đã TT'},
      {'name': 'Lê Hoàng C', 'code': 'HD-3281-C', 'amount': '150.000đ', 'status': 'Chờ TT'},
    ].obs;

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F1626),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
        ),
        title: const Text('Tra cứu Hóa đơn Bệnh nhân', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nhập tên hoặc mã hóa đơn...',
                hintStyle: const TextStyle(color: Colors.white30),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF38BDF8)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.03),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.maxFinite,
              height: 160,
              child: Obx(() => ListView.builder(
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (_, i) {
                  final hd = searchResults[i];
                  final isPaid = hd['status'] == 'Đã TT';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(hd['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('Mã: ${hd['code']!} • Số tiền: ${hd['amount']!}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (isPaid ? const Color(0xFF34D399) : const Color(0xFFFBBF24)).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        hd['status']!,
                        style: TextStyle(color: isPaid ? const Color(0xFF34D399) : const Color(0xFFFBBF24), fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ĐÓNG', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDailyReportDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F1626),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFC084FC), width: 1.5),
        ),
        title: const Text('Báo cáo doanh thu Ngày', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReportRow('Tổng tiền mặt thu', '1.250.000đ', const Color(0xFF34D399)),
              const Divider(color: Colors.white10),
              _buildReportRow('Tổng chuyển khoản thu', '3.800.000đ', const Color(0xFF38BDF8)),
              const Divider(color: Colors.white10),
              _buildReportRow('Trung bình hóa đơn', '420.000đ', const Color(0xFFFBBF24)),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded, color: Color(0xFF34D399), size: 16),
                  SizedBox(width: 6),
                  Text('Đã đối soát thành công bàn giao ca', style: TextStyle(color: Color(0xFF34D399), fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ĐÓNG', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildReportRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildRecentInvoices(NumberFormat fmt) {
    return Obx(() {
      if (controller.recentInvoices.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1626),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
          ),
          alignment: Alignment.center,
          child: const Text(
            'CHƯA CÓ HÓA ĐƠN HÔM NAY',
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
          itemCount: controller.recentInvoices.length > 5 ? 5 : controller.recentInvoices.length,
          separatorBuilder: (_, i) => const Divider(color: Color(0xFF1E293B), height: 16),
          itemBuilder: (context, index) {
            final inv = controller.recentInvoices[index];
            final isPaid = inv['status'] == 'paid';
            return Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isPaid ? const Color(0xFF34D399) : const Color(0xFFFBBF24),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(inv['patient_name']?.toString() ?? '',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                      Text(inv['invoice_number']?.toString() ?? '',
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      fmt.format(double.tryParse(inv['total_amount']?.toString() ?? '0') ?? 0),
                      style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.w900, fontSize: 13),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (isPaid ? const Color(0xFF34D399) : const Color(0xFFFBBF24)).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPaid ? 'Đã TT' : 'Chờ TT',
                        style: TextStyle(
                          color: isPaid ? const Color(0xFF34D399) : const Color(0xFFFBBF24),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
