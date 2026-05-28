import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WalkinBookingController extends GetxController {
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  
  // Available doctors and patients
  final doctors = <Map<String, dynamic>>[].obs;
  final patients = <Map<String, dynamic>>[].obs;

  // Form Fields
  final selectedDoctorId = ''.obs;
  final selectedPatientId = ''.obs;
  
  // Walkin custom patient details (if not registered in system)
  final walkinName = ''.obs;
  final walkinPhone = ''.obs;
  final walkinReason = 'Khám tổng quát'.obs;

  @override
  void onInit() {
    super.onInit();
    loadFormLists();
  }

  Future<void> loadFormLists() async {
    try {
      isLoading.value = true;
      
      // Load active doctors
      final docsResponse = await _client
          .from('doctors')
          .select('id, user_profiles(full_name), departments(name)');
      if (docsResponse != null) {
        doctors.assignAll(List<Map<String, dynamic>>.from(docsResponse));
        if (doctors.isNotEmpty) {
          selectedDoctorId.value = doctors.first['id'].toString();
        }
      }

      // Load patient profiles for linking
      final patientsResponse = await _client
          .from('user_profiles')
          .select('id, full_name, phone_number')
          .eq('role', 'patient');
      if (patientsResponse != null) {
        patients.assignAll(List<Map<String, dynamic>>.from(patientsResponse));
      }
    } catch (e) {
      // Graceful error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createWalkinBooking() async {
    // Validate
    if (selectedDoctorId.value.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng chọn bác sĩ chỉ định');
      return;
    }

    String patientId = selectedPatientId.value;
    String name = walkinName.value.trim();
    String phone = walkinPhone.value.trim();

    if (patientId.isEmpty && name.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng chọn bệnh nhân đã đăng ký hoặc điền tên khách vãng lai');
      return;
    }

    try {
      isSubmitting.value = true;

      // 1. If customer is a new walkin, let's create a temp/guest user_profile or use guest ID
      if (patientId.isEmpty) {
        // Create standard user profile in user_profiles
        // In this architecture, let's look up or link a generic Guest patient or create it:
        final guestEmail = 'walkin_${DateTime.now().millisecondsSinceEpoch}@healthx.com';
        
        final newProfile = await _client.from('user_profiles').insert({
          'full_name': name,
          'phone_number': phone.isEmpty ? '0900000000' : phone,
          'email': guestEmail,
          'role': 'patient'
        }).select();

        if (newProfile != null && newProfile.isNotEmpty) {
          patientId = newProfile.first['id'];
        } else {
          throw Exception("Could not create patient profile");
        }
      }

      // 2. Create appointment
      final newApp = await _client.from('appointments').insert({
        'patient_id': patientId,
        'doctor_id': selectedDoctorId.value,
        'appointment_date': DateTime.now().toIso8601String().split('T').first,
        'start_time': '09:00:00', // Default immediate walkin slot
        'end_time': '09:30:00',
        'status': 'pending', // Pending exam
        'reason': walkinReason.value,
      }).select();

      if (newApp != null && newApp.isNotEmpty) {
        final appId = newApp.first['id'];
        
        // 3. Auto-allocate queue number
        final queueCount = await _client.from('clinic_queues').select('id');
        final nextNum = (queueCount != null ? queueCount.length : 0) + 1;

        await _client.from('clinic_queues').insert({
          'appointment_id': appId,
          'queue_number': nextNum,
          'status': 'waiting'
        });

        Get.snackbar('Thành công', 'Đăng ký lượt khám thành công! Số thứ tự xếp hàng: #$nextNum',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.1),
            colorText: const Color(0xFF10B981));
        
        // Reset fields
        walkinName.value = '';
        walkinPhone.value = '';
        selectedPatientId.value = '';
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tạo lịch khám vãng lai: $e');
    } finally {
      isSubmitting.value = false;
    }
  }
}
