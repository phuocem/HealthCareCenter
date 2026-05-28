import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_analytics_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class AdminAnalyticsView extends GetView<AdminAnalyticsController> {
  const AdminAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        title: const Text(
          'TRUNG TÂM PHÂN TÍCH BI',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.5, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_rounded, color: Color(0xFF38BDF8)),
            onPressed: () => controller.loadAnalytics(),
          ),
        ],
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
                return const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8)));
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildKPIGrid(currencyFmt),
                    const SizedBox(height: 24),
                    _buildSectionHeader('BIỂU ĐỒ DOANH THU HÀNG THÁNG', 'Đơn vị: Triệu VND'),
                    const SizedBox(height: 12),
                    _buildRevenueBarChart(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('XU HƯỚNG LƯỢT KHÁM TRONG TUẦN', ' Monday - Sunday '),
                    const SizedBox(height: 12),
                    _buildVisitsLineChart(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('CƠ CẤU BỆNH NHÂN THEO CHUYÊN KHOA', ' Tỷ lệ % '),
                    const SizedBox(height: 12),
                    _buildSpecialtyPieChart(),
                    const SizedBox(height: 40),
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
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
            ),
          ],
        ),
        Text(
          tag.toUpperCase(),
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _buildKPIGrid(NumberFormat fmt) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildKPICard(
          'Tổng doanh thu',
          fmt.format(controller.totalRevenue.value),
          Icons.monetization_on_rounded,
          const Color(0xFF10B981),
        ),
        _buildKPICard(
          'Tổng lượt khám',
          '${controller.totalVisits.value} ca',
          Icons.assignment_ind_rounded,
          const Color(0xFF38BDF8),
        ),
        _buildKPICard(
          'Tỷ lệ hủy lịch',
          '${controller.cancellationRate.value}%',
          Icons.event_busy_rounded,
          const Color(0xFFF43F5E),
        ),
        _buildKPICard(
          'Bác sĩ trực ca',
          '${controller.activeDoctors.value} BS',
          Icons.medical_services_rounded,
          const Color(0xFFFBBF24),
        ),
      ],
    );
  }

  Widget _buildKPICard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bar Chart: Monthly Revenue
  Widget _buildRevenueBarChart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];
                  if (val.toInt() >= 0 && val.toInt() < months.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        months[val.toInt()],
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
          barGroups: List.generate(controller.monthlyRevenue.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: controller.monthlyRevenue[index],
                  gradient: const LinearGradient(
                    colors: [Color(0xFF34D399), Color(0xFF059669)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // Line Chart: Patient Weekly Visits
  Widget _buildVisitsLineChart() {
    return Container(
      height: 220,
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
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
                  if (val.toInt() >= 0 && val.toInt() < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        days[val.toInt()],
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold),
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
            LineChartBarData(
              spots: List.generate(controller.weeklyVisits.length, (index) {
                return FlSpot(index.toDouble(), controller.weeklyVisits[index]);
              }),
              isCurved: true,
              gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF3B82F6)]),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [const Color(0xFF38BDF8).withValues(alpha: 0.2), const Color(0xFF3B82F6).withValues(alpha: 0.01)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pie Chart: Specialties Patient Share
  Widget _buildSpecialtyPieChart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1626),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 36,
                sections: [
                  PieChartSectionData(
                    color: const Color(0xFF0284C7),
                    value: 35,
                    title: '35%',
                    radius: 46,
                    titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFFEF4444),
                    value: 20,
                    title: '20%',
                    radius: 46,
                    titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFF8B5CF6),
                    value: 25,
                    title: '25%',
                    radius: 46,
                    titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: const Color(0xFF10B981),
                    value: 20,
                    title: '20%',
                    radius: 46,
                    titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Legend
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem('Tổng quát', const Color(0xFF0284C7)),
                const SizedBox(height: 8),
                _buildLegendItem('Tim mạch', const Color(0xFFEF4444)),
                const SizedBox(height: 8),
                _buildLegendItem('Nhi khoa', const Color(0xFF8B5CF6)),
                const SizedBox(height: 8),
                _buildLegendItem('Da liễu', const Color(0xFF10B981)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
