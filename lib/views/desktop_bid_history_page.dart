// lib/features/bids/pages/desktop_bid_history_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/models/bid_summary_model.dart';

import 'package:otobix_crm/utils/app_colors.dart' show AppColors;
import 'package:otobix_crm/widgets/table_widget.dart';

import '../controllers/desktop_bid_history_controller.dart';

class DesktopBidHistoryPage extends StatelessWidget {
  DesktopBidHistoryPage({super.key});

  final DesktopBidHistoryController c =
      Get.put(DesktopBidHistoryController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.error.value != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Failed to load bids',
                  style: TextStyle(
                      color: AppColors.red, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(c.error.value!),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: c.load,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScreenTitle(),
              const SizedBox(height: 20),
              _buildTopReports(c.summary.value),
              const SizedBox(height: 20),
              _buildRecentBidsList(),
            ],
          ),
        );
      }),
    );
  }

  // Screen Title (unchanged)
  Widget _buildScreenTitle() {
    return Row(
      children: [
        Text(
          "Bid History",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Top Reports — now takes server data
  Widget _buildTopReports(BidsSummaryModel? s) {
    String _n(int? v) => (v ?? 0).toString();

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
          title: "Total Bids",
          count: _n(s?.totalBids),
          icon: FontAwesomeIcons.gavel,
        ),
        infoContainer(
          title: "Total Bidders",
          count: _n(s?.totalBidders),
          icon: FontAwesomeIcons.users,
        ),
        infoContainer(
          title: "Bids Today",
          count: _n(s?.todaysBids),
          icon: FontAwesomeIcons.clock,
        ),
        infoContainer(
          title: "Bids This Week",
          count: _n(s?.weeksBids),
          icon: FontAwesomeIcons.calendarWeek,
        ),
      ],
    );
  }

  // Recent Bids List — uses controller data
  Widget _buildRecentBidsList() {
    final columns = const [
      DataColumn(label: Text("Bidder")),
      DataColumn(label: Text("Car")),
      DataColumn(label: Text("Bid Amount")),
      DataColumn(label: Text("Time")),
      DataColumn(label: Text("Status")),
    ];

    final rows = c.bids.map((b) {
      // at top of the widget
      final timeFmt =
          DateFormat('dd MMM yyyy • hh:mm a'); // e.g., 10 Oct 2025 • 03:45 PM

      return DataRow(
        cells: [
          DataCell(Text(b.userName)),
          DataCell(Text(b.car)),
          DataCell(Text("Rs. ${b.bidAmount}/-")),
          DataCell(Text(timeFmt.format(b.time.toLocal()))),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: b.isActive
                    ? AppColors.green.withValues(alpha: 0.15)
                    : AppColors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                b.isActive ? "Active" : "Closed",
                style: TextStyle(
                  color: b.isActive
                      ? AppColors.green.withValues(alpha: 0.7)
                      : AppColors.red.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();

    return TableWidget(title: "Recent Bids", columns: columns, rows: rows);
  }
}
