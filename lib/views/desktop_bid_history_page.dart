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
          return const Center(
              child: CircularProgressIndicator(color: AppColors.green));
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

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScreenTitle(),
                const SizedBox(height: 20),
                _buildTopReports(c.summary.value),
                const SizedBox(height: 20),
                _buildRecentBidsList(),
                const SizedBox(height: 8),
                _buildPager(),
              ],
            ),
          ),
        );
      }),
    );
  }

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

  Widget _buildRecentBidsList() {
    final timeFmt = DateFormat('dd MMM yyyy • hh:mm a');

    final rows = c.bids.map((b) {
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

    // 🔒 Fixed height, scrolls vertically (and horizontally if needed)
    return TableWidget(
      title: "Recent Bids",
      titleSize: 20,
      height: 500, // ⬅️ change this to the height you want
      minTableWidth: MediaQuery.of(Get.context!).size.width - 250,
      // columns: columns,
      isLoading: c.isBidsLoading.value,
      rows: rows,
      columns: const [
        DataColumn(
            label:
                Text("Bidder", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text("Car", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text("Bid Amount",
                style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text("Time", style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label:
                Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      // rows: myRows,
      // Ensure length == columns.length
      columnWidths: const [100, 250, 100, 200, 80],
      actionsWidget: _buildActionWidget(),
    );
  }

  Widget _buildPager() {
    // Helper to build a compact set of visible pages with ellipses
    List<dynamic> _visiblePages(int current, int total) {
      if (total <= 7) {
        return List<int>.generate(total, (i) => i + 1);
      }

      final start = (current - 2).clamp(1, total);
      final end = (current + 2).clamp(1, total);

      final set = <int>{1, total};
      for (int i = start; i <= end; i++) set.add(i);

      final pages = set.toList()..sort();

      // Insert "…" where gaps exist
      final withDots = <dynamic>[];
      for (int i = 0; i < pages.length; i++) {
        withDots.add(pages[i]);
        if (i < pages.length - 1 && pages[i + 1] != pages[i] + 1) {
          withDots.add('…');
        }
      }
      return withDots;
    }

    Widget _pageChip(dynamic item, bool isActive) {
      if (item is String) {
        // Ellipsis
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text('…',
              style: TextStyle(color: AppColors.grey.withValues(alpha: .9))),
        );
      }

      final int pageNum = item as int;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () => c.goToPage(pageNum),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.green.withValues(alpha: .15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isActive
                    ? AppColors.green
                    : AppColors.grey.withValues(alpha: .5),
              ),
            ),
            child: Text(
              '$pageNum',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.green : AppColors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Obx(() {
      final current = c.page.value;
      final total = c.totalPages.value;

      // Build jump controller with current page prefilled
      final jumpController = TextEditingController(text: current.toString());

      final pageItems = _visiblePages(current, total);

      return Row(
        children: [
          // Left: Prev
          OutlinedButton.icon(
            onPressed: c.hasPrev.value ? c.prevPage : null,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Prev'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.green, // text & icon
              side: const BorderSide(color: AppColors.green), // outline
            ),
          ),

          // Center: numbered pages + "Go to"
          Expanded(
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Page numbers
                  ...pageItems
                      .map((it) => _pageChip(it, it is int && it == current)),

                  const SizedBox(width: 16),

                  // Go to page
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.grey.withValues(alpha: .6)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: jumpController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Page',
                              isDense: true,
                            ),
                            onSubmitted: (value) {
                              final p = int.tryParse(value.trim());
                              if (p == null) return;
                              if (p < 1 || p > total) return;
                              c.goToPage(p);
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              final p =
                                  int.tryParse(jumpController.text.trim());
                              if (p == null) return;
                              if (p < 1 || p > total) return;
                              c.goToPage(p);
                            },
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                elevation: 0,
                                foregroundColor: AppColors.green),
                            child: const Text('Go'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right: Next
          OutlinedButton.icon(
            onPressed: c.hasNext.value ? c.nextPage : null,
            icon: const Icon(Icons.chevron_right),
            label: const Text('Next'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.green, // text & icon
              side: const BorderSide(color: AppColors.green), // outline
            ),
          ),
        ],
      );
    });
  }

  Widget _buildActionWidget() {
    return Obx(() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Showing:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 40,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: c.selectedRange.value,
                alignment: AlignmentDirectional.centerStart,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                borderRadius: BorderRadius.circular(5),
                items: const [
                  DropdownMenuItem(value: 'today', child: Text('Today')),
                  DropdownMenuItem(value: 'week', child: Text('This Week')),
                  DropdownMenuItem(value: 'month', child: Text('This Month')),
                  DropdownMenuItem(value: 'year', child: Text('This Year')),
                  DropdownMenuItem(value: 'all', child: Text('All Time')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  c.changeRange(v);
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
