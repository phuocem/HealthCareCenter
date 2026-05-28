import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/emr_history_controller.dart';

class EmrHistoryView extends GetView<EmrHistoryController> {
  const EmrHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        title: const Text(
          'BỆNH ÁN ĐIỆN TỬ (EMR)',
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
          // Background blobs
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
                    _buildPatientProfileCard(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('SO SÁNH KẾT QUẢ XÉT NGHIỆM LÂM SÀNG', 'Glucose vs Cholesterol'),
                    const SizedBox(height: 12),
                    _buildLabComparisonChart(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('BỆNH NỀN & DI ỨNG', 'MEDICAL CONDITIONS'),
                    const SizedBox(height: 12),
                    _buildBackgroundConditions(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('LỊCH SỬ KHÁM BỆNH CŨ', 'PAST VISITS'),
                    const SizedBox(height: 12),
                    _buildEmrNotesList(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String tag) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF38BDF8),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5),
            ),
          ],
        ),
        Text(
          tag.toUpperCase(),
          style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 9,
              fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _buildPatientProfileCard() {
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF38BDF8).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.badge_rounded, color: Color(0xFF38BDF8), size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.patientName.value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.patientAge.value} | ${controller.patientGender.value}',
                  style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabComparisonChart() {
    return Container(
      height: 240,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (val, meta) {
                  return Text(
                    val.toInt().toString(),
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 8, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final dates = ['Lần 1', 'Lần 2', 'Lần 3', 'Lần 4', 'Lần 5'];
                  if (val.toInt() >= 0 && val.toInt() < dates.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        dates[val.toInt()],
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            // Glucose Line
            LineChartBarData(
              spots: List.generate(controller.labGlucoseTrend.length, (index) {
                return FlSpot(index.toDouble(), controller.labGlucoseTrend[index]);
              }),
              isCurved: true,
              gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF0284C7)]),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
            ),
            // Cholesterol Line
            LineChartBarData(
              spots: List.generate(controller.labCholesterolTrend.length, (index) {
                return FlSpot(index.toDouble(), controller.labCholesterolTrend[index]);
              }),
              isCurved: true,
              gradient: const LinearGradient(colors: [Color(0xFFF43F5E), Color(0xFFE11D48)]),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundConditions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.backgroundConditions.map((condition) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFBBF24).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFBBF24).withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFFBBF24), size: 14),
              const SizedBox(width: 6),
              Text(
                condition,
                style: const TextStyle(
                    color: Color(0xFFFBBF24),
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmrNotesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.emrNotes.length,
      itemBuilder: (context, index) {
        final note = controller.emrNotes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1626),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    note['date']!,
                    style: const TextStyle(
                        color: Color(0xFF38BDF8),
                        fontSize: 10,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    note['doctor']!,
                    style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                note['diagnose']!,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                note['notes']!,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }
}
