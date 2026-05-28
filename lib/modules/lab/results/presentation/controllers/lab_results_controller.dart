import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class LabResultsController extends GetxController {
  final _client = Supabase.instance.client;
  final _picker = ImagePicker();

  final isLoading = false.obs;
  late final String requestId;
  
  final patientName = ''.obs;
  final requestDate = ''.obs;
  
  final requestItems = <Map<String, dynamic>>[].obs;
  
  // Input tracking
  final resultValues = <String, String>{}.obs; // request_item_id -> value
  final isAbnormal = <String, bool>{}.obs;     // request_item_id -> bool

  // Advanced features state
  final samplingState = 'waiting_sample'.obs; // 'waiting_sample', 'processing', 'completed'
  final attachedFilePath = ''.obs;
  final isUrgent = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['requestId'] != null) {
      requestId = args['requestId'];
      loadRequestDetails();
    } else {
      Get.back();
      Get.snackbar('Lỗi', 'Không tìm thấy thông tin yêu cầu xét nghiệm.');
    }
  }

  Future<void> loadRequestDetails() async {
    try {
      isLoading.value = true;

      // Fetch request details
      final reqData = await _client
          .from('lab_requests')
          .select('*, medical_records(*, user_profiles(*))')
          .eq('id', requestId)
          .maybeSingle();

      if (reqData != null) {
        final record = reqData['medical_records'] as Map?;
        if (record != null) {
          final patient = record['user_profiles'] as Map?;
          if (patient != null) {
            patientName.value = patient['full_name'] ?? 'Bệnh nhân';
          }
          requestDate.value = record['created_at'] != null 
              ? record['created_at'].toString().substring(0, 10) 
              : '';
        }
        
        // Match status from DB to local samplingState
        final dbStatus = reqData['status']?.toString() ?? 'pending';
        if (dbStatus == 'completed') {
          samplingState.value = 'completed';
        } else if (dbStatus == 'processing') {
          samplingState.value = 'processing';
        } else {
          samplingState.value = 'waiting_sample';
        }
      }

      // Fetch requested items with test type details
      final items = await _client
          .from('lab_request_items')
          .select('*, lab_test_types(*)')
          .eq('request_id', requestId);

      if (items != null) {
        requestItems.assignAll(List<Map<String, dynamic>>.from(items));
        
        // Initialize inputs
        for (final item in requestItems) {
          final id = item['id'].toString();
          resultValues[id] = '';
          isAbnormal[id] = false;
        }
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải thông tin yêu cầu: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAttachment() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (file != null) {
        attachedFilePath.value = file.path;
        Get.snackbar('Tài liệu', 'Đã đính kèm tệp: ${file.name}');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể chọn tệp đính kèm: $e');
    }
  }

  Future<void> submitResults() async {
    // Validate that all fields have some values
    for (final item in requestItems) {
      final id = item['id'].toString();
      if (resultValues[id] == null || resultValues[id]!.trim().isEmpty) {
        Get.snackbar('Yêu cầu', 'Vui lòng nhập đầy đủ kết quả xét nghiệm.');
        return;
      }
    }

    try {
      isLoading.value = true;

      // 1. Insert results for each item
      for (final item in requestItems) {
        final id = item['id'].toString();
        await _client.from('lab_results').insert({
          'request_item_id': id,
          'result_value': resultValues[id],
          'is_abnormal': isAbnormal[id] ?? false,
        });
      }

      // 2. If an attachment is attached, we can link/simulate saving it
      if (attachedFilePath.value.isNotEmpty) {
        // Mock inserting to medical_attachments
        final userId = _client.auth.currentUser?.id;
        await _client.from('medical_attachments').insert({
          'patient_id': userId ?? '00000000-0000-0000-0000-000000000000',
          'file_name': 'Kết quả Lab đính kèm (${requestDate.value})',
          'file_url': 'https://picsum.photos/800/1200', // Mock URL
          'file_type': 'pdf',
        });
      }

      // 3. Update request status based on sampling state
      String finalStatus = 'completed';
      if (samplingState.value == 'waiting_sample') {
        finalStatus = 'pending';
      } else if (samplingState.value == 'processing') {
        finalStatus = 'processing';
      }

      await _client
          .from('lab_requests')
          .update({
            'status': finalStatus,
            'is_urgent': isUrgent.value // Save urgency tag to DB
          })
          .eq('id', requestId);

      Get.snackbar('Thành công', 'Đã lưu và gửi kết quả xét nghiệm.');
      Get.back();
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể lưu kết quả: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
