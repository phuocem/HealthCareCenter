import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/routes/app_routes.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  
  static final selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA), 
      body: Stack(
        children: [
          
          Positioned(
            top: -80,
            right: -80,
            width: 320,
            height: 320,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x3338BDF8), 
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            width: 280,
            height: 280,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1EF43F5E), 
              ),
            ),
          ),
          
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(color: Colors.transparent),
          ),

          Obx(() => IndexedStack(
            index: selectedIndex.value,
            children: [
              _buildHomeTab(context),
              _buildProfileTab(context),
            ],
          )),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildHealthWelcomeCard(), 
                  const SizedBox(height: 28),
                  _buildSectionHeader('DỊCH VỤ NHANH', 'SMART ACTIONS'),
                  _buildSmartActionsCluster(),
                  const SizedBox(height: 20),
                  _buildAISymptomCard(context),
                  const SizedBox(height: 28),
                  _buildUpcomingAppointment(),
                  const SizedBox(height: 28),
                  _buildSectionHeader('BÁC SĨ NỔI BẬT', 'TOP SPECIALISTS'),
                  _buildDoctorCarousel(),
                  const SizedBox(height: 28),
                  _buildSectionHeader('CHUYÊN KHOA LÂM SÀNG', 'DEPARTMENTS'),
                  _buildServiceGrid(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CÁ NHÂN',
              style: TextStyle(
                color: Color(0xFF0284C7),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),

            
            _buildProfileDigitalCard(),
            const SizedBox(height: 28),

            _buildSectionHeader('HỒ SƠ BẢO HIỂM Y TẾ', 'HEALTH CARD'),
            _buildHealthDetailsCluster(),
            const SizedBox(height: 28),

            _buildSectionHeader('CÀI ĐẶT & HỆ THỐNG', 'SETTINGS'),
            _buildSettingsCluster(),
            const SizedBox(height: 36),

            _buildLogoutButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  
  Widget _buildProfileDigitalCard() {
    return Obx(() {
      final profile = controller.userProfile;
      final name = profile['full_name'] ?? 'Bệnh nhân';
      final email = profile['email'] ?? 'Chưa cập nhật email';
      final cardNo = profile['health_card_number'] ?? 'GD47915203';
      final initial = name.isNotEmpty ? name[0].toUpperCase() : 'B';

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [Color(0xFF0284C7), Color(0xFF0369A1), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0284C7).withOpacity(0.35),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            
            Positioned(
              right: -30,
              top: -30,
              width: 180,
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -40,
              width: 140,
              height: 140,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png', 
                            width: 24, 
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'HEALTHX PREMIUM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: const Text(
                          'MEMBER',
                          style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  
                  Container(
                    width: 38,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 20),

                  
                  Text(
                    cardNo.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} "),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  
                  Row(
                    children: [
                      
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFF0F6FA),
                          backgroundImage: (profile['avatar_url'] != null)
                              ? NetworkImage(profile['avatar_url'])
                              : null,
                          child: (profile['avatar_url'] == null)
                              ? Text(initial, style: const TextStyle(color: Color(0xFF0284C7), fontSize: 16, fontWeight: FontWeight.bold))
                              : null,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHealthDetailsCluster() {
    return Obx(() {
      final profile = controller.userProfile;
      
      final phone = profile['phone_number'] ?? '0912 345 678';
      final cardNo = profile['health_card_number'] ?? 'GD479152031102';
      final dob = profile['dob'] ?? '18/06/1992';
      final gender = profile['gender'] ?? 'Nam';
      final blood = profile['blood_type'] ?? 'O+';
      final height = profile['height'] ?? '175 cm';
      final weight = profile['weight'] ?? '68 kg';
      final emName = profile['emergency_name'] ?? 'Nguyễn Thị Lan';
      final emPhone = profile['emergency_phone'] ?? '0987 654 321';
      final emRelation = profile['emergency_relation'] ?? 'Vợ (Spouse)';
      final address = profile['address'] ?? '123 Đường Cách Mạng Tháng 8, Quận 3, TP. Hồ Chí Minh';
      final allergies = profile['allergies'] ?? 'Không dị ứng thuốc';
      final insProvider = profile['insurance_provider'] ?? 'Bảo hiểm Xã hội TP.HCM';
      final insExpiry = profile['insurance_expiry'] ?? '31/12/2028';
      final nationalId = profile['national_id'] ?? '079092008765';
      final medicalHistory = profile['medical_history'] ?? 'Tiền sử tăng huyết áp nhẹ từ năm 2024';

      return Column(
        children: [
          // Section 1: Personal Dossier
          _buildProfileSectionHeader('THÔNG TIN CÁ NHÂN'),
          const SizedBox(height: 10),
          _buildGlassCard([
            _buildDetailRow(Icons.fingerprint_rounded, 'CĂN CƯỚC CÔNG DÂN (CCCD)', nationalId, const Color(0xFF64748B)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.cake_rounded, 'NGÀY SINH', dob, const Color(0xFF8B5CF6)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.transgender_rounded, 'GIỚI TÍNH', gender, const Color(0xFFEC4899)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.home_rounded, 'ĐỊA CHỈ THƯỜNG TRÚ', address, const Color(0xFF3B82F6)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.phone_iphone_rounded, 'SỐ ĐIỆN THOẠI CÁ NHÂN', phone, const Color(0xFF10B981)),
          ]),
          const SizedBox(height: 24),
 
          // Section 2: Vitals & Body
          _buildProfileSectionHeader('CHỈ SỐ THỂ CHẤT & SINH TỒN'),
          const SizedBox(height: 10),
          _buildGlassCard([
            _buildDetailRow(Icons.bloodtype_rounded, 'NHÓM MÁU', blood, const Color(0xFFEF4444)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.height_rounded, 'CHIỀU CAO', height, const Color(0xFF38BDF8)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.scale_rounded, 'CÂN NẶNG', weight, const Color(0xFF10B981)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.health_and_safety_rounded, 'TIỀN SỬ DỊ ỨNG', allergies, const Color(0xFFF59E0B)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.history_edu_rounded, 'TIỀN SỬ BỆNH LÝ', medicalHistory, const Color(0xFF6366F1)),
          ]),
          const SizedBox(height: 24),
 
          // Section 3: Emergency Contact
          _buildProfileSectionHeader('LIÊN HỆ KHẨN CẤP (NGƯỜI THÂN)'),
          const SizedBox(height: 10),
          _buildGlassCard([
            _buildDetailRow(Icons.person_rounded, 'HỌ TÊN NGƯỜI THÂN', emName, const Color(0xFFEC4899)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.contact_phone_rounded, 'SỐ ĐIỆN THOẠI LIÊN HỆ', emPhone, const Color(0xFF10B981)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.family_restroom_rounded, 'MỐI QUAN HỆ', emRelation, const Color(0xFF8B5CF6)),
          ]),
          const SizedBox(height: 24),
 
          // Section 4: Insurance Dossier
          _buildProfileSectionHeader('HỒ SƠ BẢO HIỂM Y TẾ (BHYT)'),
          const SizedBox(height: 10),
          _buildGlassCard([
            _buildDetailRow(Icons.badge_rounded, 'MÃ SỐ BHYT', cardNo, const Color(0xFF0284C7)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.business_rounded, 'CƠ QUAN CẤP PHÁT', insProvider, const Color(0xFF64748B)),
            const Divider(color: Color(0xFFE2E8F0), height: 20, thickness: 1),
            _buildDetailRow(Icons.event_available_rounded, 'THỜI HẠN THẺ BHYT', insExpiry, const Color(0xFF10B981)),
          ]),
        ],
      );
    });
  }

  Widget _buildProfileSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFF0284C7),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0284C7),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCluster() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsActionRow(Icons.edit_note_rounded, 'Cập nhật hồ sơ bệnh án', const Color(0xFF8B5CF6)),
          const Divider(color: Color(0xFFE2E8F0), height: 24, thickness: 1),
          _buildSettingsActionRow(Icons.settings_rounded, 'Cài đặt ứng dụng', const Color(0xFF64748B)),
        ],
      ),
    );
  }

  Widget _buildSettingsActionRow(IconData icon, String title, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 13),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => controller.logout(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.power_settings_new_rounded, size: 20),
            SizedBox(width: 8),
            Text(
              'ĐĂNG XUẤT TÀI KHOẢN',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() => Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BottomNavigationBar(
          currentIndex: selectedIndex.value,
          onTap: (index) => selectedIndex.value = index,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF0284C7),
          unselectedItemColor: const Color(0xFF94A3B8),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
          unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 20),
              activeIcon: Icon(Icons.home_rounded, size: 22),
              label: 'TRANG CHỦ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded, size: 20),
              activeIcon: Icon(Icons.person_rounded, size: 22),
              label: 'CÁ NHÂN',
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: true,
      toolbarHeight: 70,
      title: const Text(
        'HEALTHX CLINIC',
        style: TextStyle(
          color: Color(0xFF0284C7),
          fontSize: 15,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
      actions: [
        
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.03),
                blurRadius: 10,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_rounded, color: Color(0xFF475569), size: 20),
            onPressed: () {},
          ),
        ),
        
        
        Obx(() {
          final profile = controller.userProfile;
          final name = profile['full_name'] ?? 'Bệnh nhân';
          final initial = name.isNotEmpty ? name[0].toUpperCase() : 'B';
          return GestureDetector(
            onTap: () {
              
              selectedIndex.value = 1;
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20, left: 12, top: 12, bottom: 12),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFE2E8F0),
                backgroundImage: (profile['avatar_url'] != null)
                    ? NetworkImage(profile['avatar_url'])
                    : null,
                child: (profile['avatar_url'] == null)
                    ? Text(
                        initial,
                        style: const TextStyle(
                          color: Color(0xFF0284C7),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            ),
          );
        }),
      ],
    );
  }

  
  Widget _buildHealthWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CHÀO MỪNG BẠN QUAY LẠI',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
                const SizedBox(height: 6),
                Obx(() => Text(
                  'Xin chào, ${controller.userName.value}!',
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Color(0xFF10B981), blurRadius: 6, spreadRadius: 1),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Bảo vệ sức khỏe 24/7',
                      style: TextStyle(color: Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFF0284C7),
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String tag) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 12,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
                  ),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title, 
                style: const TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.w900, 
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Text(
            tag, 
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartActionsCluster() {
    return Column(
      children: [
        Row(
          children: [
            
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () => Get.toNamed(Routes.BOOK_BY_DOCTOR),
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0284C7), Color(0xFF0284C7), Color(0xFF0369A1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 24),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đặt Lịch Mới',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Đặt giờ hẹn nhanh',
                            style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    _buildMiniClusterItem(
                      'Lịch sử khám', 
                      Icons.history_edu_rounded, 
                      const Color(0xFF8B5CF6), 
                      () => Get.toNamed(Routes.HISTORY),
                    ),
                    const SizedBox(height: 10),
                    _buildMiniClusterItem(
                      'Xét nghiệm', 
                      Icons.biotech_rounded, 
                      const Color(0xFF10B981), 
                      () => Get.toNamed(Routes.PATIENT_LAB_RESULTS),
                    ),
                    const SizedBox(height: 10),
                    _buildMiniClusterItem(
                      'Đơn thuốc', 
                      Icons.medication_rounded, 
                      const Color(0xFF22D3EE), 
                      () => Get.toNamed(Routes.PATIENT_PRESCRIPTIONS),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        
        GestureDetector(
          onTap: () => Get.toNamed(Routes.PATIENT_INVOICES),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(22),
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
                    color: const Color(0xFFFBBF24).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.receipt_long_rounded, color: Color(0xFFD97706), size: 20),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hóa đơn & Thanh toán',
                        style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                      Text(
                        'Theo dõi giao dịch y tế cá nhân',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_right_rounded, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniClusterItem(String label, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w800, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointment() {
    return Obx(() {
      final appointment = controller.upcomingAppointment.value;
      if (appointment == null) return _buildDefaultBanner();

      final doctorProfile = appointment['doctors']['user_profiles'];

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF0284C7)]),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFF0F6FA),
                    backgroundImage: (doctorProfile['avatar_url'] != null) 
                        ? NetworkImage(doctorProfile['avatar_url']) 
                        : null,
                    child: (doctorProfile['avatar_url'] == null) 
                        ? const Icon(Icons.person, color: Color(0xFF0284C7), size: 24) 
                        : null,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorProfile['full_name'], 
                        style: const TextStyle(
                          color: Color(0xFF0F172A), 
                          fontWeight: FontWeight.w800, 
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Color(0xFF10B981), blurRadius: 4),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Lịch hẹn sắp tới', 
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0x1F0284C7), 
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.videocam_rounded, color: Color(0xFF0284C7), size: 18),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC), 
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAppointmentDetail(Icons.calendar_today_rounded, appointment['appointment_date']),
                  Container(width: 1, height: 16, color: const Color(0xFFCBD5E1)),
                  _buildAppointmentDetail(Icons.access_time_rounded, appointment['start_time'].toString().substring(0, 5)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAppointmentDetail(IconData icon, String val) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0284C7), size: 14),
        const SizedBox(width: 8),
        Text(
          val,
          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 12, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  Widget _buildDefaultBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Khám Sức Khỏe Ngay', 
            style: TextStyle(
              color: Color(0xFF0F172A), 
              fontSize: 18, 
              fontWeight: FontWeight.w900, 
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Đặt lịch nhanh chóng cùng đội ngũ y bác sĩ đầu ngành uy tín.', 
            style: TextStyle(color: Color(0xFF64748B), fontSize: 12, height: 1.4, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () => Get.toNamed(Routes.BOOK_BY_DOCTOR),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              minimumSize: Size.zero,
              elevation: 0,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ĐẶT HẸN NGAY', 
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5),
                ),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCarousel() {
    return SizedBox(
      height: 185,
      child: Obx(() => ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.doctors.length,
        itemBuilder: (context, index) {
          final doctor = controller.doctors[index];
          final profile = doctor['user_profiles'];
          return Container(
            width: 144,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withOpacity(0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF0284C7)]),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFFF0F6FA),
                    backgroundImage: (profile['avatar_url'] != null) 
                        ? NetworkImage(profile['avatar_url']) 
                        : null,
                    child: (profile['avatar_url'] == null) 
                        ? const Icon(Icons.person, color: Color(0xFF0284C7), size: 24) 
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profile['full_name'], 
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF0F172A)), 
                  textAlign: TextAlign.center, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  doctor['departments']?['name'] ?? 'Chuyên khoa', 
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFBBF24).withOpacity(0.2)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 12),
                      SizedBox(width: 3),
                      Text(
                        '4.9', 
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFFD97706)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      )),
    );
  }

  Widget _buildServiceGrid() {
    final services = [
      {'title': 'Khám Tổng quát', 'icon': Icons.health_and_safety_rounded, 'color': const Color(0xFF0284C7)},
      {'title': 'Nhi khoa', 'icon': Icons.child_care_rounded, 'color': const Color(0xFF8B5CF6)},
      {'title': 'Tim mạch', 'icon': Icons.favorite_rounded, 'color': const Color(0xFFEF4444)},
      {'title': 'Da liễu', 'icon': Icons.spa_rounded, 'color': const Color(0xFF10B981)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final serviceColor = service['color'] as Color;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.02),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: serviceColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(service['icon'] as IconData, color: serviceColor, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                service['title'] as String, 
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF0F172A)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAISymptomCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.psychology_rounded,
                size: 120,
                color: const Color(0xFF0284C7).withOpacity(0.08),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.4)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.auto_awesome_rounded, color: Color(0xFF38BDF8), size: 12),
                            SizedBox(width: 4),
                            Text(
                              'AI ASSISTANT',
                              style: TextStyle(
                                color: Color(0xFF38BDF8),
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Bác sĩ Tư vấn Triệu chứng AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Nhập triệu chứng cơ thể để AI phân tích chuyên khoa phù hợp và gợi ý bác sĩ trực ban tốt nhất.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showAISymptomBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'TRÒ CHUYỆN VÀ PHÂN TÍCH',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAISymptomBottomSheet(BuildContext context) {
    final textController = TextEditingController();
    Get.bottomSheet(
      Container(
        height: context.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFF0A0F1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF38BDF8), size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Symptom Advisor',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                    Text(
                      'Chẩn đoán thông minh & Gợi ý chuyên khoa',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Obx(() {
                  if (controller.isAiLoading.value) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8))),
                        const SizedBox(height: 20),
                        Text(
                          'AI đang phân tích triệu chứng...',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  }

                  final result = controller.aiSymptomResult.value;
                  if (result == null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mô tả các triệu chứng của bạn:',
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: textController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Ví dụ: Tôi bị đau ngực kèm theo khó thở và tim đập nhanh...',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
                            fillColor: const Color(0xFF0F1626),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFF1E293B)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFF0284C7)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            controller.analyzeSymptoms(textController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0284C7),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('GỬI AI PHÂN TÍCH', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    );
                  }

                  // Display result
                  final doctor = result['doctor'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F1626),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF1E293B)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'KẾT QUẢ PHÂN TÍCH SƠ BỘ',
                              style: TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.medical_services_outlined, color: Colors.white70, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Chuyên khoa khuyên dùng: ${result['specialty']}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              result['recommendation'],
                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, height: 1.4, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (doctor != null) ...[
                        Text(
                          'Bác sĩ khuyên dùng cho bạn:',
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F1626),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF1E293B)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: const Color(0xFF1E293B),
                                backgroundImage: doctor['user_profiles']?['avatar_url'] != null
                                    ? NetworkImage(doctor['user_profiles']['avatar_url'])
                                    : null,
                                child: doctor['user_profiles']?['avatar_url'] == null
                                    ? const Icon(Icons.person, color: Color(0xFF38BDF8))
                                    : null,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor['user_profiles']?['full_name'] ?? 'Bác sĩ trực ban',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      doctor['departments']?['name'] ?? 'Bác sĩ chuyên khoa',
                                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                controller.aiSymptomResult.value = null;
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white70,
                                side: const BorderSide(color: Color(0xFF1E293B)),
                                minimumSize: const Size(0, 48),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('PHÂN TÍCH LẠI'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                                Get.toNamed(Routes.BOOK_BY_DOCTOR);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0284C7),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 48),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('ĐẶT LỊCH HẸN'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
