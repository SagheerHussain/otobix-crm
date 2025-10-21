import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/controllers/desktop_homepage_controller.dart';
import 'package:otobix_crm/models/car_summary_model.dart';
import 'package:otobix_crm/models/cars_list_model.dart';
import 'package:otobix_crm/utils/app_colors.dart' show AppColors;
import 'package:otobix_crm/widgets/refresh_page_widget.dart';
import 'package:otobix_crm/widgets/table_widget.dart';
import 'package:otobix_crm/widgets/pager_widget.dart';

import '../controllers/desktop_cars_controller.dart';

class DesktopCarsPage extends StatelessWidget {
  DesktopCarsPage({super.key});

  final DesktopCarsController carsController =
      Get.put(DesktopCarsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (carsController.isPageLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green),
          );
        }

        if (carsController.pageError.value != null) {
          return RefreshPageWidget(
            icon: Icons.cloud_off,
            title: "Couldn't load page data",
            message: carsController.pageError.value!,
            actionText: "Refresh",
            onAction: carsController.reload,
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

                // Summary
                Obx(() {
                  if (carsController.isSummaryLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child:
                            CircularProgressIndicator(color: AppColors.green),
                      ),
                    );
                  }
                  if (carsController.summaryError.value != null) {
                    return RefreshPageWidget(
                      icon: Icons.error_outline,
                      title: "Error Fetching Cars Summary",
                      message: carsController.summaryError.value!,
                      actionText: "Refresh",
                      onAction: carsController.reload,
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopReports(carsController.carSummary.value),
                      const SizedBox(height: 30),
                      _buildCarsList(context),
                      const SizedBox(height: 20),
                      _buildPager(), // <-- new reusable pager
                    ],
                  );
                }),
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
          "Cars Overview",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Top Reports (unchanged)
  Widget _buildTopReports(CarSummaryModel? summary) {
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
          title: "Total Cars",
          count: formateNumber(summary?.totalCars),
          icon: FontAwesomeIcons.car,
        ),
        infoContainer(
          title: "Upcoming Cars",
          count: formateNumber(summary?.upcomingCars),
          icon: FontAwesomeIcons.clock,
        ),
        infoContainer(
          title: "Live Cars",
          count: formateNumber(summary?.liveCars),
          icon: FontAwesomeIcons.fire,
        ),
        infoContainer(
          title: "Auction Ended Cars",
          count: formateNumber(summary?.auctionEndedCars),
          icon: FontAwesomeIcons.stopwatch,
        ),
        infoContainer(
          title: "Otobuy Cars",
          count: formateNumber(summary?.otobuyCars),
          icon: FontAwesomeIcons.tags,
        ),
      ],
    );
  }

  // ----------------- Cars Table -----------------
  Widget _buildCarsList(BuildContext context) {
    return Obx(() {
      // final cars = carsController.carsList;

// Search using appointment id
      final homeController = Get.find<DesktopHomepageController>();
      final query = homeController.searchText.value;
      final carsList = carsController.filterByAppointmentId(query);

      final rows = carsList.map((car) {
        final statusText = DesktopCarsController.filterLabel(car.auctionStatus);

        return DataRow(
          onSelectChanged: (selected) {
            if (selected ?? false) {
              _showCarDetails(context, car);
            }
          },
          cells: [
            // Car Image
            DataCell(
              (car.thumbnailUrl.isEmpty)
                  ? const SizedBox.shrink()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        car.thumbnailUrl,
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            // Car Title
            DataCell(Text(car.title)),
            // Appointment
            DataCell(Text(car.appointmentId)),
            // City
            DataCell(Text(car.city)),
            // Odometer
            DataCell(Text(
                '${NumberFormat.decimalPattern('en_IN').format(car.odometerKm)} km')),
            // Highest Bid
            DataCell(Text(
                'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid)}/-')),
            // Status chip
            DataCell(
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.green.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList();

      return TableWidget(
        title: "Cars List",
        titleSize: 20,
        height: 500,
        minTableWidth: MediaQuery.of(context).size.width - 250,
        isLoading: carsController.isCarsListLoading.value,
        rows: rows,
        columns: const [
          DataColumn(
              label:
                  Text("Image", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Appointment ID",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text("City", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Odometer",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Highest Bid",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Status",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        // Ensure length == columns.length
        columnWidths: const [
          50,
          250,
          160,
          120,
          120,
          140,
          140,
        ],
        titleWidget: _buildTitleWidget(),
        // no range actions for cars list
        actionsWidget: const SizedBox.shrink(),
        emptyDataWidget: const Text(
          'No Cars',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 18,
          ),
        ),
      );
    });
  }

  // ----------------- Pager -----------------
  Widget _buildPager() {
    return Obx(() {
      return PagerWidget(
        current: carsController.page.value,
        total: carsController.totalPages.value,
        hasPrev: carsController.hasPrev.value,
        hasNext: carsController.hasNext.value,
        onPrev: carsController.prevPage,
        onNext: carsController.nextPage,
        onGoTo: carsController.goToPage,
      );
    });
  }

  // ----------------- Filters row -----------------
  Widget _buildTitleWidget() {
    return Obx(() {
      return Row(
        children: [
          Wrap(
            spacing: 8,
            children: carsController.filters.map((filter) {
              final isSelected = carsController.selectedFilter.value == filter;
              final labelText = DesktopCarsController.filterLabel(filter);

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
                onSelected: (selected) {
                  if (selected) carsController.changeFilter(filter);
                },
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  void _showCarDetails(BuildContext context, CarsListModel car) {
    Get.dialog(
      Dialog(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (car.thumbnailUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(car.thumbnailUrl, height: 180),
                ),
              const SizedBox(height: 10),
              Text(car.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _detailRow('Appointment ID', car.appointmentId),
              _detailRow('City', car.city),
              _detailRow('Odometer',
                  '${NumberFormat.decimalPattern('en_IN').format(car.odometerKm)} km'),
              _detailRow('Highest Bid',
                  'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid)}/-'),
              _detailRow('Status',
                  DesktopCarsController.filterLabel(car.auctionStatus)),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: Get.back,
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 150,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }
}
