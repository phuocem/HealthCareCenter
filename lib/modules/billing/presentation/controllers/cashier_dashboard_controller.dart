import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/routes/app_routes.dart';

class CashierDashboardController extends GetxController {
  final _supabase = Supabase.instance.client;

  final isLoading = true.obs;
  final staffName = ''.obs;
  final todayRevenue = 0.0.obs;
  final paidCount = 0.obs;
  final pendingCount = 0.obs;
  final totalInvoices = 0.obs;
  final cashAmount = 0.0.obs;
  final transferAmount = 0.0.obs;
  final recentInvoices = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      final user = _supabase.auth.currentUser;
      if (user != null) {
        final profile = await _supabase
            .from('user_profiles')
            .select('full_name')
            .eq('id', user.id)
            .single();
        staffName.value = profile['full_name']?.toString() ?? 'Thu ngân';
      }

      final today = DateTime.now();
      final todayStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final invoicesData = await _supabase
          .from('invoices')
          .select('id, status, total_amount, payment_method, invoice_number, patients(full_name)')
          .gte('created_at', '${todayStr}T00:00:00')
          .lte('created_at', '${todayStr}T23:59:59')
          .order('created_at', ascending: false);

      final invList = List<Map<String, dynamic>>.from(invoicesData);
      totalInvoices.value = invList.length;
      paidCount.value = invList.where((i) => i['status'] == 'paid').length;
      pendingCount.value = invList.where((i) => i['status'] == 'pending').length;

      double revenue = 0;
      double cash = 0;
      double transfer = 0;
      for (final inv in invList) {
        if (inv['status'] == 'paid') {
          final amt = double.tryParse(inv['total_amount']?.toString() ?? '0') ?? 0;
          revenue += amt;
          if (inv['payment_method'] == 'cash') {
            cash += amt;
          } else {
            transfer += amt;
          }
        }
      }
      todayRevenue.value = revenue;
      cashAmount.value = cash;
      transferAmount.value = transfer;

      recentInvoices.value = invList.map((i) {
        return {
          'patient_name': i['patients']?['full_name'] ?? 'Bệnh nhân',
          'invoice_number': i['invoice_number'] ?? '',
          'total_amount': i['total_amount'] ?? '0',
          'status': i['status'] ?? '',
        };
      }).toList();
    } catch (e) {
      // ignore
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
