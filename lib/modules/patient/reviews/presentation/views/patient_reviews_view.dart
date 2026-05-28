import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patient_reviews_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class PatientReviewsView extends GetView<PatientReviewsController> {
  const PatientReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final commentTextController = TextEditingController();

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

                    if (controller.doctors.isEmpty) {
                      return const Center(
                        child: Text(
                          'Không tìm thấy bác sĩ nào hoạt động.',
                          style: TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderCard(),
                          const SizedBox(height: 24),
                          const Text(
                            'CHỌN BÁC SĨ ĐÃ KHÁM',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildDoctorDropdown(),
                          const SizedBox(height: 24),
                          const Text(
                            'ĐÁNH GIÁ CHẤT LƯỢNG (SAO)',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildStarRatingSelector(),
                          const SizedBox(height: 24),
                          const Text(
                            'Ý KIẾN ĐÓNG GÓP CHI TIẾT',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildCommentInput(commentTextController),
                          const SizedBox(height: 32),
                          _buildSubmitButton(),
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
            'ĐÁNH GIÁ BÁC SĨ',
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

  Widget _buildHeaderCard() {
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
            child: const Icon(Icons.star_rate_rounded,
                color: Color(0xFF0284C7), size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đóng góp ý kiến của bạn',
                  style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 14,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  'Phản hồi của bạn giúp chúng tôi cải thiện chất lượng dịch vụ chăm sóc sức khỏe.',
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
          value: controller.selectedDoctorId.value.isEmpty
              ? null
              : controller.selectedDoctorId.value,
          dropdownColor: Colors.white,
          isExpanded: true,
          items: controller.doctors.map((doc) {
            final profile = doc['user_profiles'];
            return DropdownMenuItem<String>(
              value: doc['id'].toString(),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFF0F6FA),
                    backgroundImage: profile?['avatar_url'] != null
                        ? NetworkImage(profile['avatar_url'])
                        : null,
                    child: profile?['avatar_url'] == null
                        ? const Icon(Icons.person,
                            color: Color(0xFF0284C7), size: 16)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    profile?['full_name'] ?? 'Bác sĩ trực ban',
                    style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w800,
                        fontSize: 13),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      doc['departments']?['name'] ?? 'Chuyên khoa',
                      style: const TextStyle(
                          color: Color(0xFF0284C7),
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

  Widget _buildStarRatingSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final starValue = index + 1;
          return Obx(() {
            final isSelected = controller.rating.value >= starValue;
            return IconButton(
              icon: Icon(
                isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isSelected ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1),
                size: 38,
              ),
              onPressed: () {
                controller.rating.value = starValue;
              },
            );
          });
        }),
      ),
    );
  }

  Widget _buildCommentInput(TextEditingController textController) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(18),
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
        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13),
        maxLines: 5,
        decoration: InputDecoration(
          hintText:
              'Chia sẻ trải nghiệm của bạn về thái độ chuyên môn, sự tận tình của bác sĩ...',
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
        onChanged: (val) => controller.comment.value = val,
      ),
    );
  }

  Widget _buildSubmitButton() {
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
          onPressed: controller.isSubmitting.value
              ? null
              : () => controller.submitReview(),
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
                  'GỬI ĐÁNH GIÁ NGAY',
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
