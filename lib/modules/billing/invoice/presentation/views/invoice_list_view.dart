import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/invoice_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class InvoiceListView extends GetView<InvoiceController> {
  const InvoiceListView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0F1E),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1626),
          elevation: 0,
          title: const Text('Quản Lý Hóa Đơn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFFFBBF24)),
              onPressed: () => controller.loadInvoices(),
            ),
          ],
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Color(0xFFFBBF24),
            labelColor: Color(0xFFFBBF24),
            unselectedLabelColor: Color(0xFF64748B),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(text: 'CHỜ THANH TOÁN', icon: Icon(Icons.pending_actions_rounded, size: 20)),
              Tab(text: 'ĐÃ THANH TOÁN', icon: Icon(Icons.check_circle_rounded, size: 20)),
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
                  color: Color(0x10FBBF24),
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
                  color: Color(0x10F59E0B),
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
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFBBF24)));
                }

                return TabBarView(
                  children: [
                    _buildInvoiceList(controller.pendingInvoices, currencyFormat, isPending: true),
                    _buildInvoiceList(controller.paidInvoices, currencyFormat, isPending: false),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceList(List<Map<String, dynamic>> list, NumberFormat fmt, {required bool isPending}) {
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
                isPending ? Icons.receipt_long_rounded : Icons.check_circle_outline_rounded,
                color: const Color(0xFF64748B),
                size: 36,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              isPending ? 'Không có hóa đơn nào chờ thanh toán' : 'Không có hóa đơn nào đã thanh toán',
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
        final invoice = list[index];
        final patient = invoice['user_profiles'] as Map?;
        final patientName = patient != null ? (patient['full_name'] ?? 'Bệnh nhân') : 'Bệnh nhân';
        final amount = double.tryParse(invoice['total_amount']?.toString() ?? '0') ?? 0.0;
        final date = invoice['created_at'] != null 
            ? invoice['created_at'].toString().substring(0, 10) 
            : '';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1626),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ngày tạo: $date',
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fmt.format(amount),
                      style: TextStyle(
                        color: isPending ? const Color(0xFFFBBF24) : const Color(0xFF10B981),
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusChip(invoice['status']?.toString() ?? 'unpaid'),
                  const SizedBox(height: 12),
                  if (isPending)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBBF24),
                        foregroundColor: const Color(0xFF0A0F1E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        elevation: 0,
                      ),
                      onPressed: () {
                        controller.resetDiscount(amount);
                        _showPaymentDialog(context, invoice['id'], amount, patientName);
                      },
                      child: const Text('Thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentDialog(BuildContext context, String invoiceId, double amount, String patientName) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final selectedMethod = 'Tiền mặt'.obs;
    final methods = ['Tiền mặt', 'Chuyển khoản', 'Ví điện tử'];
    final voucherController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0F1626),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFFBBF24), width: 1.5),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chi Tiết Thanh Toán',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text('Bệnh nhân: $patientName', style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              Text(
                'Số tiền gốc: ${currencyFormat.format(amount)}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              const SizedBox(height: 12),
              
              // Voucher Input
              const Text('Mã giảm giá / BHYT:', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: voucherController,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Nhập HEALTHX10 hoặc BHYT20...',
                        hintStyle: const TextStyle(color: Colors.white24, fontSize: 11),
                        fillColor: const Color(0xFF0A0F1E),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8)),
                    onPressed: () {
                      controller.applyVoucher(voucherController.text, amount);
                    },
                    child: const Text('ÁP DỤNG', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              Obx(() => Text(
                    'Số tiền thực thu: ${currencyFormat.format(controller.finalAmount.value)}',
                    style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 14),
                  )),
              const SizedBox(height: 16),
              const Text('Hình thức thanh toán:', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() => Wrap(
                spacing: 8,
                children: methods.map((m) {
                  final isSel = selectedMethod.value == m;
                  return ChoiceChip(
                    label: Text(m, style: TextStyle(color: isSel ? const Color(0xFF0A0F1E) : Colors.white70, fontWeight: FontWeight.bold, fontSize: 11)),
                    selected: isSel,
                    selectedColor: const Color(0xFFFBBF24),
                    backgroundColor: const Color(0xFF0A0F1E),
                    onSelected: (selected) {
                      if (selected) selectedMethod.value = m;
                    },
                  );
                }).toList(),
              )),
              
              const SizedBox(height: 18),
              // Dynamic QR bank transfer code generator
              Obx(() {
                if (selectedMethod.value == 'Chuyển khoản') {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_2_rounded, color: Colors.black, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'QUÉT VIETQR CHUYỂN KHOẢN',
                              style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(Icons.qr_code_scanner_rounded, size: 100, color: const Color(0xFF0F172A).withValues(alpha: 0.8)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Số tiền: ${currencyFormat.format(controller.finalAmount.value)}',
                          style: const TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                        const Text(
                          'Ngân hàng: MBBank | STK: 888899999999',
                          style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFBBF24),
              foregroundColor: const Color(0xFF0A0F1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.back();
              controller.processPayment(invoiceId, amount, selectedMethod.value);
            },
            child: const Text('XÁC NHẬN', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = const Color(0xFF64748B);
    String label = 'Chờ TT';

    if (status == 'unpaid') {
      color = const Color(0xFFFBBF24);
      label = 'Chờ TT';
    } else if (status == 'paid') {
      color = const Color(0xFF10B981);
      label = 'Đã thanh toán';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}
