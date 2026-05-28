import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/user_management_repository.dart';

class UserManagementController extends GetxController {
  final _repository = UserManagementRepository();
  
  final isLoading = false.obs;
  final doctors = <Map<String, dynamic>>[].obs;
  final staff = <Map<String, dynamic>>[].obs;
  final departments = <Map<String, dynamic>>[].obs;
  final services = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final results = await Future.wait<dynamic>([
        _repository.getDoctors(),
        _repository.getStaff(),
        _repository.getDepartments(),
        _repository.getServices(),
      ]);
      doctors.assignAll(List<Map<String, dynamic>>.from(results[0]));
      staff.assignAll(List<Map<String, dynamic>>.from(results[1]));
      departments.assignAll(List<Map<String, dynamic>>.from(results[2]));
      services.assignAll(List<Map<String, dynamic>>.from(results[3]));
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDoctor({
    required String fullName,
    required String email,
    required String password,
    required String departmentId,
    required String licenseNumber,
    required double consultationFee,
    required int experienceYears,
    required List<int> workingDays,
    required List<Map<String, String>> slots,
    String? phone,
    String? qualification,
    String? school,
    String? specialization,
    String? certificates,
    String? clinicalFocus,
    String? emergencyRelativeName,
    String? emergencyRelativePhone,
  }) async {
    try {
      isLoading.value = true;
      
      final data = {
        'profile': {
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'role': 'doctor',
        },
        'doctor': {
          'department_id': departmentId,
          'license_number': licenseNumber,
          'consultation_fee': consultationFee,
          'experience_years': experienceYears,
          'qualification': qualification,
          'school': school,
          'specialization': specialization,
          'certificates': certificates,
          'clinical_focus': clinicalFocus,
          'emergency_relative_name': emergencyRelativeName,
          'emergency_relative_phone': emergencyRelativePhone,
          'personal_phone': phone,
        }
      };

      
      final profileId = await _repository.createDoctor(data, email, password);

      
      for (final day in workingDays) {
        for (final slot in slots) {
          final start = slot['start']!;
          final end = slot['end']!;
          final scheduleData = {
            'doctor_id': profileId,
            'day_of_week': day,
            'start_time': start.length == 5 ? '$start:00' : start,
            'end_time': end.length == 5 ? '$end:00' : end,
          };
          await _repository.addDoctorSchedule(scheduleData);
        }
      }

      await loadData();
      Get.close(2); 
      Get.snackbar('Thành công', 'Đã tạo tài khoản bác sĩ $fullName và thiết lập lịch khám thành công!');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tạo bác sĩ: $e');
    } finally {
      isLoading.value = false;
    }
  }
  final schedules = <Map<String, dynamic>>[].obs;
  final selectedDay = 1.obs; 

  Future<void> loadSchedules(String doctorId) async {
    try {
      isLoading.value = true;
      final results = await _repository.getSchedules(doctorId);
      schedules.assignAll(results);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải lịch khám: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveSchedule({
    required String doctorId,
    required int dayOfWeek,
    required String startTime,
    required String endTime,
  }) async {
    try {
      isLoading.value = true;
      final data = {
        'doctor_id': doctorId,
        'day_of_week': dayOfWeek,
        'start_time': startTime,
        'end_time': endTime,
      };
      await _repository.addDoctorSchedule(data);
      await loadSchedules(doctorId);
      Get.back();
      Get.snackbar('Thành công', 'Đã lưu khung giờ mới');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lưu lịch: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSchedule(String id, String doctorId) async {
    try {
      await _repository.deleteSchedule(id);
      await loadSchedules(doctorId);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể xóa: $e');
    }
  }

  Future<void> addStaff({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
  }) async {
    try {
      isLoading.value = true;
      await _repository.createStaff(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
        phone: phone,
      );
      await loadData();
      Get.back(); // đóng bottom sheet
      Get.snackbar(
        'Thành công ✓',
        'Đã tạo tài khoản cho $fullName ($role)',
        backgroundColor: const Color(0xFF34D399),
        colorText: const Color(0xFF0F172A),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tạo tài khoản: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteStaff(String id, String name) async {
    try {
      await _repository.deleteStaff(id);
      await loadData();
      Get.snackbar('Đã xóa', 'Đã xóa tài khoản $name');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể xóa: $e');
    }
  }
}

class Guid {
  static String newGuid() {
    final random = Random();
    String hex(int length) {
      final buffer = StringBuffer();
      for (var i = 0; i < length; i++) {
        buffer.write(random.nextInt(16).toRadixString(16));
      }
      return buffer.toString();
    }
    return '${hex(8)}-${hex(4)}-${hex(4)}-${hex(4)}-${hex(12)}';
  }
}
