import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/controllers/desktop_bid_history_controller.dart';
import 'package:otobix_crm/models/bid_summary_model.dart';
import 'package:otobix_crm/utils/app_colors.dart' show AppColors;
import 'package:otobix_crm/widgets/refresh_page_widget.dart';
import 'package:otobix_crm/widgets/table_widget.dart';

class DesktopBidHistoryPage extends StatelessWidget {
  DesktopBidHistoryPage({super.key});

  final DesktopBidHistoryController bidHistoryController =
      Get.put(DesktopBidHistoryController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (bidHistoryController.isPageLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.green));
        }
        if (bidHistoryController.error.value != null) {
          return RefreshPageWidget(
            icon: Icons.error_outline,
            title: "Error Fetching Bids Summary",
            message: bidHistoryController.error.value!,
            actionText: "Refresh",
            onAction: bidHistoryController.load,
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
                _buildTopReports(bidHistoryController.summary.value),
                const SizedBox(height: 30),
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

// Title
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

// Top Reports
  Widget _buildTopReports(BidsSummaryModel? summary) {
    // Number formatter
    String formateNumber(int? v) => (v ?? 0).toString();

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
          title: "Upcoming Bids",
          count: formateNumber(summary?.upcomingBids),
          icon: FontAwesomeIcons.clock,
        ),
        infoContainer(
          title: "Live Bids",
          count: formateNumber(summary?.liveBids),
          icon: FontAwesomeIcons.fire,
        ),
        infoContainer(
          title: "Upcoming Auto Bids",
          count: formateNumber(summary?.upcomingAutoBids),
          icon: FontAwesomeIcons.robot,
        ),
        infoContainer(
          title: "Live Auto Bids",
          count: formateNumber(summary?.liveAutoBids),
          icon: FontAwesomeIcons.bolt,
        ),
        infoContainer(
          title: "Otobuy Offers",
          count: formateNumber(summary?.otobuyOffers),
          icon: FontAwesomeIcons.tags,
        ),
        //
        // infoContainer(
        //   title: "Total Bids",
        //   count: formateNumber(summary?.totalBids),
        //   icon: FontAwesomeIcons.gavel,
        // ),
        // infoContainer(
        //   title: "Total Bidders",
        //   count: formateNumber(summary?.totalBidders),
        //   icon: FontAwesomeIcons.users,
        // ),
        // infoContainer(
        //   title: "Bids Today",
        //   count: formateNumber(summary?.todaysBids),
        //   icon: FontAwesomeIcons.clock,
        // ),
        // infoContainer(
        //   title: "Bids This Week",
        //   count: formateNumber(summary?.weeksBids),
        //   icon: FontAwesomeIcons.calendarWeek,
        // ),
      ],
    );
  }

// Recent Bids List
  Widget _buildRecentBidsList() {
    final timeFormat = DateFormat('dd MMM yyyy • hh:mm a');

    // final homeController = Get.find<DesktopHomepageController>();

    return Obx(() {
      // reacts to both bids and search text
      // final query = homeController.searchText.value;
      // final bidsList = bidHistoryController.filterByAppointmentId(query);
      final bidsList = bidHistoryController.bids; // ✅ use API result directly

      final rows = bidsList.map((bid) {
        return DataRow(
          cells: [
            DataCell(Text(bid.userName)),
            DataCell(Text(bid.dealershipName)),
            DataCell(Text(bid.assignedKam)),
            DataCell(Text(bid.car)),
            DataCell(Text(bid.appointmentId)),
            DataCell(Text("Rs. ${bid.bidAmount}/-")),
            DataCell(Text(timeFormat.format(bid.time.toLocal()))),
            DataCell(
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bid.isActive
                      ? AppColors.green.withValues(alpha: 0.15)
                      : AppColors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  bid.isActive ? "Active" : "Closed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: bid.isActive
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

      // Table Widget
      return TableWidget(
        title: "Recent Bids",
        titleSize: 20,
        height: 500,
        minTableWidth: MediaQuery.of(Get.context!).size.width - 250,
        isLoading: bidHistoryController.isBidsLoading.value,
        rows: rows,
        columns: [
          DataColumn(
              label: Text("Bidder",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Dealership Name",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Assigned KAM",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Car Name",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Appointment ID",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text(
                  bidHistoryController.selectedFilter.value ==
                          DesktopBidHistoryController.otobuyOffersFilter
                      ? "Offer Amount"
                      : "Bid Amount",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text("Time", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Status",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        // Ensure length == columns.length
        columnWidths: const [100, 150, 150, 250, 150, 100, 200, 80],
        titleWidget: _buildTitleWidget(),
        actionsWidget: _buildActionWidget(),
        emptyDataWidget: Text(
          // 'No ${bidHistoryController.selectedFilter.value} bids for ${bidHistoryController.selectedRange.value}',
          'No ${DesktopBidHistoryController.bidFiltersLabel(bidHistoryController.selectedFilter.value)} for ${DesktopBidHistoryController.timeRangeLabels(bidHistoryController.selectedRange.value)}',

          style: TextStyle(
            color: AppColors.green,
            fontSize: 18,
          ),
        ),
      );
    });
  }

// Pager Widget
  Widget _buildPager() {
    // Helper to build a compact set of visible pages with ellipses
    List<dynamic> visiblePages(int current, int total) {
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

    Widget pageChip(dynamic item, bool isActive) {
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
          onTap: () => bidHistoryController.goToPage(pageNum),
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
      final current = bidHistoryController.page.value;
      final total = bidHistoryController.totalPages.value;

      // Build jump controller with current page prefilled
      final jumpController = TextEditingController(text: current.toString());

      final pageItems = visiblePages(current, total);

      return Row(
        children: [
          // Left: Prev
          OutlinedButton.icon(
            onPressed: bidHistoryController.hasPrev.value
                ? bidHistoryController.prevPage
                : null,
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
                      .map((it) => pageChip(it, it is int && it == current)),

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
                              bidHistoryController.goToPage(p);
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
                              bidHistoryController.goToPage(p);
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
            onPressed: bidHistoryController.hasNext.value
                ? bidHistoryController.nextPage
                : null,
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

// Table Title Widget
  Widget _buildTitleWidget() {
    return Obx(() {
      return Row(
        children: [
          // Text(
          //   "Bid History",
          //   style: TextStyle(
          //     color: AppColors.black,
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),

          // const SizedBox(width: 20),

          // Filter chips (Upcoming | Live | Auto | Otobuy)
          Wrap(
            spacing: 8,
            children: bidHistoryController.filters.map((filter) {
              final isSelected =
                  bidHistoryController.selectedFilter.value == filter;

              final labelText =
                  DesktopBidHistoryController.bidFiltersLabel(filter);

              return ChoiceChip(
                label: Text(
                  labelText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.green : AppColors.black,
                  ),
                ),
                showCheckmark: false,
                selected: isSelected,
                selectedColor: AppColors.green.withValues(alpha: .15),
                backgroundColor: AppColors.white,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.green
                        : AppColors.grey.withValues(alpha: .5),
                  ),
                ),
                onSelected: (selectedFilter) {
                  if (selectedFilter) bidHistoryController.changeFilter(filter);
                },
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  // Table Action Widget
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
                value: bidHistoryController.selectedRange.value,
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
                onChanged: (selectedRangeValue) {
                  if (selectedRangeValue == null) return;
                  bidHistoryController.changeRange(selectedRangeValue);
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
