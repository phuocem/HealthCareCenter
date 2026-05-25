import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/booking_repository.dart';
import '../../../../../core/routes/app_routes.dart';

class BookingController extends GetxController {
  final _repository = BookingRepository();
  final _client = Supabase.instance.client;

  final isLoading = false.obs;
  final doctors = <Map<String, dynamic>>[].obs;
  final selectedDoctor = Rxn<Map<String, dynamic>>();
  final selectedDate = Rxn<DateTime>();
  final selectedSlot = Rxn<Map<String, dynamic>>();
  final availableSlots = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      isLoading.value = true;
      final data = await _repository.getDoctors();
      doctors.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load doctors');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSlots(String doctorId, DateTime date) async {
    try {
      isLoading.value = true;
      final dayOfWeek = date.weekday % 7;
      final data = await _repository.getSchedules(doctorId, dayOfWeek);
      availableSlots.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load slots');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmBooking() async {
    try {
      if (selectedDoctor.value == null || selectedDate.value == null || selectedSlot.value == null) return;
      isLoading.value = true;
      
      final userId = _client.auth.currentUser?.id;
      final data = {
        'patient_id': userId,
        'doctor_id': selectedDoctor.value!['id'],
        'appointment_date': selectedDate.value!.toIso8601String().split('T')[0],
        'start_time': selectedSlot.value!['start_time'],
        'status': 'pending',
        'final_price': selectedDoctor.value!['consultation_fee'],
      };

      await _repository.bookAppointment(data);
      Get.offAllNamed(Routes.PATIENT_HOME);
      Get.snackbar('Success', 'Appointment booked successfully');
    } catch (e) {
      Get.snackbar('Error', 'Booking failed: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
