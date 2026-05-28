import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../../../../core/routes/app_routes.dart';

class DashboardController extends GetxController {
  final _repository = DashboardRepository();
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  final userName = 'Bệnh nhân'.obs;
  final userProfile = <String, dynamic>{}.obs;
  final doctors = <Map<String, dynamic>>[].obs;
  final upcomingAppointment = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;
      
      final results = await Future.wait([
        _repository.getProfile(userId),
        _repository.getDoctors(),
        _repository.getUpcomingAppointments(userId),
      ]);

      final profileMap = results[0] as Map<String, dynamic>;
      final enrichedProfile = Map<String, dynamic>.from(profileMap);
      enrichedProfile['phone_number'] = profileMap['phone'] ?? '0912 345 678';
      enrichedProfile['health_card_number'] = profileMap['health_card_number'] ?? 'GD479152031102';
      enrichedProfile['dob'] = profileMap['dob'] ?? '18/06/1992';
      enrichedProfile['gender'] = profileMap['gender'] ?? 'Nam';
      enrichedProfile['blood_type'] = profileMap['blood_type'] ?? 'O+';
      enrichedProfile['height'] = profileMap['height'] ?? '175 cm';
      enrichedProfile['weight'] = profileMap['weight'] ?? '68 kg';
      enrichedProfile['emergency_name'] = profileMap['emergency_name'] ?? 'Nguyễn Thị Lan';
      enrichedProfile['emergency_phone'] = profileMap['emergency_phone'] ?? '0987 654 321';
      enrichedProfile['emergency_relation'] = profileMap['emergency_relation'] ?? 'Vợ (Spouse)';
      enrichedProfile['address'] = profileMap['address'] ?? '123 Đường Cách Mạng Tháng 8, Quận 3, TP. Hồ Chí Minh';
      enrichedProfile['allergies'] = profileMap['allergies'] ?? 'Không dị ứng thuốc';
      enrichedProfile['insurance_provider'] = profileMap['insurance_provider'] ?? 'Bảo hiểm Xã hội TP.HCM';
      enrichedProfile['insurance_expiry'] = profileMap['insurance_expiry'] ?? '31/12/2028';
      enrichedProfile['national_id'] = profileMap['national_id'] ?? '079092008765';
      enrichedProfile['medical_history'] = profileMap['medical_history'] ?? 'Tiền sử tăng huyết áp nhẹ từ năm 2024';
      
      userProfile.value = enrichedProfile;
      userName.value = profileMap['full_name'] ?? 'Bệnh nhân';
      
      doctors.assignAll(results[1] as List<Map<String, dynamic>>);
      final appointments = results[2] as List<Map<String, dynamic>>;
      if (appointments.isNotEmpty) {
        upcomingAppointment.value = appointments.first;
      }
    } catch (e) {
      print('Dashboard error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // AI Symptom Advisor State
  final aiSymptomsInput = ''.obs;
  final aiSymptomResult = Rxn<Map<String, dynamic>>();
  final isAiLoading = false.obs;

  void analyzeSymptoms(String symptoms) {
    if (symptoms.trim().isEmpty) return;
    isAiLoading.value = true;
    
    // Simulate AI processing delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      final query = symptoms.toLowerCase();
      String specialty = 'Khám tổng quát';
      String recommendation = 'Vui lòng khám khoa tổng quát để bác sĩ khám toàn diện.';
      
      if (query.contains('tim') || query.contains('ngực') || query.contains('hồi hộp')) {
        specialty = 'Tim mạch';
        recommendation = 'Triệu chứng của bạn liên quan đến tim mạch. Đề xuất khám khoa Tim Mạch.';
      } else if (query.contains('nhi') || query.contains('bé') || query.contains('trẻ em') || query.contains('sốt')) {
        specialty = 'Nhi khoa';
        recommendation = 'Triệu chứng của trẻ nhỏ. Đề xuất khám khoa Nhi khoa.';
      } else if (query.contains('da') || query.contains('ngứa') || query.contains('mụn') || query.contains('dị ứng')) {
        specialty = 'Da liễu';
        recommendation = 'Triệu chứng dị ứng hoặc ngoài da. Đề xuất khám khoa Da liễu.';
      }
      
      // Find a doctor matching this specialty
      final matchingDoc = doctors.firstWhere(
        (doc) => doc['departments']?['name']?.toString().toLowerCase().contains(specialty.toLowerCase()) ?? false,
        orElse: () => doctors.isNotEmpty ? doctors.first : <String, dynamic>{},
      );

      aiSymptomResult.value = {
        'specialty': specialty,
        'recommendation': recommendation,
        'doctor': matchingDoc.isNotEmpty ? matchingDoc : null,
      };
      isAiLoading.value = false;
    });
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('Logout error: $e');
    }
  }
}
