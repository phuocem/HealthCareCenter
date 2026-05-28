import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InvoiceController extends GetxController {
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  final invoices = <Map<String, dynamic>>[].obs;
  
  final pendingInvoices = <Map<String, dynamic>>[].obs;
  final paidInvoices = <Map<String, dynamic>>[].obs;

  // Voucher / Insurance State
  final appliedVoucherCode = ''.obs;
  final discountPercent = 0.0.obs; // e.g. 10.0 for 10%
  final discountAmount = 0.0.obs;
  final finalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    try {
      isLoading.value = true;

      final data = await _client
          .from('invoices')
          .select('*, user_profiles(*)')
          .order('id', ascending: false);

      if (data != null) {
        final list = List<Map<String, dynamic>>.from(data);
        invoices.assignAll(list);
        
        // Split by status
        pendingInvoices.assignAll(list.where((element) => element['status'] == 'unpaid').toList());
        paidInvoices.assignAll(list.where((element) => element['status'] == 'paid').toList());
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách hóa đơn: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyVoucher(String code, double baseAmount) async {
    if (code.trim().isEmpty) return;

    try {
      // Look up voucher code from insurance_vouchers
      final response = await _client
          .from('insurance_vouchers')
          .select('*')
          .eq('code', code.trim().toUpperCase())
          .eq('is_active', true)
          .maybeSingle();

      if (response != null) {
        final percent = double.tryParse(response['discount_percent']?.toString() ?? '0') ?? 0.0;
        discountPercent.value = percent;
        appliedVoucherCode.value = code.trim().toUpperCase();
        
        // Update calculations
        discountAmount.value = baseAmount * (percent / 100);
        finalAmount.value = baseAmount - discountAmount.value;

        Get.snackbar('Thành công', 'Áp dụng voucher ${appliedVoucherCode.value} giảm ${percent.toInt()}% thành công!');
      } else {
        // Fallback mockup validation for generic vouchers
        if (code.trim().toUpperCase() == 'HEALTHX10' || code.trim().toUpperCase() == 'BHYT20') {
          final percent = code.trim().toUpperCase() == 'HEALTHX10' ? 10.0 : 20.0;
          discountPercent.value = percent;
          appliedVoucherCode.value = code.trim().toUpperCase();
          discountAmount.value = baseAmount * (percent / 100);
          finalAmount.value = baseAmount - discountAmount.value;
          Get.snackbar('Thành công', 'Áp dụng mã bảo hiểm giảm ${percent.toInt()}% thành công!');
        } else {
          Get.snackbar('Lỗi', 'Mã giảm giá/bảo hiểm không tồn tại hoặc đã hết hạn.');
        }
      }
    } catch (e) {
      // Mockup fallbacks
    }
  }

  void resetDiscount(double baseAmount) {
    appliedVoucherCode.value = '';
    discountPercent.value = 0.0;
    discountAmount.value = 0.0;
    finalAmount.value = baseAmount;
  }

  Future<void> processPayment(String invoiceId, double amount, String method) async {
    try {
      isLoading.value = true;

      // 1. Insert payment record
      await _client.from('payments').insert({
        'invoice_id': invoiceId,
        'amount': finalAmount.value > 0 ? finalAmount.value : amount,
      });

      // 2. Update invoice status to paid
      await _client
          .from('invoices')
          .update({'status': 'paid'})
          .eq('id', invoiceId);

      Get.snackbar('Thành công', 'Thanh toán hóa đơn thành công (Hình thức: $method).');
      await loadInvoices();
    } catch (e) {
      Get.snackbar('Lỗi', 'Thanh toán thất bại: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
