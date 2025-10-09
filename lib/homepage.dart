import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Add fl_chart in pubspec.yaml

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 230,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Row(
                  children: [
                    Image.asset(
                      'lib/assets/images/logo.png',
                      height: 40,
                    ), // replace with your logo
                    const SizedBox(width: 8),
                    const Text(
                      "OTOBIX",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D6A4F),
                  ),
                ),
                const SizedBox(height: 20),
                sidebarItem(Icons.people_outline, "Customer"),
                sidebarItem(Icons.schedule_outlined, "Schedule"),
                sidebarItem(Icons.engineering_outlined, "Ins.Eng"),
                sidebarItem(Icons.bar_chart_outlined, "Reports"),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top search bar + profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 400,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const CircleAvatar(
                        backgroundImage: AssetImage("assets/profile.jpg"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Info cards row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      InfoCard(
                        title: "Total Customers",
                        value: "14",
                        icon: Icons.people_outline,
                        color: Color(0xFF2D6A4F),
                      ),
                      InfoCard(
                        title: "Inspection Schedule",
                        value: "06",
                        icon: Icons.calendar_today_outlined,
                        color: Color(0xFFFF7B00),
                      ),
                      InfoCard(
                        title: "Inspected",
                        value: "04",
                        icon: Icons.assignment_turned_in_outlined,
                        color: Color(0xFF00B4D8),
                      ),
                      InfoCard(
                        title: "Reports",
                        value: "04",
                        icon: Icons.description_outlined,
                        color: Color(0xFFFAB005),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Recent Customers Table
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Recent Customers",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D6A4F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Car No')),
                            DataColumn(label: Text('Make')),
                            DataColumn(label: Text('Model')),
                            DataColumn(label: Text('Variant')),
                            DataColumn(label: Text('Year Of Mfg')),
                            DataColumn(label: Text('Ownership Serial No')),
                            DataColumn(label: Text('Colour')),
                            DataColumn(label: Text('Odometer Reading')),
                          ],
                          rows: const [
                            DataRow(
                              cells: [
                                DataCell(Text("Rahul Verma")),
                                DataCell(Text("+91 98765 43210")),
                                DataCell(Text("MH12AB1234")),
                                DataCell(Text("Honda")),
                                DataCell(Text("City")),
                                DataCell(Text("V Petrol CVT")),
                                DataCell(Text("2019")),
                                DataCell(Text("OSN-2019-0001")),
                                DataCell(Text("Metallic Silver")),
                                DataCell(Text("42,356 km")),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Text("Aisha Khan")),
                                DataCell(Text("+91 91234 56789")),
                                DataCell(Text("DL3CA4321")),
                                DataCell(Text("Toyota")),
                                DataCell(Text("Innova Crysta")),
                                DataCell(Text("GX Diesel")),
                                DataCell(Text("2021")),
                                DataCell(Text("OSN-2021-0456")),
                                DataCell(Text("Pearl White")),
                                DataCell(Text("28,745 km")),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Text("Rohan Mehta")),
                                DataCell(Text("+91 98765 43210")),
                                DataCell(Text("MH12AB9876")),
                                DataCell(Text("Hyundai")),
                                DataCell(Text("Creta")),
                                DataCell(Text("SX Petrol")),
                                DataCell(Text("2019")),
                                DataCell(Text("OSN-2022-0731")),
                                DataCell(Text("Phantom Black")),
                                DataCell(Text("12,560 km")),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Bar Chart
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Customers",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D6A4F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 250,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
                                      const months = [
                                        'Jan',
                                        'Feb',
                                        'Mar',
                                        'Apr',
                                        'May',
                                        'Jun',
                                        'Jul',
                                        'Aug',
                                        'Sept',
                                        'Oct',
                                        'Nov',
                                        'Dec',
                                      ];
                                      return Text(months[value.toInt() % 12]);
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                makeGroupData(0, 60),
                                makeGroupData(1, 30),
                                makeGroupData(2, 70),
                                makeGroupData(3, 15),
                                makeGroupData(4, 65),
                                makeGroupData(5, 72),
                                makeGroupData(6, 35),
                                makeGroupData(7, 18),
                                makeGroupData(8, 78),
                                makeGroupData(9, 68),
                                makeGroupData(10, 71),
                                makeGroupData(11, 80),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar item widget
  static Widget sidebarItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // Bar chart helper
  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y, width: 18, color: const Color(0xFF2D6A4F)),
      ],
    );
  }
}

// Info card widget
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
