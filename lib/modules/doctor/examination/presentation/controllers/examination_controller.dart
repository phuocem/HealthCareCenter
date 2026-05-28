import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/routes/app_routes.dart';

class ExaminationController extends GetxController {
  final _client = Supabase.instance.client;
  
  final isLoading = false.obs;
  
  // Appointment and Patient Details
  late final String appointmentId;
  final appointment = Rxn<Map<String, dynamic>>();
  final patientName = ''.obs;
  final patientEmail = ''.obs;
  final patientId = ''.obs;
  final doctorId = ''.obs;
  final servicePrice = 0.0.obs;
  final doctorConsultationFee = 0.0.obs;

  // Form Fields
  final diagnosis = ''.obs;
  final notes = ''.obs;
  final weight = ''.obs;
  final heartRate = ''.obs;
  final temperature = ''.obs;

  // Lab Tests
  final labTestTypes = <Map<String, dynamic>>[].obs;
  final selectedLabTests = <Map<String, dynamic>>[].obs;

  // Prescriptions
  final inventoryItems = <Map<String, dynamic>>[].obs;
  final selectedMedicine = Rxn<Map<String, dynamic>>();
  final medicineQuantity = 1.obs;
  final prescriptionItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['appointmentId'] != null) {
      appointmentId = args['appointmentId'];
      loadData();
    } else {
      Get.back();
      Get.snackbar('Lỗi', 'Không tìm thấy thông tin lịch hẹn.');
    }
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      
      // Load Appointment details
      final aptData = await _client
          .from('appointments')
          .select('*, user_profiles!appointments_patient_id_fkey(*), services(*), doctors(*)')
          .eq('id', appointmentId)
          .maybeSingle();

      if (aptData != null) {
        appointment.value = aptData;
        patientId.value = aptData['patient_id'] ?? '';
        doctorId.value = aptData['doctor_id'] ?? '';
        
        final patientProfile = aptData['user_profiles'] as Map?;
        if (patientProfile != null) {
          patientName.value = patientProfile['full_name'] ?? 'Bệnh nhân';
          patientEmail.value = patientProfile['email'] ?? '';
        }

        final serviceData = aptData['services'] as Map?;
        if (serviceData != null) {
          servicePrice.value = double.tryParse(serviceData['base_price']?.toString() ?? '0') ?? 0.0;
        }

        final doctorData = aptData['doctors'] as Map?;
        if (doctorData != null) {
          doctorConsultationFee.value = double.tryParse(doctorData['consultation_fee']?.toString() ?? '0') ?? 0.0;
        }
      }

      // Load Lab Test Types
      final tests = await _client.from('lab_test_types').select('*');
      labTestTypes.assignAll(List<Map<String, dynamic>>.from(tests));

      // Load Medicines (inventory_items)
      final items = await _client.from('inventory_items').select('*');
      inventoryItems.assignAll(List<Map<String, dynamic>>.from(items));
      if (inventoryItems.isNotEmpty) {
        selectedMedicine.value = inventoryItems.first;
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải thông tin khám: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleLabTest(Map<String, dynamic> test) {
    if (selectedLabTests.any((element) => element['id'] == test['id'])) {
      selectedLabTests.removeWhere((element) => element['id'] == test['id']);
    } else {
      selectedLabTests.add(test);
    }
  }

  void addMedicine() {
    if (selectedMedicine.value == null) return;
    final item = selectedMedicine.value!;
    
    // Check if already added
    if (prescriptionItems.any((element) => element['id'] == item['id'])) {
      Get.snackbar('Thông báo', 'Thuốc này đã được thêm vào đơn.');
      return;
    }

    prescriptionItems.add({
      'id': item['id'],
      'name': item['name'],
      'quantity': medicineQuantity.value,
    });
    
    // Reset quantity
    medicineQuantity.value = 1;
  }

  void removeMedicine(int index) {
    prescriptionItems.removeAt(index);
  }

  Future<void> finalizeExamination() async {
    if (diagnosis.value.trim().isEmpty) {
      Get.snackbar('Yêu cầu', 'Vui lòng nhập chẩn đoán lâm sàng.');
      return;
    }

    try {
      isLoading.value = true;

      // 1. Create medical record
      final fullDiagnosis = notes.value.trim().isNotEmpty
          ? '${diagnosis.value.trim()}\n\nGhi chú: ${notes.value.trim()}'
          : diagnosis.value.trim();

      final record = await _client.from('medical_records').insert({
        'appointment_id': appointmentId,
        'patient_id': patientId.value,
        'doctor_id': doctorId.value,
        'diagnosis': fullDiagnosis,
      }).select().single();

      final recordId = record['id'];

      // 2. Create vital signs if provided
      final w = double.tryParse(weight.value);
      final hr = int.tryParse(heartRate.value);
      final t = double.tryParse(temperature.value);

      if (w != null || hr != null || t != null) {
        await _client.from('medical_vitals').insert({
          'record_id': recordId,
          'weight_kg': w,
          'heart_rate': hr,
          'temperature': t,
        });
      }

      // 3. Create lab requests if selected
      if (selectedLabTests.isNotEmpty) {
        final labReq = await _client.from('lab_requests').insert({
          'record_id': recordId,
          'status': 'pending',
        }).select().single();

        final labReqId = labReq['id'];

        for (final test in selectedLabTests) {
          await _client.from('lab_request_items').insert({
            'request_id': labReqId,
            'test_type_id': test['id'],
          });
        }
      }

      // 4. Create prescriptions if selected
      if (prescriptionItems.isNotEmpty) {
        final prescription = await _client.from('prescriptions').insert({
          'record_id': recordId,
        }).select().single();

        final presId = prescription['id'];

        for (final item in prescriptionItems) {
          await _client.from('prescription_items').insert({
            'prescription_id': presId,
            'item_id': item['id'],
            'quantity': item['quantity'],
          });
        }
      }

      // 5. Update appointment status to completed
      await _client
          .from('appointments')
          .update({'status': 'completed'})
          .eq('id', appointmentId);

      // 6. Create invoice
      // Calculation: consultation fee + service price + test type costs (let's assume 100k per lab test for simplicity)
      final labCosts = selectedLabTests.length * 100000.0;
      final medicineCosts = prescriptionItems.length * 50000.0; // Assume flat 50k per medicine for simplicity
      final totalAmount = doctorConsultationFee.value + servicePrice.value + labCosts + medicineCosts;

      final invoice = await _client.from('invoices').insert({
        'patient_id': patientId.value,
        'appointment_id': appointmentId,
        'total_amount': totalAmount,
        'status': 'unpaid',
      }).select().single();

      final invoiceId = invoice['id'];

      // Insert invoice items
      await _client.from('invoice_items').insert({
        'invoice_id': invoiceId,
        'price': doctorConsultationFee.value + servicePrice.value,
      });

      if (selectedLabTests.isNotEmpty) {
        await _client.from('invoice_items').insert({
          'invoice_id': invoiceId,
          'price': labCosts,
        });
      }

      if (prescriptionItems.isNotEmpty) {
        await _client.from('invoice_items').insert({
          'invoice_id': invoiceId,
          'price': medicineCosts,
        });
      }

      Get.snackbar('Thành công', 'Đã hoàn tất hồ sơ khám bệnh và tạo hóa đơn.');
      Get.offAllNamed(Routes.DOCTOR_HOME);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể hoàn tất hồ sơ khám: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Lỗi', 'Đăng xuất thất bại: $e');
    }
  }
}
