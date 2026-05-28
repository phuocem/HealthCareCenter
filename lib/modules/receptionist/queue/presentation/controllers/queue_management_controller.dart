import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QueueManagementController extends GetxController {
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  final queueList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadQueue();
  }

  Future<void> loadQueue() async {
    try {
      isLoading.value = true;
      
      // Load clinic queue joined with appointments and patients info
      final response = await _client
          .from('clinic_queues')
          .select('id, queue_number, status, appointment_id, appointments(reason, patient_id, user_profiles(full_name))')
          .order('queue_number', ascending: true);

      if (response != null) {
        queueList.assignAll(List<Map<String, dynamic>>.from(response));
      }
    } catch (e) {
      // Fallback
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> callNext(String queueId) async {
    try {
      await _client
          .from('clinic_queues')
          .update({'status': 'calling'})
          .eq('id', queueId);
      
      loadQueue();
      Get.snackbar('Thành công', 'Đang gọi bệnh nhân tiếp theo vào phòng khám!');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể gọi số: $e');
    }
  }

  Future<void> skipPatient(String queueId) async {
    try {
      await _client
          .from('clinic_queues')
          .update({'status': 'skipped'})
          .eq('id', queueId);

      loadQueue();
      Get.snackbar('Thông báo', 'Đã đánh dấu bỏ qua bệnh nhân này.');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể bỏ qua: $e');
    }
  }

  Future<void> printSlip(Map<String, dynamic> item) async {
    final patientName = item['appointments']?['user_profiles']?['full_name'] ?? 'Bệnh nhân';
    final number = item['queue_number'] ?? 0;
    
    Get.dialog(
      GetDialogForSlip(patientName: patientName, number: number),
    );
  }
}

// We define a simple custom view for printing dialog
class GetDialogForSlip extends StatelessWidget {
  final String patientName;
  final int number;

  const GetDialogForSlip({super.key, required this.patientName, required this.number});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0F1626),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.print_rounded, color: Color(0xFF38BDF8), size: 40),
          const SizedBox(height: 16),
          const Text(
            'MÔ PHỎNG IN PHIẾU KHÁM BỆNH',
            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'PHÒNG KHÁM ĐA KHOA HEALTHX',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                ),
                const SizedBox(height: 6),
                const Text(
                  '--- PHIẾU SỐ THỨ TỰ ---',
                  style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 14),
                Text(
                  '#$number',
                  style: const TextStyle(color: Color(0xFF0284C7), fontSize: 36, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bệnh nhân: $patientName',
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w800, fontSize: 12),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Vui lòng chờ gọi số tại sảnh phòng khám',
                  style: TextStyle(color: Colors.black45, fontSize: 8, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('ĐÓNG', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar('In ấn', 'Phiếu khám đang được in trên máy in nhiệt sảnh sảnh chờ.');
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
                child: const Text('IN NGAY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
