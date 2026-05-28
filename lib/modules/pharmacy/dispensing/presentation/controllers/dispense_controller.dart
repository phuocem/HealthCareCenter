import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DispenseController extends GetxController {
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  final prescriptions = <Map<String, dynamic>>[].obs;
  
  final readyPrescriptions = <Map<String, dynamic>>[].obs;
  final dispensedPrescriptions = <Map<String, dynamic>>[].obs;
  
  // Local state to track dispensed prescriptions during session
  final dispensedIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadPrescriptions();
  }

  Future<void> loadPrescriptions() async {
    try {
      isLoading.value = true;

      // Fetch prescriptions with clinical and patient details
      final data = await _client
          .from('prescriptions')
          .select('*, prescription_items(*, inventory_items(*)), medical_records(*, user_profiles(*), appointments(*, invoices(*)))');

      if (data != null) {
        final list = List<Map<String, dynamic>>.from(data);
        prescriptions.assignAll(list);
        
        _filterPrescriptions();
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách đơn thuốc: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _filterPrescriptions() {
    final readyList = <Map<String, dynamic>>[];
    final dispensedList = <Map<String, dynamic>>[];

    for (final pres in prescriptions) {
      final id = pres['id'].toString();
      
      // Check if invoice is paid
      final record = pres['medical_records'] as Map?;
      final apt = record != null ? record['appointments'] as Map? : null;
      final invoices = apt != null ? apt['invoices'] as List? : null;
      
      bool isPaid = false;
      if (invoices != null && invoices.isNotEmpty) {
        // Since invoices could be a list or a single map depending on join, let's handle both
        final inv = invoices.first as Map;
        isPaid = inv['status'] == 'paid';
      }

      if (dispensedIds.contains(id)) {
        dispensedList.add({
          ...pres,
          'is_paid': isPaid,
        });
      } else {
        readyList.add({
          ...pres,
          'is_paid': isPaid,
        });
      }
    }

    readyPrescriptions.assignAll(readyList);
    dispensedPrescriptions.assignAll(dispensedList);
  }

  Future<void> dispensePrescription(String prescriptionId) async {
    try {
      isLoading.value = true;

      // 1. Fetch prescription items
      final items = await _client
          .from('prescription_items')
          .select('*, inventory_items(*)')
          .eq('prescription_id', prescriptionId);

      if (items != null) {
        final itemList = List<Map<String, dynamic>>.from(items);

        // 2. Process each item (inventory deduction & stock transaction)
        for (final item in itemList) {
          final itemId = item['item_id'];
          final reqQty = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;

          // Find inventory batches for this item
          final batches = await _client
              .from('inventory_batches')
              .select('*')
              .eq('item_id', itemId)
              .order('expiry_date', ascending: true);

          if (batches != null && batches.isNotEmpty) {
            // Deduct from the first batch
            final firstBatch = batches.first as Map;
            final batchId = firstBatch['id'];
            final currentQty = int.tryParse(firstBatch['quantity']?.toString() ?? '0') ?? 0;
            final newQty = (currentQty - reqQty).clamp(0, 999999);

            await _client
                .from('inventory_batches')
                .update({'quantity': newQty})
                .eq('id', batchId);
          }

          // Insert stock transaction
          await _client.from('stock_transactions').insert({
            'item_id': itemId,
            'type': 'sale',
            'quantity': reqQty,
          });
        }
      }

      // Mark as dispensed locally
      dispensedIds.add(prescriptionId);
      Get.snackbar('Thành công', 'Đã cấp phát thuốc thành công.');
      
      // Refresh list
      _filterPrescriptions();
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cấp phát thuốc: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
