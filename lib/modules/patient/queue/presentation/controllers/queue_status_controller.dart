import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QueueStatusController extends GetxController {
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  
  // Realtime state
  final currentNumber = 12.obs; // Mock current calling number
  final patientNumber = 18.obs; // Mock patient number
  final waitingTimeMin = 30.obs; // Waiting time in minutes
  final doctorName = 'Bác sĩ Lê Hoàng Nam'.obs;
  final clinicRoom = 'Phòng khám 102 - Tầng 1'.obs;
  
  // State transitions:
  // 'waiting_confirm' -> 'waiting_exam' -> 'testing' -> 'waiting_result' -> 'prescribed' -> 'waiting_pay' -> 'completed'
  final activeStatus = 'waiting_exam'.obs;

  @override
  void onInit() {
    super.onInit();
    loadQueueStatus();
    // In production we would listen to realtime changes on 'clinic_queues' using supabase channel
  }

  Future<void> loadQueueStatus() async {
    try {
      isLoading.value = true;
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      // Try fetching patient's active appointment
      final response = await _client
          .from('appointments')
          .select('id, status, appointment_date, doctors(user_profiles(full_name)), reason')
          .eq('patient_id', userId)
          .order('appointment_date', ascending: false)
          .limit(1);

      if (response != null && response.isNotEmpty) {
        final apt = response.first;
        final doc = apt['doctors'];
        if (doc != null && doc['user_profiles'] != null) {
          doctorName.value = doc['user_profiles']['full_name'].toString();
        }
        
        // Match standard statuses
        final dbStatus = apt['status'].toString().toLowerCase();
        if (dbStatus == 'completed') {
          activeStatus.value = 'completed';
        } else if (dbStatus == 'cancelled') {
          activeStatus.value = 'waiting_confirm';
        } else {
          // Let's load the clinic_queues if available
          final queueResponse = await _client
              .from('clinic_queues')
              .select('queue_number, status')
              .eq('appointment_id', apt['id'])
              .limit(1);

          if (queueResponse != null && queueResponse.isNotEmpty) {
            patientNumber.value = int.tryParse(queueResponse.first['queue_number'].toString()) ?? 18;
            final qStatus = queueResponse.first['status'].toString();
            if (qStatus == 'calling') {
              activeStatus.value = 'waiting_exam';
              currentNumber.value = patientNumber.value;
              waitingTimeMin.value = 0;
            } else if (qStatus == 'completed') {
              activeStatus.value = 'completed';
            }
          }
        }
      }
    } catch (e) {
      // Gracefully fall back to premium mock numbers
    } finally {
      isLoading.value = false;
    }
  }

  void simulateQueueUpdate() {
    if (currentNumber.value < patientNumber.value) {
      currentNumber.value += 1;
      waitingTimeMin.value = (patientNumber.value - currentNumber.value) * 5;
    } else if (currentNumber.value == patientNumber.value) {
      waitingTimeMin.value = 0;
    }
  }
}
