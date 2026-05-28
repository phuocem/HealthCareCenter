import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/upload_docs_controller.dart';

class UploadDocsView extends GetView<UploadDocsController> {
  const UploadDocsView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameTextController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      body: Stack(
        children: [
          // Decorative blobs
          Positioned(
            top: -60,
            right: -60,
            width: 260,
            height: 260,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x2238BDF8),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            width: 220,
            height: 220,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x14F43F5E),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF0284C7)));
                    }

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderInstruction(),
                          const SizedBox(height: 24),
                          const Text(
                            'TÊN HỒ SƠ / TÀI LIỆU',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildNameInput(nameTextController),
                          const SizedBox(height: 20),
                          const Text(
                            'LOẠI HỒ SƠ Y TẾ',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildTypeSelector(),
                          const SizedBox(height: 24),
                          _buildImagePickerArea(context),
                          const SizedBox(height: 28),
                          _buildSubmitButton(nameTextController),
                          const SizedBox(height: 36),
                          const Text(
                            'HỒ SƠ ĐÃ TẢI LÊN',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildAttachmentsList(),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withOpacity(0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF475569), size: 16),
              onPressed: () => Get.back(),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'HỒ SƠ LÂM SÀNG CŨ',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInstruction() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.drive_folder_upload_rounded,
                color: Color(0xFF0284C7), size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tải lên hồ sơ bệnh án cũ',
                  style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 14,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  'Cung cấp hình ảnh X-Quang, MRI hoặc hồ sơ bệnh nền cũ để bác sĩ chẩn đoán chính xác hơn.',
                  style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput(TextEditingController textController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          hintText: 'Nhập tên hồ sơ (Ví dụ: Kết quả X-quang phổi 2025)',
          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        onChanged: (val) => controller.docName.value = val,
      ),
    );
  }

  Widget _buildTypeSelector() {
    final types = [
      {'val': 'pdf', 'label': 'Tài liệu PDF'},
      {'val': 'xray', 'label': 'Ảnh X-Quang'},
      {'val': 'mri', 'label': 'Kết quả chụp MRI'},
      {'val': 'patient_doc', 'label': 'Hồ sơ y tế khác'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.docType.value,
          dropdownColor: Colors.white,
          isExpanded: true,
          items: types.map((t) {
            return DropdownMenuItem<String>(
              value: t['val'],
              child: Text(
                t['label']!,
                style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w800,
                    fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              controller.docType.value = val;
            }
          },
        ),
      ),
    );
  }

  Widget _buildImagePickerArea(BuildContext context) {
    final imagePath = controller.selectedImagePath.value;

    return GestureDetector(
      onTap: () => _showPickerOptions(context),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        ),
        child: imagePath.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withOpacity(0.06),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_photo_alternate_rounded,
                        color: Color(0xFF0284C7), size: 30),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Chọn ảnh hồ sơ hoặc chụp từ camera',
                    style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  void _showPickerOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'TẢI LÊN HÌNH ẢNH HỒ SƠ',
              style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 0.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildPickerMethodButton(
                    Icons.camera_alt_rounded,
                    'Chụp từ Camera',
                    () {
                      Get.back();
                      controller.pickImage(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPickerMethodButton(
                    Icons.photo_library_rounded,
                    'Chọn từ Thư viện',
                    () {
                      Get.back();
                      controller.pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerMethodButton(
      IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0284C7).withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF0284C7), size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(TextEditingController textController) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0284C7).withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.isUploading.value
              ? null
              : () {
                  controller.uploadDocument().then((_) {
                    textController.clear();
                  });
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0284C7),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 58),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          child: controller.isUploading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'TẢI TÀI LIỆU LÊN HỆ THỐNG',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5),
                ),
        ),
      );
    });
  }

  Widget _buildAttachmentsList() {
    if (controller.attachments.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
        ),
        child: const Center(
          child: Text(
            'Chưa có tài liệu lâm sàng cũ nào được tải lên.',
            style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.attachments.length,
      itemBuilder: (context, index) {
        final doc = controller.attachments[index];
        final typeLabel = doc['file_type'].toString().toUpperCase();

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.02),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.article_rounded,
                    color: Color(0xFF8B5CF6), size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc['file_name'],
                      style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w800,
                          fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        typeLabel,
                        style: const TextStyle(
                            color: Color(0xFF8B5CF6),
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFEF4444), size: 20),
                onPressed: () => controller.deleteAttachment(doc['id']),
              ),
            ],
          ),
        );
      },
    );
  }
}
