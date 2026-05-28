import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/patient_invoice_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class PatientInvoiceView extends GetView<PatientInvoiceController> {
  const PatientInvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        title: const Text('Hóa Đơn & Thanh Toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
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

              if (controller.invoices.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: controller.invoices.length,
                itemBuilder: (context, index) {
                  final invoice = controller.invoices[index];
                  return _buildInvoiceCard(invoice, currencyFormat);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> invoice, NumberFormat fmt) {
    final status = invoice['status']?.toString() ?? 'unpaid';
    final amount = double.tryParse(invoice['total_amount']?.toString() ?? '0') ?? 0.0;
    
    // We can assume date from id or a static/dynamic created_at
    final date = invoice['created_at'] != null 
        ? invoice['created_at'].toString().substring(0, 10) 
        : '';
        
    final payments = invoice['payments'] as List? ?? [];

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
                'Hóa đơn ngày: $date',
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold),
              ),
              _buildInvoiceStatusChip(status),
            ],
          ),
          const SizedBox(height: 14),
          const Text('TỔNG CHI PHÍ HÓA ĐƠN:', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            fmt.format(amount),
            style: TextStyle(
              color: status == 'paid' ? const Color(0xFF10B981) : const Color(0xFFFBBF24),
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          
          if (payments.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: Color(0xFF1E293B)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.payment_rounded, size: 14, color: Color(0xFF10B981)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Đã giao dịch thành công tại quầy thu ngân',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInvoiceStatusChip(String status) {
    Color color = const Color(0xFF64748B);
    String label = 'Chờ TT';

    if (status == 'unpaid') {
      color = const Color(0xFFFBBF24);
      label = 'Chưa thanh toán';
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
            child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF64748B), size: 36),
          ),
          const SizedBox(height: 14),
          const Text('Bạn không có hóa đơn nào', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        ],
      ),
    );
  }
}
