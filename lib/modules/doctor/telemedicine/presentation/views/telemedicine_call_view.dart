import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/telemedicine_call_controller.dart';

class TelemedicineCallView extends GetView<TelemedicineCallController> {
  const TelemedicineCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full Screen Patient Camera View Simulator
          _buildPatientVideoFeed(),

          // Glassmorphism Header Bar
          _buildHeaderBar(),

          // Mini Doctor PIP Camera Feed
          _buildDoctorPipFeed(),

          // Call Control deck
          _buildControlDeck(),
        ],
      ),
    );
  }

  Widget _buildPatientVideoFeed() {
    return Obx(() {
      if (controller.isCameraOff.value) {
        return Container(
          color: const Color(0xFF0F172A),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF1E293B),
                  child: Text(
                    controller.patientName.value[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Camera đối phương đang tắt',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        );
      }

      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF0F172A), Color(0xFF0284C7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Abstract pulsing soundwaves simulating a real call
            Center(
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.videocam_rounded,
                  size: 260,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    child: Text(
                      controller.patientName.value[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.patientName.value,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Obx(() => Text(
                        controller.connectionStatus.value,
                        style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeaderBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.2),
            padding: const EdgeInsets.only(top: 48, bottom: 16, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TƯ VẤN TELEMEDICINE',
                      style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                    const SizedBox(height: 4),
                    Obx(() {
                      final duration = controller.callDurationSec.value;
                      final min = (duration ~/ 60).toString().padLeft(2, '0');
                      final sec = (duration % 60).toString().padLeft(2, '0');
                      return Text(
                        '$min:$sec',
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                      );
                    }),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wifi_rounded, color: Color(0xFF10B981), size: 12),
                      SizedBox(width: 4),
                      Text(
                        'HD CALL',
                        style: TextStyle(color: Color(0xFF10B981), fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorPipFeed() {
    return Positioned(
      top: 130,
      right: 20,
      width: 90,
      height: 130,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24, width: 1.5),
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10),
          ],
        ),
        child: const ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: Stack(
            children: [
              Center(
                child: Icon(Icons.person, color: Colors.white24, size: 28),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Text(
                  'Bạn',
                  style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlDeck() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(() => _buildControlButton(
                  controller.isMuted.value ? Icons.mic_off_rounded : Icons.mic_rounded,
                  controller.isMuted.value ? const Color(0xFFF43F5E) : Colors.white24,
                  () => controller.toggleMute(),
                )),
            Obx(() => _buildControlButton(
                  controller.isCameraOff.value ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                  controller.isCameraOff.value ? const Color(0xFFF43F5E) : Colors.white24,
                  () => controller.toggleCamera(),
                )),
            _buildControlButton(
              Icons.call_end_rounded,
              const Color(0xFFEF4444),
              () => controller.endCall(),
              iconColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, Color bg, VoidCallback onTap, {Color iconColor = Colors.white70}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}
