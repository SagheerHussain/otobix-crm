import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/controllers/desktop_dashboard_controller.dart';
import 'package:otobix_crm/utils/app_colors.dart' show AppColors;

class DesktopDashboardPage extends StatelessWidget {
  DesktopDashboardPage({super.key});

  final DesktopDashboardController getxController =
      Get.put(DesktopDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScreenTitle(),
              const SizedBox(height: 20),
              _buildTopReports(),
              // const SizedBox(height: 12),
              // _buildInfoNote(), // 👈 simple info text block
              const SizedBox(height: 20),
              _buildChartsSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Screen Title
  Widget _buildScreenTitle() {
    return Row(
      children: [
        Text(
          "Dashboard",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Top Reports  // Top Reports (now reactive)
  Widget _buildTopReports() {
    final getxController = Get.find<DesktopDashboardController>();
    Widget infoContainer({
      required String title,
      required String count,
      required IconData icon,
    }) {
      return Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 25, color: AppColors.green),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: AppColors.grey.withOpacity(0.7),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              count,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Obx(() {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          infoContainer(
            title: "Total Dealers",
            count: getxController.isLoadingSummary.value
                ? '...'
                : getxController.totalDealers.value.toString(),
            icon: FontAwesomeIcons.userTie,
          ),
          infoContainer(
            title: "Total Cars",
            count: getxController.isLoadingSummary.value
                ? '...'
                : getxController.totalCars.value.toString(),
            icon: FontAwesomeIcons.car,
          ),
          infoContainer(
            title: "Upcoming Cars",
            count: getxController.isLoadingSummary.value
                ? '...'
                : getxController.upcomingCars.value.toString(),
            icon: FontAwesomeIcons.calendarPlus,
          ),
          infoContainer(
            title: "Live Cars",
            count: getxController.isLoadingSummary.value
                ? '...'
                : getxController.liveCars.value.toString(),
            icon: FontAwesomeIcons.circlePlay,
          ),
          infoContainer(
            title: "Otobuy Cars",
            count: getxController.isLoadingSummary.value
                ? '...'
                : getxController.otobuyCars.value.toString(),
            icon: FontAwesomeIcons.cartShopping,
          ),
        ],
      );
    });
  }

  // Charts Section
  // Widget _buildChartsSection1() {
  //   return Wrap(
  //     spacing: 10,
  //     runSpacing: 10,
  //     children: [
  //       _buildDealersChart(),
  //       _buildAllCarsChart(),
  //       _buildUpcomingCarsChart(),
  //       _buildLiveCarsChart(),
  //       _buildOtobuyCarsChart(),
  //     ],
  //   );
  // }
  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1 — 2 charts
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: _buildDealersChart()),
            // const SizedBox(width: 20),
            // _buildAllCarsChart(),
          ],
        ),
        // const SizedBox(height: 20),

        // Row 2 — 3 charts
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     _buildUpcomingCarsChart(),
        //     const SizedBox(width: 20),
        //     _buildLiveCarsChart(),
        //     const SizedBox(width: 20),
        //     _buildOtobuyCarsChart(),
        //   ],
        // ),
      ],
    );
  }

  // -------------------------------------------------------------
  // 📊 INDIVIDUAL CHARTS (Each One Different)
  // -------------------------------------------------------------

  // 1️⃣ Dealers - Bar Chart
  Widget _buildDealersChart() {
    final c = Get.find<DesktopDashboardController>();

    return Obx(() {
      // Fallback labels if API didn't send categories
      final categories = (c.dealersCategories.isEmpty)
          ? const [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec'
            ]
          : List<String>.from(c.dealersCategories);

      // Build an immutable 12-length double list from series (no nulls, no mutations)
      final data = List<double>.generate(
        12,
        (i) =>
            (i < c.dealersSeries.length ? c.dealersSeries[i].toDouble() : 0.0),
        growable: false,
      );

      // Compute a neat Y-axis range & interval (avoid repeated labels)
      final double maxVal = data.isEmpty ? 0.0 : data.reduce(math.max);
      final double maxY = (maxVal <= 5)
          ? 5.0
          : ((maxVal / 5).ceil() * 5).toDouble(); // round up to multiple of 5
      final double interval = (maxY <= 10) ? 1.0 : (maxY / 5).ceilToDouble();

      // Bars
      final barGroups = List<BarChartGroupData>.generate(12, (i) {
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data[i],
              color: AppColors.green,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      });

      return _chartContainer(
        title: "Dealers Overview (${c.dealersYear.value})",
        width: 800,
        child: c.isLoadingDealers.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.green))
            : BarChart(
                BarChartData(
                  minY: 0,
                  maxY: maxY,
                  groupsSpace: 8,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        getTitlesWidget: (value, _) {
                          final i = value.toInt();
                          if (i < 0 || i >= 12) return const SizedBox.shrink();
                          final label =
                              (i < categories.length) ? categories[i] : '';
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              label,
                              style: TextStyle(
                                  color: AppColors.grey, fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: interval,
                        getTitlesWidget: (value, _) {
                          // Show only clean multiples of `interval`
                          final isTick = (value % interval).abs() < 1e-6;
                          if (!isTick) return const SizedBox.shrink();
                          return Text(
                            value.toInt().toString(),
                            style:
                                TextStyle(color: AppColors.grey, fontSize: 11),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: barGroups,
                ),
              ),
      );
    });
  }

  Widget _buildDealersChart1() {
    final c = Get.find<DesktopDashboardController>();

    return Obx(() {
      final categories = (c.dealersCategories.isEmpty)
          ? const [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec'
            ]
          : List<String>.from(c.dealersCategories);

      // Build a padded list of 12 doubles without mutating the source RxList
      final data = List<double>.generate(
        12,
        (i) =>
            (i < c.dealersSeries.length ? c.dealersSeries[i].toDouble() : 0.0),
        growable: false,
      );

      final barGroups = List<BarChartGroupData>.generate(12, (i) {
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data[i],
              color: AppColors.green,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      });

      return _chartContainer(
        title: "Dealers Overview (${c.dealersYear.value})",
        width: 800,
        child: c.isLoadingDealers.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.green))
            : BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  groupsSpace: 8,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        getTitlesWidget: (value, _) {
                          final i = value.toInt();
                          if (i < 0 || i >= 12) return const SizedBox.shrink();
                          final label = (i < categories.length)
                              ? categories[i]
                              : ''; // safe if categories length < 12
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              label,
                              style: TextStyle(
                                  color: AppColors.grey, fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, _) => Text(
                          value.toInt().toString(),
                          style: TextStyle(color: AppColors.grey, fontSize: 11),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: barGroups,
                ),
              ),
      );
    });
  }

  // 2️⃣ All Cars - Pie Chart
  Widget _buildAllCarsChart() {
    return _chartContainer(
      title: "Cars Distribution",
      child: PieChart(
        PieChartData(
          sectionsSpace: 3,
          centerSpaceRadius: 35,
          sections: [
            PieChartSectionData(
              value: 40,
              color: AppColors.green,
              title: 'Live',
              radius: 45,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              value: 25,
              color: Colors.orangeAccent,
              title: 'Upcoming',
              radius: 40,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              value: 20,
              color: Colors.blueAccent,
              title: 'Sold',
              radius: 35,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              value: 15,
              color: Colors.redAccent,
              title: 'Otobuy',
              radius: 30,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3️⃣ Upcoming Cars - Line Chart
  Widget _buildUpcomingCarsChart() {
    return _chartContainer(
      title: "Upcoming Cars Trend",
      width: 500,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) => Text(
                  'W${value.toInt() + 1}',
                  style: TextStyle(color: AppColors.grey, fontSize: 12),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 2,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.orangeAccent,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.orangeAccent.withOpacity(0.2),
              ),
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 3),
                FlSpot(2, 2),
                FlSpot(3, 4),
                FlSpot(4, 5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 4️⃣ Live Cars - Radar Chart
  Widget _buildLiveCarsChart() {
    return _chartContainer(
      title: "Live Cars Stats",
      child: RadarChart(
        RadarChartData(
          radarBackgroundColor: AppColors.white,
          radarBorderData: BorderSide(color: Colors.grey.shade300),
          tickCount: 3,
          gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
          radarShape: RadarShape.polygon,
          titleTextStyle: TextStyle(color: AppColors.grey, fontSize: 12),
          titlePositionPercentageOffset: 0.15,

          // ✅ Proper new function type for fl_chart 1.1.1
          getTitle: (index, angle) {
            const titles = [
              'Speed',
              'Mileage',
              'Demand',
              'Stock',
              'Performance',
            ];
            return RadarChartTitle(
              text: titles[index % titles.length],
              // style: TextStyle(
              //   color: AppColors.grey,
              //   fontSize: 12,
              //   fontWeight: FontWeight.w500,
              // ),
            );
          },

          dataSets: [
            RadarDataSet(
              fillColor: Colors.purpleAccent.withOpacity(0.3),
              borderColor: Colors.purpleAccent,
              entryRadius: 3,
              borderWidth: 2,
              dataEntries: const [
                RadarEntry(value: 4),
                RadarEntry(value: 6),
                RadarEntry(value: 8),
                RadarEntry(value: 7),
                RadarEntry(value: 9),
              ],
            ),
          ],
        ),
        swapAnimationDuration: const Duration(milliseconds: 800),
        swapAnimationCurve: Curves.easeInOut,
      ),
    );
  }

  // 5️⃣ Otobuy Cars - Doughnut (Pie with center space)
  Widget _buildOtobuyCarsChart() {
    return _chartContainer(
      title: "Otobuy Cars",
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 40,
          sectionsSpace: 4,
          sections: [
            PieChartSectionData(
              value: 45,
              color: Colors.redAccent,
              title: 'New',
              radius: 45,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              value: 35,
              color: Colors.blueAccent,
              title: 'In Otobuy',
              radius: 40,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              value: 20,
              color: AppColors.green,
              title: 'Sold',
              radius: 35,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 🧱 Reusable Chart Container (for consistent card styling)
  // -------------------------------------------------------------
  Widget _chartContainer({
    required String title,
    required Widget child,
    double width = 400,
  }) {
    return Container(
      width: width,
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.green,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildInfoNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18),
          const SizedBox(width: 10),
          Text(
            "Showing the latest bidding activity. Use the table below to review recent bids, check statuses, and compare amounts at a glance.",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 13.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
