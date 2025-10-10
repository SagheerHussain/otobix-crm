import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:otobix_crm/utils/app_colors.dart' show AppColors;

class DesktopDashboardPage extends StatelessWidget {
  const DesktopDashboardPage({super.key});

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

  // Top Reports
  Widget _buildTopReports() {
    // Info Container
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
          border: Border.all(color: AppColors.grey.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 25, color: AppColors.green),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: AppColors.grey.withValues(alpha: 0.7),
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

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        infoContainer(
          title: "Total Dealers",
          count: "14",
          icon: FontAwesomeIcons.userTie,
        ),
        infoContainer(
          title: "Total Cars",
          count: "06",
          icon: FontAwesomeIcons.car,
        ),
        infoContainer(
          title: "Upcoming Cars",
          count: "04",
          icon: FontAwesomeIcons.calendarPlus,
        ),
        infoContainer(
          title: "Live Cars",
          count: "09",
          icon: FontAwesomeIcons.circlePlay,
        ),
        infoContainer(
          title: "Otobuy Cars",
          count: "04",
          icon: FontAwesomeIcons.cartShopping,
        ),
      ],
    );
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
    return _chartContainer(
      title: "Dealers Overview",
      width: 600,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const labels = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  return Text(
                    labels[value.toInt() % labels.length],
                    style: TextStyle(color: AppColors.grey, fontSize: 12),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(toY: 4, color: AppColors.green, width: 20),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(toY: 7, color: AppColors.green, width: 20),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(toY: 5, color: AppColors.green, width: 20),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(toY: 8, color: AppColors.green, width: 20),
              ],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(toY: 6, color: AppColors.green, width: 20),
              ],
            ),
            BarChartGroupData(
              x: 5,
              barRods: [
                BarChartRodData(toY: 6, color: AppColors.green, width: 20),
              ],
            ),
            BarChartGroupData(
              x: 6,
              barRods: [
                BarChartRodData(toY: 6, color: AppColors.green, width: 20),
              ],
            ),
          ],
        ),
      ),
    );
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
          const SizedBox(height: 10),
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
