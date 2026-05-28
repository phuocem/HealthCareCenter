import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/walkin_booking_controller.dart';

class WalkinBookingView extends GetView<WalkinBookingController> {
  const WalkinBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameTextController = TextEditingController();
    final phoneTextController = TextEditingController();
    final reasonTextController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        title: const Text(
          'ĐĂNG KÝ KHÁCH VÃNG LAI',
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 1.5,
              color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -120,
            right: -120,
            width: 320,
            height: 320,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1038BDF8),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -150,
            width: 350,
            height: 350,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x10C084FC),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
            child: Container(color: Colors.transparent),
          ),

          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepCard(),
                    const SizedBox(height: 24),
                    const Text(
                      'BÁC SĨ CHỈ ĐỊNH KHÁM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDoctorDropdown(),
                    const SizedBox(height: 24),
                    const Text(
                      'BỆNH NHÂN ĐĂNG KÝ TRƯỚC (NẾU CÓ)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPatientDropdown(),
                    const SizedBox(height: 24),
                    const Text(
                      'HOẶC THÔNG TIN KHÁCH WALK-IN TRỰC TIẾP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                        'Họ và tên bệnh nhân', Icons.person_rounded, nameTextController, (val) => controller.walkinName.value = val),
                    const SizedBox(height: 12),
                    _buildTextField(
                        'Số điện thoại liên hệ', Icons.phone_rounded, phoneTextController, (val) => controller.walkinPhone.value = val),
                    const SizedBox(height: 12),
                    _buildTextField(
                        'Lý do khám / Triệu chứng sơ bộ', Icons.medical_services_rounded, reasonTextController, (val) => controller.walkinReason.value = val),
                    const SizedBox(height: 36),
                    _buildSubmitButton(nameTextController, phoneTextController, reasonTextController),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF38BDF8).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.flash_on_rounded,
                color: Color(0xFF38BDF8), size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đặt lịch khám nhanh walk-in',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  'Tạo nhanh số thứ tự và phân bổ bác sĩ trực ban cho khách hàng vãng lai không đặt trước.',
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

  Widget _buildDoctorDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedDoctorId.value.isEmpty
              ? null
              : controller.selectedDoctorId.value,
          dropdownColor: const Color(0xFF0F1626),
          isExpanded: true,
          style: const TextStyle(color: Colors.white),
          items: controller.doctors.map((doc) {
            final profile = doc['user_profiles'];
            return DropdownMenuItem<String>(
              value: doc['id'].toString(),
              child: Row(
                children: [
                  const Icon(Icons.medical_services_rounded, color: Color(0xFF38BDF8), size: 18),
                  const SizedBox(width: 12),
                  Text(
                    profile?['full_name'] ?? 'Bác sĩ trực ban',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      doc['departments']?['name'] ?? 'Chuyên khoa',
                      style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              controller.selectedDoctorId.value = val;
            }
          },
        ),
      ),
    );
  }

  Widget _buildPatientDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedPatientId.value.isEmpty
              ? null
              : controller.selectedPatientId.value,
          dropdownColor: const Color(0xFF0F1626),
          isExpanded: true,
          hint: const Text('Chọn bệnh nhân đã có tài khoản (nếu có)', style: TextStyle(color: Colors.white30, fontSize: 12)),
          style: const TextStyle(color: Colors.white),
          items: controller.patients.map((pat) {
            return DropdownMenuItem<String>(
              value: pat['id'].toString(),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white54, size: 18),
                  const SizedBox(width: 12),
                  Text(
                    pat['full_name'] ?? 'Bệnh nhân',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    pat['phone_number'] ?? '',
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            controller.selectedPatientId.value = val ?? '';
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController textController, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
      ),
      child: TextField(
        controller: textController,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
          prefixIcon: Icon(icon, color: Colors.white54, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSubmitButton(TextEditingController nameCtrl, TextEditingController phoneCtrl, TextEditingController reasonCtrl) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF38BDF8).withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.isSubmitting.value
              ? null
              : () {
                  controller.createWalkinBooking().then((_) {
                    nameCtrl.clear();
                    phoneCtrl.clear();
                    reasonCtrl.clear();
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
          child: controller.isSubmitting.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'CẤP PHÁT PHIẾU KHÁM & TẠO SỐ',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5),
                ),
        ),
      );
    });
  }
}
