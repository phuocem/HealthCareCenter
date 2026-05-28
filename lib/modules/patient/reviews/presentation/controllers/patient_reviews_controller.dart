import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientReviewsController extends GetxController {
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final doctors = <Map<String, dynamic>>[].obs;
  
  // Rating form state
  final selectedDoctorId = ''.obs;
  final rating = 5.obs;
  final comment = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      isLoading.value = true;
      // Fetch doctors list for selection
      final response = await _client.from('doctors').select('id, user_profiles(full_name, avatar_url), departments(name)');
      if (response != null) {
        final list = List<Map<String, dynamic>>.from(response);
        doctors.assignAll(list);
        if (list.isNotEmpty) {
          selectedDoctorId.value = list.first['id'].toString();
        }
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách bác sĩ');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitReview() async {
    if (selectedDoctorId.value.isEmpty) {
      Get.snackbar('Thông báo', 'Vui lòng chọn bác sĩ để đánh giá');
      return;
    }
    if (comment.value.trim().isEmpty) {
      Get.snackbar('Thông báo', 'Vui lòng nhập nhận xét chi tiết');
      return;
    }

    try {
      isSubmitting.value = true;
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      // Insert review
      await _client.from('doctor_reviews').insert({
        'patient_id': userId,
        'doctor_id': selectedDoctorId.value,
        'rating': rating.value,
        'comment': comment.value.trim(),
      });

      Get.snackbar('Thành công', 'Cảm ơn bạn đã gửi đánh giá cho bác sĩ!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFF10B981).withValues(alpha: 0.1),
          colorText: const Color(0xFF10B981));

      // Reset form
      comment.value = '';
      rating.value = 5;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể gửi đánh giá: $e');
    } finally {
      isSubmitting.value = false;
    }
  }
}
